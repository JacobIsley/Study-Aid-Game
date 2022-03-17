extends "res://ActionButton.gd"

func _on_pressed():
	var main = get_tree().current_scene
	var player = main.find_node("PlayerStats")
	if player != null:
		if player.mp >= 8:
			player.hp += 5
			player.ap -= 1
			player.mp -= 8
