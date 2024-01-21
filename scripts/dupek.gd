extends CharacterBody2D

var speed = 100.0
var player_state
@onready var attack_area: Area2D = $AttactArea
var misses_left = 5

func we_are_dupek():
	return multiplayer.has_multiplayer_peer() and not multiplayer.is_server()

func _input(event):
	if not we_are_dupek():
		return
	if event.is_action_pressed("attack"):
		var bodies = attack_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("player"):
				print("Killed player")
				return
		print("Missed player")
		if misses_left == 0:
			print("Dupek lost")
		else:
			misses_left -= 1

func _physics_process(_delta):
	if not we_are_dupek():
		return

	var direction = Input.get_vector("left", "right", "up", "down")
	var run = Input.is_action_pressed("sprint")

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
