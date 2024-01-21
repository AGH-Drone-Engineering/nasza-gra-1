extends Node2D

var player_in_area = false
var player = null
var is_frog_in_inventory = false
var is_potato_in_inventory = false
var is_feather_in_inventory = false
var is_water_in_inventory = false

var green_given = false
var purple_given = false
var orange_given = false

@export var orangePot: InvItem
@export var purplePot: InvItem
@export var greenPot: InvItem

@onready var crafting_ui: Panel = $crafting_ui

var inv = preload("res://inventory/playerInv.tres")

func _process(_delta):
	if player_in_area:
			if Input.is_action_just_pressed("e"):
				for slot in inv.slots:
					if slot.item != null and slot.item.name == 'potato':
						is_potato_in_inventory = true

					if slot.item != null and slot.item.name == 'water':
						is_water_in_inventory = true
						
					if slot.item != null and slot.item.name == 'feather':
						is_feather_in_inventory = true
						
					if slot.item != null and slot.item.name == 'frog':
						is_frog_in_inventory = true
				
				craft()
				
				
func craft():
	if is_frog_in_inventory and is_water_in_inventory and is_feather_in_inventory and not orange_given:
		player.collect(orangePot)
		player.delete('water')
		player.delete('feather')
		player.delete('frog')
		crafting_ui.update(orangePot)
		orange_given = true
		is_frog_in_inventory = false
		is_water_in_inventory = false
		is_feather_in_inventory = false
		
	if is_frog_in_inventory and is_potato_in_inventory and is_water_in_inventory and not green_given:
		player.collect(greenPot)
		player.delete('water')
		player.delete('potato')
		player.delete('frog')
		crafting_ui.update(greenPot)
		green_given = true
		is_frog_in_inventory = false
		is_water_in_inventory = false
		is_potato_in_inventory = false
		
		
	if is_potato_in_inventory and is_water_in_inventory and is_feather_in_inventory and not purple_given:
		player.collect(purplePot)
		player.delete('water')
		player.delete('feather')
		player.delete('potato')
		crafting_ui.update(purplePot)
		purple_given = true
		is_potato_in_inventory = false
		is_water_in_inventory = false
		is_feather_in_inventory = false
		

func _on_crafting_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_crafting_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false

	
