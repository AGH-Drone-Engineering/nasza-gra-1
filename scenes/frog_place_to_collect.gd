extends StaticBody2D

@export var item: InvItem
var player = null
var player_in_area = false
var ready_to_collect = true

func player_collect():
	player.collect(item)

func _on_pickable_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _process(_delta):
	if player_in_area:
		if Input.is_action_just_pressed("e") and ready_to_collect:
			player_collect()
			visible = false
			ready_to_collect = false
			$Timer.start()
			

func _on_timer_timeout():
	var chance_to_refill = randi_range(0,100)
	if chance_to_refill >= 60 and not ready_to_collect:
		ready_to_collect = true
		visible = true
	else:
		$Timer.start()


func _on_pickable_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false

