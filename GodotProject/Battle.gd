extends Node2D

onready var hpLabel = $"Enemy/HP Label"

func _on_Attack_Button_pressed():
	hpLabel.text = "8hp"
	print("Attack!")
