extends Node2D

const BattleUnits = preload("res://BattleUnits.tres")

export(Array, PackedScene) var enemies = []

onready var buttons = $UI/BattleActionButtons
onready var animationPlayer = $AnimationPlayer
onready var nextRoomButton = $UI/CenterContainer/NextRoomButton
onready var enemyPostion = $EnemyPosition
onready var colorblindFilter = $ColorblindFilter

export var scene_name = "battle"	# identifier for current scene
signal scene_changed(scene_name)	# signal for changing scene back to main menu

var colorblind = false

# Question functionality variables
var question_set = {}	# set from other scene! Neat!
var question_count = 0
var question_list = []	# list element 0 is question, list element 1-3 are options
var answer_list = []	# list of letter answers for each question

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
	print("Caught it: " + str(question_list))

func start_enemy_turn():
	buttons.hide()
	var enemy = BattleUnits.Enemy
	if enemy != null and not enemy.is_queued_for_deletion():
		enemy.attack()
		yield(enemy, "end_turn")
	start_player_turn()

func start_player_turn():
	buttons.show()
	var playerStats = BattleUnits.PlayerStats
	playerStats.ap = playerStats.max_ap
	
	yield(playerStats, "end_turn")
	start_enemy_turn()

func create_new_enemy():
	enemies.shuffle()
	var Enemy = enemies.front()
	var enemy = Enemy.instance()
	enemyPostion.add_child(enemy)
	enemy.connect("died", self, "_on_Enemy_died")
	
func _on_Enemy_died():
	nextRoomButton.show()
	buttons.hide()

func _on_NextRoomButton_pressed():
	nextRoomButton.hide()
	animationPlayer.play("FadeToNewRoom")
	yield(animationPlayer, "animation_finished")
	var playerStats = BattleUnits.PlayerStats
	playerStats.ap = playerStats.max_ap
	buttons.show()
	create_new_enemy()


func _on_HomeButton_pressed():
	emit_signal("scene_changed", scene_name)


func _on_ColorButton_pressed():
	colorblind = !colorblind
	if(colorblind):
		colorblindFilter.show()
	else:
		colorblindFilter.hide()
