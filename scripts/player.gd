extends CharacterBody2D

var speed = 100
var player_state

signal become_dupek_pressed
signal start_server_pressed

@export var inv: Inv

var green_pot = false
var purple_pot = false
var orange_pot = false 

var mouse_loc_from_player = null

func we_are_player():
	return not multiplayer.has_multiplayer_peer() or multiplayer.is_server()

func _physics_process(_delta):
	if not we_are_player():
		return

	mouse_loc_from_player = get_global_mouse_position() - self.position
	
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
	
	
func play_anim(dir):
	
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
	if player_state == "walking":
		if dir.y == -1:
			$AnimatedSprite2D.play("n-walk")
		if dir.x == 1:
			$AnimatedSprite2D.play("e-walk")
		if dir.y == 1:
			$AnimatedSprite2D.play("s-walk")
		if dir.x == -1:
			$AnimatedSprite2D.play("w-walk")
			
		if dir.x > .5 and dir.y < -.5:
			$AnimatedSprite2D.play("ne-walk")
		if dir.x > .5 and dir.y > .5:
			$AnimatedSprite2D.play("se-walk")
		if dir.x < -.5 and dir.y < -.5:
			$AnimatedSprite2D.play("nw-walk")
		if dir.x < -.5 and dir.y > .5:
			$AnimatedSprite2D.play("sw-walk")

	
func player():
	pass
	
func collect(item):
	inv.insert(item)
	
func delete(xname: String):
	inv.delete(xname)


func _on_become_dupek_pressed():
	emit_signal("become_dupek_pressed")


func _on_start_server_pressed():
	emit_signal("start_server_pressed")
