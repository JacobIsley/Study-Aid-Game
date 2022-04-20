extends Control

var scene_name = "menu"

signal scene_changed(scene_name)

func _on_GoButton_pressed():
	emit_signal("scene_changed", scene_name)


func _on_HelpButton_pressed():
	pass # Replace with function body.
