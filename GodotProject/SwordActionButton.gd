extends "res://ActionButton.gd"

const Slash = preload("res://Slash.tscn")
const BigSlash = preload("res://SpecialSlash.tscn")
export var damage = 3
export var required_mp = 0

func _on_pressed():
	var enemy = BattleUnits.Enemy
	var playerStats = BattleUnits.PlayerStats
	if enemy != null or enemy.is_queued_for_deletion():
		if playerStats.mp >= required_mp:
			enemy.take_damage(damage)
			
			
			if required_mp == 0:
				playerStats.mp += 2 
				if(enemy.hp > 0):
					create_slash(enemy.global_position)
			else:
				playerStats.mp += -required_mp
				if(enemy.hp > 0):
					create_big_slash(enemy.global_position)
					
			playerStats.ap -= 1
		
func create_slash(position):
	var slash = Slash.instance()
	var main = get_tree().current_scene
	main.add_child(slash)
	slash.global_position = position


func create_big_slash(position):
	var slash = BigSlash.instance()
	var main = get_tree().current_scene
	main.add_child(slash)
	slash.global_position = position
