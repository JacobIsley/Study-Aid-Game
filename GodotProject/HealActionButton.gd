extends "res://ActionButton.gd"

func _on_pressed():
	var player = BattleUnits.PlayerStats
	if player != null:
		if player.mp >= 8:
			player.hp += 5
			player.ap -= 1
			player.mp -= 8
