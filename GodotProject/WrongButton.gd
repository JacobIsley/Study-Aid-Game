extends Button

onready var audio = $AudioStreamPlayer
var correct = false

func set_button_text(desc:String):
	self.text = desc

func _on_WrongButton_pressed():
	audio.playing = true
