extends Area2D

@export var item: InvItem
var player = null
var player_in_area = false
var ready_to_collect = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in_area:
		if Input.is_action_just_pressed("e") and ready_to_collect:
			player.collect(item)
			ready_to_collect = false
			$Timer.start()


func _on_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_body_exited(body):
	if body.has_method("player"):
		player_in_area = false


func _on_timer_timeout():
	if !ready_to_collect:
		ready_to_collect = true
