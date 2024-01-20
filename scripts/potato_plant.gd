extends Node2D

var state
var player_in_area = false

var potato = preload("res://scenes/potato_collectible.tscn")

@export var item: InvItem
var player = null

func _ready():
	state = "no potatoes"
	if state == "no potatoes":
		$growth_timer.start()

func _process(delta):
	if state == "no potatoes":
		$AnimatedSprite2D.play("no potatoes")
	else: 
		$AnimatedSprite2D.play("potatoes")
		if player_in_area:
			if Input.is_action_just_pressed("e"):
				state = "no potatoes"
				drop_potato()

func _on_pickable_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_pickable_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		

func _on_growth_timer_timeout():
	if state == "no potatoes":
		state = "potatoes"
		

func drop_potato():
	var potato_instance = potato.instantiate()
	potato_instance.global_position = $Marker2D.global_position
	get_parent().add_child(potato_instance)
	player.collect(item)
	await get_tree().create_timer(5).timeout
	$growth_timer.start()
	
	
	
