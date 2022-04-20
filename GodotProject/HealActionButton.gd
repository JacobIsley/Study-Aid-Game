extends "res://ActionButton.gd"

export var heal_amount = 5

func _on_pressed():
	var player = BattleUnits.PlayerStats
	if player != null:
		if player.mp >= 8:
			player.hp += heal_amount
			player.ap -= 1
			player.mp -= 8
