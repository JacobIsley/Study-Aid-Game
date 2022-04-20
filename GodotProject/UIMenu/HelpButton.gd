extends Button


onready var help = $HelpPopup
var showhelp = false

func _ready():
	help.rect_global_position = Vector2(112,32)

func _on_HelpButton_pressed():
	print(help.rect_global_position)
	showhelp = !showhelp
	if(showhelp):
		help.show()
	else:
		help.hide()
