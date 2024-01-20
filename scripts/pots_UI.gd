extends Control

@export var player: CharacterBody2D

@onready var green_vis: Sprite2D = $NinePatchRect/Panel/green
@onready var purple_vis: Sprite2D = $NinePatchRect/Panel/purple
@onready var orange_vis: Sprite2D = $NinePatchRect/Panel/orange

func _process(_delta):
	if player.green_pot == true:
		green_vis.visible = false
		
	if player.purple_pot == true:
		purple_vis.visible = false
		
	if player.orange_pot == true:
		orange_vis.visible = false
	

