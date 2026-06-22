extends Node3D

const PLAYER_SCENE = preload("res://actors/player.tscn")

func _ready():
	if multiplayer.is_server():
		NetworkService.player_connected.connect(add_player)
		NetworkService.player_disconnected.connect(remove_player)
		
		add_player(1)
		
func add_player(id: int): 
	var p = PLAYER_SCENE.instantiate()
	p.name = str(id) # Name node by peer ID for easy tracking
	$Players.add_child(p)
	
func remove_player(id: int):
	var player = get_node_or_null(str(id))
	if player:
		player.queue_free()
