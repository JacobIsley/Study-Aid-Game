extends Node2D

const BattleUnits = preload("res://BattleUnits.tres")

var Abutton = preload("res://AnswerButton.tscn")
var Wbutton = preload("res://WrongButton.tscn")
var QMark = preload("res://UIMenu/QuestionMark.tscn")

export(Array, PackedScene) var enemies = []

onready var question_buttons = $UI/QuestionButtons
onready var sword_button = $UI/BattleActionButtons/SwordActionButton
onready var special_button = $UI/BattleActionButtons/SpecialAttackActionButton
onready var heal_button = $UI/BattleActionButtons/HealActionButton
onready var action_buttons = $UI/BattleActionButtons
onready var q_container = $UI/QuestionButtons/QButtonContainer
onready var nextRoomButton = $UI/CenterContainer/NextRoomButton

onready var numberPanel = $UI/NumberPanel
onready var statsPanel = $UI/StatsPanel
onready var text_box = $UI/TextboxPanel/Textbox
onready var animationPlayer = $AnimationPlayer
onready var enemyPostion = $EnemyPosition
onready var colorblindFilter = $ColorblindFilter
onready var endScreen = $UI/EndScreen

export var scene_name = "battle"	# identifier for current scene
signal scene_changed(scene_name)	# signal for changing scene back to main menu
signal question_answered

var colorblind = false
var muted = false
# Question functionality variables
var question_set = {}	# set from other scene! Neat!
var question_count = 0
var question_list = []	# list element 0 is question, list element 1-3 are options
var answer_list = []	# list of letter answers for each question
var wrong_list = []		# list of all wrong question/answer combinations
var num_correct = 0
var num_answered = 0
var average:String = "0"	# accuracy
var just_answered = false	# status of most recent questiona answered

var level_two
var level_three
var elow_bound = 0


func _ready():
	randomize()
	init_questions()
	start_player_turn()
	
	var enemy = BattleUnits.Enemy
	if enemy != null:
		enemy.connect("died", self, "_on_Enemy_died")


# initializes the question lists and variables from the question_set
func init_questions():
	question_count = question_set["q_count"]
	question_list = question_set["question_list"]
	answer_list = question_set["answer_list"]
	level_two = question_count/3
	level_three = level_two * 2


func start_enemy_turn():
	action_buttons.hide()
	var enemy = BattleUnits.Enemy
	if enemy != null and not enemy.is_queued_for_deletion():
		enemy.attack()
		yield(enemy, "end_turn")
	start_player_turn()


func start_player_turn():
	numberPanel.show()
	
	var enemy = BattleUnits.Enemy

	if enemy != null and not enemy.is_queued_for_deletion():
		action_buttons.show()

		var playerStats = BattleUnits.PlayerStats
		playerStats.ap = playerStats.max_ap
		
		yield(playerStats, "end_turn")
		start_enemy_turn()


func create_new_enemy():
	var i = randi() % 6 + elow_bound
	var Enemy = enemies[i]
	var enemy = Enemy.instance()
	BattleUnits.Enemy = enemy
	enemyPostion.add_child(enemy)
	enemy.connect("died", self, "_on_Enemy_died")


func _on_Enemy_died():
	#nextRoomButton.show()
	BattleUnits.Enemy = null
	action_buttons.hide()
	
	animationPlayer.play("Goodjob")
	yield(animationPlayer, "animation_finished")
	
	start_question_round()


func _on_NextRoomButton_pressed():
	nextRoomButton.hide()
	animationPlayer.play("FadeIn")
	yield(animationPlayer, "animation_finished")
	var playerStats = BattleUnits.PlayerStats
	playerStats.ap = playerStats.max_ap
	create_new_enemy()
	animationPlayer.play("FadeOut")
	yield(animationPlayer, "animation_finished")
	start_player_turn()


func _on_HomeButton_pressed():
	emit_signal("scene_changed", scene_name)


func _on_ColorButton_pressed():
	colorblind = !colorblind
	if(colorblind):
		colorblindFilter.show()
	else:
		colorblindFilter.hide()


