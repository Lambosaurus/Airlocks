extends Node

const DEFAULT_PORT = 10001
const DEFAULT_MAX_CLIENTS = 8

const player_scene = preload("res://actors/player.tscn")

signal player_connected(id: int)
signal player_disconnected(id: int)

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	initialize_steam()
	
func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam initialize?: %s" % initialize_response)

	if initialize_response['status'] > Steam.STEAM_API_INIT_RESULT_OK:
		print("Failed to initialize Steam, shutting down: %s" % initialize_response)
		# Show some kind of prompt so the game doesn't suddently stop working


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
	
@rpc("call_local")
func _handle_server_action(self_path: NodePath, method: StringName, ...args: Array[Variant]):	
	args = args.map(func(a): return get_node(a) if a is NodePath else a)
	var self_node = get_node(self_path)
	var callable = Callable(self_node, method)
	callable.callv(args)

# RPC to server, parsing nodes as their absolute path
# self_arg is the scope the given method is called in
func server_action(self_arg: Node, callable: Callable, ...args: Array[Variant]):
	args = args.map(func(a): return a.get_path() if a is Node else a)
	_handle_server_action.rpc_id.callv([1, self_arg.get_path(), callable.get_method()] + args)
	
func _on_player_connected(id: int):
	if multiplayer.is_server():
		server_log("Player" + str(id) + " connected")
		player_connected.emit(id)
		
func _on_player_disconnected(id: int):
	if multiplayer.is_server():
		server_log("Player" + str(id) + " disconnected")
		player_disconnected.emit(id)
