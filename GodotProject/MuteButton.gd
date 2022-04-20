extends Button

var unicon = preload("res://Assets/MuteButton.png")
var muicon = preload("res://Assets/MuteButtonPressed.png")
var muted = false


func _on_MuteButton_pressed():
	muted = !muted
	if muted:
		self.icon = muicon
	else:
		self.icon = unicon
		
