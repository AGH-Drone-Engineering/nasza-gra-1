extends Node2D

const REMOTE = "localhost"
const PORT = 4433

signal set_dupek_authority(id)


func _ready():
	multiplayer.server_relay = false


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
	$Dupek/Camera2D.enabled = true
	$player/Camera2D.enabled = false


func _on_player_start_server_pressed():
	print("START SERVER")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(on_peer_connected)
	$player/MultiUI.hide()
