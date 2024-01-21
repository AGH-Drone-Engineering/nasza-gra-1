extends CharacterBody2D

var movement_speed: float = 100.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var gostek_applied_velocity: Vector2 = Vector2.ZERO

var gostek_target_position = null
var gostek_new_target_timeout = 15.0

var gostek_loiter_center = null
var gostek_new_loiter_center_timeout = 5.0

var gostek_loiter_target = null
var gostek_new_loiter_target_timeout = 1.0

var gostek_immediate_target = null
var gostek_set_immediate_target_timeout = 0.5


func get_hotspot_nodes():
	return get_tree().get_nodes_in_group("HotSpots")


func get_random_hotspot():
	var hotspot_nodes = get_hotspot_nodes()
	var random_hotspot_node = hotspot_nodes[randi() % hotspot_nodes.size()]
	return random_hotspot_node


func set_target_to_random_hotspot():
	gostek_target_position = get_random_hotspot().global_position


func actor_setup():
	await get_tree().physics_frame
	set_target_to_random_hotspot()


func set_nav_target(target: Vector2):
	nav_agent.target_position = target


func _ready():
	movement_speed += randf_range(-20.0, 20.0)
	gostek_new_target_timeout += randf_range(-5.0, 5.0)
	gostek_new_loiter_center_timeout += randf_range(-2.0, 2.0)
	gostek_new_loiter_target_timeout += randf_range(-0.5, 0.5)
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	call_deferred("actor_setup")


func _process(delta):
	gostek_new_target_timeout -= delta
	if gostek_new_target_timeout <= 0:
		gostek_new_target_timeout = 15 + randf_range(-5.0, 5.0)
		set_target_to_random_hotspot()

	gostek_new_loiter_center_timeout -= delta
	if gostek_new_loiter_center_timeout <= 0:
		gostek_new_loiter_center_timeout = 5 + randf_range(-2.0, 2.0)
		if gostek_loiter_center == null:
			gostek_loiter_center = global_position
			var loiter_offset = Vector2(randf() * 50.0 - 25.0, randf() * 50.0 - 25.0)
			gostek_loiter_target = gostek_loiter_center + loiter_offset
		else:
			gostek_loiter_center = null
			gostek_loiter_target = null

	gostek_new_loiter_target_timeout -= delta
	if gostek_new_loiter_target_timeout <= 0:
		gostek_new_loiter_target_timeout = 1 + randf_range(-0.5, 0.5)
		if gostek_loiter_center != null:
			var loiter_offset = Vector2(randf() * 50.0 - 25.0, randf() * 50.0 - 25.0)
			gostek_loiter_target = gostek_loiter_center + loiter_offset

	if gostek_loiter_target != null:
		gostek_immediate_target = gostek_loiter_target
	else:
		gostek_immediate_target = gostek_target_position

	gostek_set_immediate_target_timeout -= delta
	if gostek_set_immediate_target_timeout <= 0:
		gostek_set_immediate_target_timeout = 0.5
		if gostek_immediate_target != null:
			set_nav_target(gostek_immediate_target)


func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		pass
	else:
		var current_agent_position = global_position
		var next_path_position = nav_agent.get_next_path_position()

		var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		nav_agent.velocity = new_velocity

	velocity = gostek_applied_velocity
	move_and_slide()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	gostek_applied_velocity = safe_velocity
