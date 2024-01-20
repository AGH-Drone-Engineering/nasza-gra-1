extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	call_deferred("actor_setup")


func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target_position)


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		set_movement_target(Vector2(randf_range(0.0, 320.0), randf_range(0.0, 240.0)))
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	navigation_agent.velocity = new_velocity


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
