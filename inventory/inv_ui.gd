extends Control

@onready var inv: Inv = preload("res://inventory/playerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	visible = false
	
func _process(delta):
	if Input.is_action_pressed("tab"):
		show_inv_tab(true)
	
	if Input.is_action_just_released("tab"):
		show_inv_tab(false)


func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
func show_inv():
	visible = !visible

func show_inv_tab(tab_open: bool):
	if tab_open:
		visible = true
	else:
		visible = false
