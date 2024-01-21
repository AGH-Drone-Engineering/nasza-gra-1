extends Node2D

const REMOTE = "localhost"
const PORT = 4433

@export var gostek_scene: PackedScene
@export var NUM_GOSTEKS: int

signal set_dupek_authority(id)


func get_hotspot_nodes():
	return get_tree().get_nodes_in_group("HotSpots")


func get_random_hotspot():
	var hotspot_nodes = get_hotspot_nodes()
	var random_hotspot_node = hotspot_nodes[randi() % hotspot_nodes.size()]
	return random_hotspot_node


func _ready():
	multiplayer.server_relay = false
	spawn_gosteks(NUM_GOSTEKS)


func spawn_gosteks(n):
	for i in range(n):
		var gostek = gostek_scene.instantiate()
		var spawn_hotspot =	get_random_hotspot()
		var offset = Vector2(randf() * 100 - 50, randf() * 100 - 50)
		gostek.position = spawn_hotspot.position + offset
		add_child(gostek)


func on_peer_connected(id):
	print("Peer connected: ", id)
	emit_signal("set_dupek_authority", id)


func _on_player_become_dupek_pressed():
	print("BECOME DUPEK")
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(REMOTE, PORT)
	multiplayer.multiplayer_peer = peer
	var my_id = multiplayer.get_unique_id()
	print("I am client ", my_id)
	emit_signal("set_dupek_authority", my_id)
	$player/MultiUI.hide()
	$player/pots_UI.hide()
	$player/UI.hide()
	$Dupek/Camera2D.enabled = true
	$player/Camera2D.enabled = false


func _on_player_start_server_pressed():
	print("START SERVER")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(on_peer_connected)
	$player/MultiUI.hide()
	$Dupek/UI.hide()
