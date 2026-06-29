extends Node3D

const PLAYER_SCENE = preload("res://actors/player.tscn")

func _ready():
	SpawnHandler.set_global_spawn_space($EntitySpace)
	
	if multiplayer.is_server():
		NetworkService.player_connected.connect(add_player)
		NetworkService.player_disconnected.connect(remove_player)
		
		call_deferred("add_player", 1)
		
func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if Input.is_key_pressed(KEY_1):
		$EntitySpace/BallSpawner.spawn_items()
	if Input.is_key_pressed(KEY_2):
		$EntitySpace/TorchSpawner.spawn_items()
		
		
		
func add_player(id: int): 
	var p = PLAYER_SCENE.instantiate()
	p.add_to_group("Players")
	p.name = str(id) # Name node by peer ID for easy tracking
	$EntitySpace.add_child(p)
	
func remove_player(id: int):
	var player = get_node_or_null(str(id))
	if player:
		player.remove_from_group("Player")
		player.queue_free()
