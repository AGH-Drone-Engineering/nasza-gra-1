extends Node2D

@export var pot_to_receive: InvItem

var player_in_area = false
var player = null

var inv = preload("res://inventory/playerInv.tres")

func _process(_delta):
	if player_in_area:
			if Input.is_action_just_pressed("e"):
				for slot in inv.slots:
					if slot.item != null and slot.item.name == pot_to_receive.name:
						recieve()

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
