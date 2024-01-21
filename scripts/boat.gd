extends Node2D


@onready var boat_area: Area2D = $Area2D
var boat_active = false
var boat_returning = false
var player_body
const BOAT_DISTANCE = 425
@onready var boat_origin_x = position.x
var progress = 0.0


func we_are_player():
	return not multiplayer.has_multiplayer_peer() or multiplayer.is_server()


func _process(delta):
	if not we_are_player():
		return
	if not boat_active and Input.is_action_just_pressed("teleport"):
		var bodies = boat_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("player"):
				boat_active = true
				player_body = body
				break

	if boat_active:
		player_body.position = position
		progress += delta / 6
		if progress >= 1.0:
			boat_active = false
			player_body = null
			boat_returning = true

	if boat_returning:
		progress -= delta / 6
		if progress <= 0.0:
			boat_returning = false
			progress = 0.0

	position.x = boat_origin_x - BOAT_DISTANCE * (0.5 + 0.5 * sin(PI * (progress - 0.5)))