# pick a question, mix options and set up their buttons, update text prompt. Heal if right, nothing if wrong
func start_question_round():
	animationPlayer.play("FadeIn")
	yield(animationPlayer, "animation_finished")
	
	if question_list.size() > 0:
		numberPanel.hide()
		add_mark()
		question_buttons.show()
		var q_num = randi() % question_list.size()
		var q_list = question_list[q_num]
		var question = q_list[0]
		var answer = answer_list[q_num]
		var options = []
		
		text_box.set_text(str(num_answered+1) + ": " + question)
		
		for i in range(q_list.size()):	# get options
			if i != 0:
				options.append(q_list[i])
		
		options.shuffle()
		
		for o in options:
			if o == answer:
				add_answer_button(o)
			else:
				add_wrong_button(o)
		
		animationPlayer.play("FadeOut")
		yield(animationPlayer, "animation_finished")
		
		yield(self, "question_answered")
		
		
		
		# remove question that was just answered
		question_list.pop_at(q_num)
		answer_list.pop_at(q_num)
		if not just_answered:	# answered incorrectly
			var pair = [question, answer]
			wrong_list.append(pair)
			
		# cleanup. remove buttons, hide panel, set text to "", show next room button
		remove_question_buttons()
		question_buttons.hide()
		text_box.set_text("")
		update_level()	# check if level up should occur
		nextRoomButton.show()
	
	else:	# no more questions to answer, end game
		_on_PlayerStats_end_game()


func update_level():
	if num_answered == level_two:
		sword_button.damage = 5
		heal_button.heal_amount = 7
		special_button.damage = 10
		elow_bound = 6
		numberPanel.update_numbers(5, 10, 7)
		
	elif num_answered == level_three:
		sword_button.damage = 7
		heal_button.heal_amount = 10
		special_button.damage = 15
		elow_bound = 12
		numberPanel.update_numbers(7, 15, 10)


func add_answer_button(text:String):
	var button = Abutton.instance()
	q_container.add_child(button)
	button.set_button_text(text)
	button.connect("pressed", self, "_on_Question_Button_pressed", [button.correct])


func add_wrong_button(text:String):
	var button = Wbutton.instance()
	q_container.add_child(button)
	button.set_button_text(text)
	button.connect("pressed", self, "_on_Question_Button_pressed", [button.correct])


func _on_Question_Button_pressed(correct:bool):
	num_answered += 1
	remove_mark()
	
	for button in q_container.get_children():
		button.disabled = true
	
	if correct:
		# play animation, heal X points
		num_correct += 1
		var playerStats = BattleUnits.PlayerStats	#recover all stats on right answer
		playerStats.hp = playerStats.max_hp
		playerStats.ap = playerStats.max_ap
		playerStats.mp = playerStats.max_mp

		animationPlayer.play("Goodjob")
		yield(animationPlayer, "animation_finished")
		
	else:
		# play animation
		animationPlayer.play("TooBad")
		yield(animationPlayer, "animation_finished")
	
	# compute the average in string form rounded to a %
	average = str((float(num_correct) / num_answered) * 100)
	if average.length() > 2 and average != "100":
		average = average.substr(0,2)

	just_answered = correct
	emit_signal("question_answered")

func remove_question_buttons():
	for child in q_container.get_children():
		q_container.remove_child(child)


func build_end_string() -> String:
	var ret = "You answered " + str(num_answered) + " questions,\n and had an accuracy of " + average + "%\n"
	ret += "\nQuestions to review:\n\n"
	if wrong_list:
		for set in wrong_list:
			ret += set[0] + "\n"
			ret += "	ANSWER: " + set[1] + "\n\n"
	else:
		ret += "	None, nice work!\n\n"
	
	ret += "Thank you for playing!!"
	return ret


func add_mark():
	var q = QMark.instance()
	enemyPostion.add_child(q)

func remove_mark():
	enemyPostion.remove_child(enemyPostion.get_child(0))


func _on_PlayerStats_end_game():
	animationPlayer.play("FadeIn")
	yield(animationPlayer, "animation_finished")
	
	action_buttons.hide()
	question_buttons.hide()
	statsPanel.hide()
	enemyPostion.hide()
	endScreen.set_label(build_end_string())
	endScreen.show()
	text_box.set_text("Game Over!!\n\nExit to the main menu when finished reading")
	
	animationPlayer.play("FadeOut")
	yield(animationPlayer, "animation_finished")


func _on_MuteButton_pressed():
	muted = !muted
	var master_sound = AudioServer.get_bus_index("Master")
	if muted:
		AudioServer.set_bus_mute(master_sound, true)
	else:
		AudioServer.set_bus_mute(master_sound, false)
