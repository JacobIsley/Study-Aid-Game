extends Node2D

onready var sprite = $Sprite

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
