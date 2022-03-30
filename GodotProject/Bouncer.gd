extends KinematicBody2D

onready var sprite = $Sprite

var boundaries = Rect2(Vector2(96,64), Vector2(160, 90))
var velocity = Vector2(1,1)
var rot_speed = 0.5

func _ready():
	randomize()
	randomize_vel()


func _process(delta):
		sprite.rotation_degrees += rot_speed
		var collide = move_and_collide(velocity * delta)
		if collide:
			if(collide.position.y == 72 or collide.position.y == 168):
				velocity.y = -velocity.y
			else:
				velocity.x = -velocity.x

func randomize_vel():
	var negative = randi() % 3
	var x = (randi() % 10)+5
	var y = (randi() % 10)+5
	rot_speed = randf() + .3
	match(negative):
		0:
			x = -x
		1:
			y = -y
		2:
			rot_speed = -rot_speed
	
	velocity = Vector2(x, y)
	
