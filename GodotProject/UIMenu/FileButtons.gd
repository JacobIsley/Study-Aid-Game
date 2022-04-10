extends Control

onready var goButton = $GoButton
onready var delButton = $DeleteButton


func _on_ScrollContainer_show_buttons(value):
	if value:
		self.show()
	else:
		self.hide()
