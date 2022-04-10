extends Node

var next_scene = null

onready var animation_player = $AnimationPlayer
onready var current_scene = $Menus

var dir_path = "user://"	# path to storage

func _ready():
	current_scene.connect("scene_changed", self, "handle_scene_change")


func handle_scene_change(curr_level_name):
	match curr_level_name:
		"menu":
			next_scene = load("res://Battle.tscn").instance()
		"battle":
			next_scene = load("res://UIMenu/Menus.tscn").instance()
		_:	# invalid name
			return
	
	animation_player.play("fade_in")
	next_scene.connect("scene_changed", self, "handle_scene_change")	# connect change signal
	transfer_data_between_scenes(current_scene, next_scene)

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			add_child(next_scene)
			current_scene.queue_free()	# free previous scene, and then switch to new one
			current_scene = next_scene
			next_scene = null
			animation_player.play("fade_out")
			
		"fade_out":
			pass


func transfer_data_between_scenes(old_scene, new_scene):
	if(old_scene.scene_name == "menu"):
		var fileContainer = $Menus/Control/QuestionMenu/FileContainer
		var question_set = fileContainer.read_question_set(dir_path + fileContainer.selected_name)
		new_scene.question_set = question_set

