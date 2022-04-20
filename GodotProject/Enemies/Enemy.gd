extends Node2D

const BattleUnits = preload("res://BattleUnits.tres")

export (int) var hp = 25 setget set_hp
export (int) var damage = 4
export (String) var attack_type = "Attack"


onready var hpLabel = $HPLabel
onready var animationPlayer = $AnimationPlayer

signal died
signal end_turn

func set_hp(new_hp):
	hp = new_hp
	if hpLabel != null:
		hpLabel.text = str(hp) + " HP"
	
func _ready():
	BattleUnits.Enemy = self
	# update health immediately, display the correct number
	self.set_hp(hp)
	
func _exit_tree():
	BattleUnits.Enemy = null

func attack() -> void:
	yield(get_tree().create_timer(0.4), "timeout")
	animationPlayer.play("Attack")
	yield(animationPlayer, "animation_finished")
	emit_signal("end_turn")

# takes damage and automatically updates health label
func take_damage(amount):
	self.hp -= amount
	if is_dead():
		queue_free()
		emit_signal("died")
	else:
		animationPlayer.play("Shake")

func deal_damage():
	BattleUnits.PlayerStats.hp -= damage

func is_dead():
	return hp <= 0
