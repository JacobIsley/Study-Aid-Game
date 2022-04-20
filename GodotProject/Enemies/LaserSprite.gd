extends Sprite

var greenLaser = preload("res://Assets/LaserGreen.png")
var purpleLaser = preload("res://Assets/LaserPurple.png")
var yellowLaser = preload("res://Assets/LaserYellow.png")

export var color = "green"

func _ready():
	randomize()
	self.hide()
	match color:
		"green":
			self.texture = greenLaser
		
		"purple":
			self.texture = purpleLaser
		
		"yellow":
			self.texture = yellowLaser

