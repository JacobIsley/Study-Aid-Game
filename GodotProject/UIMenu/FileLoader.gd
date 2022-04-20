extends Control

onready var displayText = $DisplayText

var filePath:String
var loadedFile:File = File.new()
var fileName:String
var question_list = [] # list element 0 is question, list element 1-3 are options
var answer_list = [] # list of letter answers for each question
var q_count = 0	# num questions
var a_count = 0 # num answers

var save_path = "user://"

signal file_added(file_name)

func _ready():
	#connect signal for dropped file
	var can_drop = get_tree().connect("files_dropped", self, "get_dropped_file_path")
	if can_drop:
		displayText.text = "Something went wrong!"


# catches multiple files as arg in case many are dropped
func get_dropped_file_path(files:PoolStringArray, _screen:int)->void:
	# Load the first file in the array
	filePath = files[0]
	get_file_name()
	set_display_text()


func get_file_name():
	var parts = filePath.split("\\")
	fileName = parts[-1]


func set_display_text()->void:
	var sentinal = loadedFile.open(filePath, File.READ) # Open file for reading
	if not sentinal and ".txt" in fileName:
		# parse the individual lines
		var line = loadedFile.get_line()
		while not loadedFile.eof_reached():
			parse_line(line)
			line = loadedFile.get_line() # increment line
	
		q_count = question_list.size()
		a_count = answer_list.size()	
		if read_properly():
			save_question_set()

	else:
		displayText.text = fileName + " couldn't be loaded"
		
	loadedFile.close()
	
	# pass data into some database for all of the options, and forward to the game scene

# parse a given line into a question, option, or answer
func parse_line(line:String):
	var parts = line.split(":")
	
	if parts.size() > 1:
		if "QUESTION" in parts[0]: # if question add to question list, allocate new option list for q
			question_list.push_back([parts[1]])
		elif "ANSWER" in parts[0]: # same for answer list, no option alloc
			answer_list.push_back(parts[1])
			question_list[-1].push_back(parts[1])
		else:
			question_list[-1].push_back(parts[1]) # put option into corresponding q list
	

func save_question_set():
	var file = File.new()
	var new_path = save_path + "//" + fileName
	var data = {
		"q_count" : q_count,
		"question_list" : question_list,
		"answer_list" : answer_list,
	}
	var err = file.open(new_path, File.WRITE)
	if err == OK:
		file.store_var(data)
		file.close()
		emit_signal("file_added", fileName)
	else:
		displayText.text = "Error when saving " + fileName


func read_properly():	# check that the file was read properly

	if(q_count == 0 or a_count == 0):
		displayText.text = fileName + " was loaded, but couldn't be processed."
		return false
	elif a_count != q_count:
		displayText.text = fileName + " was loaded, but has syntax errors."
		return false
	else:
		displayText.text = fileName + " was loaded!"
		return true
