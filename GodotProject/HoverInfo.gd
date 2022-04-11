extends Control

export (String, MULTILINE) var description = ""

func _on_HoverInfo_mouse_entered():
	var battle = get_tree().current_scene.get_child(2)
	var textbox = battle.find_node("Textbox")
	if textbox != null:
		textbox.text = description


func _on_HoverInfo_mouse_exited():
		var main = get_tree().current_scene.get_child(2)
		var textbox = main.find_node("Textbox")
		if textbox != null:
			textbox.text = textbox.default_text

