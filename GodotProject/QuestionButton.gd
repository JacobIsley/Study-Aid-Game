extends Button

onready var label = $Label
onready var highlight = $ColorRect


func set_button_text(text:String):
	self.text = text.substr(0,20)


func set_label_number(num:int):
	label.text = str(num)

func is_selected(val):
	if val:
		highlight.show()
	else:
		highlight.hide()
