extends Area2D


@export var target_x: int
@export var target_y: int


func _input(event):
	if event.is_action_pressed("e"):
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("player"):
				body.position.x = target_x
				body.position.y = target_y
				break
