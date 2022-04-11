extends Popup

onready var label = $RichTextLabel

func set_label(msg:String):
	label.text = msg
