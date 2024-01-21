extends CharacterBody2D

@export var pot_to_receive: InvItem

var player_in_area = false
var player = null

var inv = preload("res://inventory/playerInv.tres")

var player_state
var movement_speed: float = 100.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var nav_applied_velocity: Vector2 = Vector2.ZERO

@onready var nav_loiter_center = position

var nav_loiter_target = null
var nav_new_loiter_target_timeout = 1.0


func we_are_player():
	return not multiplayer.has_multiplayer_peer() or multiplayer.is_server()


func _process(delta):
	if player_in_area:
		if Input.is_action_just_pressed("give"):
			for slot in inv.slots:
				if slot.item != null and slot.item.name == pot_to_receive.name:
					recieve()

	if we_are_player():
		nav_new_loiter_target_timeout -= delta
		if nav_new_loiter_target_timeout <= 0:
			nav_new_loiter_target_timeout = 1 + randf_range(-0.5, 0.5)
			var loiter_offset = Vector2(randf() * 100.0 - 50.0, randf() * 100.0 - 50.0)
			var nav_immediate_target = nav_loiter_center + loiter_offset
			set_nav_target(nav_immediate_target)


func _physics_process(_delta):
	if we_are_player():
		if nav_agent.is_navigation_finished():
			pass
		else:
			var current_agent_position = global_position
			var next_path_position = nav_agent.get_next_path_position()
			var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
			nav_agent.velocity = new_velocity
	
		velocity = nav_applied_velocity
	
		if velocity.x == 0 and velocity.y == 0:
			player_state = "idle"
		else:
			player_state = "walking"
	
		play_anim(velocity)
	
		move_and_slide()


func play_anim(dir):
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
	if player_state == "walking":
		if dir.y < -0.5:
			$AnimatedSprite2D.play("n-walk")
			# $AnimatedSprite2D2.play("n-walk")
		if dir.x > 0.5:
			$AnimatedSprite2D.play("e-walk")
			$AnimatedSprite2D.flip_h = false
			# $AnimatedSprite2D2.play("e-walk")
			# $AnimatedSprite2D2.flip_h = false
		if dir.y > 0.5:
			$AnimatedSprite2D.play("s-walk")
			# $AnimatedSprite2D2.play("s-walk")
		if dir.x < -0.5:
			$AnimatedSprite2D.play("e-walk")
			$AnimatedSprite2D.flip_h = true
			# $AnimatedSprite2D2.play("e-walk")
			# $AnimatedSprite2D2.flip_h = true

		if dir.x > .5 and dir.y < -.5:
			$AnimatedSprite2D.play("ne-walk")
			$AnimatedSprite2D.flip_h = false
			# $AnimatedSprite2D2.play("ne-walk")
			# $AnimatedSprite2D2.flip_h = false
		if dir.x > .5 and dir.y > .5:
			$AnimatedSprite2D.play("se-walk")
			$AnimatedSprite2D.flip_h = false
			# $AnimatedSprite2D2.play("se-walk")
			# $AnimatedSprite2D2.flip_h = false
		if dir.x < -.5 and dir.y < -.5:
			$AnimatedSprite2D.play("ne-walk")
			$AnimatedSprite2D.flip_h = true
			# $AnimatedSprite2D2.play("ne-walk")
			# $AnimatedSprite2D2.flip_h = true
		if dir.x < -.5 and dir.y > .5:
			$AnimatedSprite2D.play("se-walk")
			$AnimatedSprite2D.flip_h = true
			# $AnimatedSprite2D2.play("se-walk")
			# $AnimatedSprite2D2.flip_h = true


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	nav_applied_velocity = safe_velocity


func set_nav_target(target: Vector2):
	nav_agent.target_position = target


func recieve():
	player.delete(pot_to_receive.name)
	if pot_to_receive.name == 'green pot':
		player.green_pot = true
	if pot_to_receive.name == 'purple pot':
		player.purple_pot = true
	if pot_to_receive.name == 'orange pot':
		player.orange_pot = true
	

func _on_give_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_give_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
