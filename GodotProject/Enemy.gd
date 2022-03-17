extends Node2D

var hp = 25 setget set_hp
var target = null
onready var hpLabel = $HPLabel
onready var animationPlayer = $AnimationPlayer

signal died
signal end_turn

func set_hp(new_hp):
	hp = new_hp
	hpLabel.text = str(hp) + " HP"

func attack(target) -> void:
	yield(get_tree().create_timer(0.4), "timeout")
	animationPlayer.play("Attack")
	self.target = target
	yield(animationPlayer, "animation_finished")
	self.target = null
	emit_signal("end_turn")

func take_damage(amount):
	self.hp -= amount
	if is_dead():
		queue_free()
		emit_signal("died")
	else:
		animationPlayer.play("Shake")

func deal_damage():
	self.target.hp -= 4

func is_dead():
	return hp <= 0
