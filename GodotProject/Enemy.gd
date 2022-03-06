extends Node2D

var hp = 10 setget set_hp

onready var hpLabel = $"HP Label"
onready var animationPlayer = $AnimationPlayer

signal died

func set_hp(new_hp):
	hp = new_hp
	hpLabel.text = str(hp) + "hp"
	
	if hp <= 0:
		omit_signal("died")			# error here "the method omit_signal isn't declared in the current class
		queue_free()
	else:
		animationPlayer.play("Slash")	# I called it slash instead of shake because initially I thought that's what I was animating
		yield(animationPlayer, "animation_finished")
		animationPlayer.play("Attack")
