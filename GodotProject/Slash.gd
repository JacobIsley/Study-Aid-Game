extends Node2D

onready var sprite = $Sprite

var one = preload("res://Assets/HitEffect.png")
var two = preload("res://Assets/HitEffect2.png")

func _ready():
	randomize()
	var i = randi() % 2 + 1
	match i:
		1:
			sprite.texture = one
		2: 
			sprite.texture = two

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
