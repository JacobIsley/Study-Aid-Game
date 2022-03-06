extends Node2D 

onready var enemy = $Enemy
onready var attackButton = $"UI/Attack Button"
func _on_Attack_Button_pressed():
	var enemy = find_node("Enemy")
	
	if enemy != null:
		enemy.hp -= 2


func _on_Enemy_died():
	attackButton.hide()
	enemy = null
