extends RichTextLabel

export var default_text = ""

func _ready():
	set_text(default_text)

func set_text(t:String):
	default_text = t
	self.text = t
