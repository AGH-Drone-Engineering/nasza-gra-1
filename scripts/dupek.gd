extends CharacterBody2D

var speed = 100.0
var enabled = true
var player_state
@onready var attack_area: Area2D = $AttactArea
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var win_sprite: Sprite2D = $UI/WinSprite
@onready var lose_sprite: Sprite2D = $UI/LoseSprite
@onready var player_node: Node2D = get_tree().get_nodes_in_group("player")[0]
var misses_left = 5

func lock_controls():
	enabled = false

@rpc("any_peer", "call_remote", "reliable")
func rpc_show_lose():
	lose_sprite.visible = true
	lock_controls()

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
				particles.emitting = true
				win_sprite.visible = true
				player_node.rpc_show_lose.rpc()
				lock_controls()
				return
		print("Missed player")
		if misses_left == 0:
			print("Dupek lost")
			lose_sprite.visible = true
			player_node.rpc_show_win.rpc()
			lock_controls()
		else:
			misses_left -= 1

func _process(_delta):
	var vec_to_player = player_node.position - position
	vec_to_player = vec_to_player.normalized()
	particles.direction = vec_to_player

func _physics_process(_delta):
	if not we_are_dupek():
		return

	var direction = Input.get_vector("left", "right", "up", "down")
	var run = Input.is_action_pressed("sprint")

	if not enabled:
		speed = 0
	else:
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

	play_anim(direction)
	move_and_slide()


func play_anim(dir):
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
	if player_state == "walking":
		if dir.y == -1:
			$AnimatedSprite2D.play("n-walk")
		if dir.x == 1:
			$AnimatedSprite2D.play("e-walk")
			$AnimatedSprite2D.flip_h = false
		if dir.y == 1:
			$AnimatedSprite2D.play("s-walk")
		if dir.x == -1:
			$AnimatedSprite2D.play("e-walk")
			$AnimatedSprite2D.flip_h = true

		if dir.x > .5 and dir.y < -.5:
			$AnimatedSprite2D.play("ne-walk")
			$AnimatedSprite2D.flip_h = false
		if dir.x > .5 and dir.y > .5:
			$AnimatedSprite2D.play("se-walk")
			$AnimatedSprite2D.flip_h = false
		if dir.x < -.5 and dir.y < -.5:
			$AnimatedSprite2D.play("ne-walk")
			$AnimatedSprite2D.flip_h = true
		if dir.x < -.5 and dir.y > .5:
			$AnimatedSprite2D.play("se-walk")
			$AnimatedSprite2D.flip_h = true


func _on_world_set_dupek_authority(id):
	$MultiplayerSynchronizer.set_multiplayer_authority(id)
