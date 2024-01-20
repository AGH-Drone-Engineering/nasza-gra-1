extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/pot_display

func _ready():
	visible = false
	

func update(pot: InvItem):
	visible = true
	item_visual.visible = true
	item_visual.texture = pot.texture
	await get_tree().create_timer(2).timeout
	$show_timer.start()

func _on_show_timeout():
	visible = false
