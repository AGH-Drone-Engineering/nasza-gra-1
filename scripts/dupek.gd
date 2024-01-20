extends CharacterBody2D

var speed = 100.0
var player_state

func _physics_process(_delta):
	if not multiplayer.has_multiplayer_peer() or multiplayer.is_server():
		return

	var direction = Input.get_vector("left", "right", "up", "down")
	var run = Input.is_action_pressed("shift")

	if run:
		speed = 150
	else:
		speed = 100

	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	else:
		player_state = "walking"

	if direction.x > .5 and direction.y < -.5 or direction.x > .5 and direction.y > .5 \
	or direction.x < -.5 and direction.y < -.5 or direction.x < -.5 and direction.y > .5:
		velocity = direction * speed / sqrt(1.5)
	else:
		velocity = direction * speed

	move_and_slide()


func _on_world_set_dupek_authority(id):
	$MultiplayerSynchronizer.set_multiplayer_authority(id)
