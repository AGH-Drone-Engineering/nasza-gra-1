extends Area2D


@export var target_x: int
@export var target_y: int


func we_are_player():
	return not multiplayer.has_multiplayer_peer() or multiplayer.is_server()


func _input(event):
	if not we_are_player():
		return
	if event.is_action_pressed("teleport"):
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("player"):
				body.position.x = target_x
				body.position.y = target_y
				break
