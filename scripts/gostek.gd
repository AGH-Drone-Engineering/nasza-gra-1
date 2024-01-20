extends CharacterBody2D

const MOVEMENT_SPEED: float = 200.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var gostek_applied_velocity: Vector2 = Vector2.ZERO

var gostek_target_position = null
var gostek_loiter_position = null
var gostek_immediate_target_position = null


func get_hotspot_nodes():
	return get_tree().get_nodes_in_group("HotSpots")


func get_random_hotspot():
	var hotspot_nodes = get_hotspot_nodes()
	var random_hotspot_node = hotspot_nodes[randi() % hotspot_nodes.size()]
	return random_hotspot_node


func set_target_to_random_hotspot():
	set_nav_target(get_random_hotspot().global_position)


func actor_setup():
	await get_tree().physics_frame
	set_target_to_random_hotspot()


func set_nav_target(target: Vector2):
	nav_agent.target_position = target


func _ready():
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	call_deferred("actor_setup")


func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		set_target_to_random_hotspot()
	else:
		var current_agent_position = global_position
		var next_path_position = nav_agent.get_next_path_position()

		var new_velocity = current_agent_position.direction_to(next_path_position) * MOVEMENT_SPEED
		nav_agent.velocity = new_velocity

	velocity = gostek_applied_velocity
	move_and_slide()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	gostek_applied_velocity = safe_velocity
