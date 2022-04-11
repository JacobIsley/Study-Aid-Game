extends ScrollContainer

onready var container = $VBoxContainer

signal show_buttons(value) # for showing the go and delete buttons

var Button = preload("res://UIMenu/QuestionButton.tscn")
var dir_path = "user://"	# path to storage
var question_database = {}	# holds all of the question data
var selected_name = null	# the current selected set

# set up a button for every file in storage at launch
func _ready():	
	var dir = Directory.new()
	if dir.open(dir_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if ".txt" in file_name:
					add_button(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


# read a question set and return set data if able
func read_question_set(file_path:String):	
	var file = File.new()
	if file.file_exists(file_path):
		if file.open(file_path, File.READ) == OK:
			var file_name = file_path.split("//")[-1]
			var set_data:Dictionary = file.get_var()
			file.close()
			if set_data.has_all(["q_count","question_list","answer_list"]):
				question_database[file_name] = set_data
				return set_data
			
		else:
			return {} # return empty dictionary
	return {}


# add a button to the vcontainer if the set data is not empty
func add_button(file_name:String):	
	# add button to scroll
	var file_path = dir_path + file_name
	var set_data:Dictionary = read_question_set(file_path)
	if not set_data.empty():
		var button = Button.instance()
		container.add_child(button)
		button.set_button_text(file_name)
		button.set_label_number(set_data["q_count"])
		button.connect("pressed", self, "select_set", [file_name, button])


func select_set(file_name, button):
	if(selected_name != file_name):
		for old in container.get_children():
			if old.text == selected_name:
				old.is_selected(false)
		selected_name = file_name
		button.is_selected(true)
		emit_signal("show_buttons", true)
		
	else:
		emit_signal("show_buttons", false)
		selected_name = null
		button.is_selected(false)


func _on_FileLoader_file_added(file_name):
	add_button(file_name)


# Delete the selected set from the button list, the database, and set selected set to null
func _on_DeleteButton_pressed():
	for file in container.get_children():	# remove from button list
		if file.text == selected_name:
			container.remove_child(file)
			
	var present = question_database.erase(selected_name)
	if not present:	# remove from database
		print("Tried to delete " + selected_name + " but it wasn't in the database!")
		
	var _status = delete_file(dir_path + selected_name)	# remove from stored files
	
	selected_name = null
	emit_signal("show_buttons", false)


func delete_file(file_path):	# delete a file from the stored files
	var dir = Directory.new()
	var file = File.new()
	if file.file_exists(file_path) and dir.open(dir_path) == OK:
		return dir.remove(file_path)
