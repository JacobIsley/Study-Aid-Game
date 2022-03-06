extends Node2D

onready var enemy = $Enemy

func _on_Attack_Button_pressed():
	enemy.hp -= 2
