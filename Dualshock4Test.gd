extends Node2D

func _process(delta):
	print(Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up"))
