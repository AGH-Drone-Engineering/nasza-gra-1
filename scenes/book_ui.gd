extends Control

func _ready():
	visible = false
	
func _process(delta):
	if Input.is_action_just_pressed("b"):
		show_book()

func show_book():
	visible = !visible
