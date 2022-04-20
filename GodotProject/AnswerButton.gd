extends Button


onready var audio = $AudioStreamPlayer
var correct = true

func set_button_text(desc:String):
	self.text = desc


func _on_AnswerButton_pressed():
	audio.playing = true
