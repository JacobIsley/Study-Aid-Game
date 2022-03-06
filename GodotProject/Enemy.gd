extends Node2D

var hp = 10 setget set_hp

onready var hpLabel = $"HP Label"

func set_hp(new_hp):
	hp = new_hp
	hpLabel.text = str(hp) + "hp"
