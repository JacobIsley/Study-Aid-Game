extends Panel

onready var label = $RichTextLabel

func _ready():
	update_numbers(3,8,5)

func update_numbers(attack, special, heal):
	label.text = "\nAttack dmg: " + str(attack) + "\n\nSpecial dmg: " + str(special) + "\n\nHeal amnt: " + str(heal)
