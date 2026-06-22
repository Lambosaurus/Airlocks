extends Node

const DEFAULT_PORT = 10001
const DEFAULT_MAX_CLIENTS = 8

const player_scene = preload("res://actors/player.tscn")

signal player_connected(id: int)
signal player_disconnected(id: int)

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)

func start_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT, DEFAULT_MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
func join_server(ip_addr: String):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_addr, DEFAULT_PORT)
	multiplayer.multiplayer_peer = peer

func server_log(text: String):
	print(text)
	
func _on_player_connected(id: int):
	if multiplayer.is_server():
		server_log("Player" + str(id) + " connected")
		player_connected.emit(id)
		
func _on_player_disconnected(id: int):
	if multiplayer.is_server():
		server_log("Player" + str(id) + " disconnected")
		player_disconnected.emit(id)
