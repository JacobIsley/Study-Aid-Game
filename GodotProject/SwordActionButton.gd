extends "res://ActionButton.gd"

const Slash = preload("res://Slash.tscn")

func _on_pressed():
	var main = get_tree().current_scene
	var enemy = main.find_node("Enemy")
	var playerStats = main.find_node("PlayerStats")
	if enemy != null:
		create_slash(enemy.position)
		enemy.take_damage(4)
		playerStats.mp += 2
		playerStats.ap -= 1
		
func create_slash(position):
	var slash = Slash.instance()
	var main = get_tree().current_scene
	main.add_child(slash)
	slash.global_position = position
