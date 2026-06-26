extends MultiplayerSpawner

@export var scene: PackedScene
@export var target: Node3D # For global position

@export var frequency: float:
	set(value):
		frequency = value
		start_timer()
		
@export var amount: int = 1

func start_timer():
	if multiplayer and not multiplayer.is_server() or not frequency: return
	$Timer.start(frequency)

func _ready():
	add_spawnable_scene(scene.resource_path)
	spawn_function = _spawn_object
	
	if multiplayer.is_server():
		$Timer.timeout.connect(spawn_object)
		start_timer()

func spawn_object():
	# Position is target, or spawn node if no target
	var pos = target.global_position if target else get_node(spawn_path).global_position
	
	var data = {
		"pos": pos
	}
	
	spawn(data)
		
func _spawn_object(data: Dictionary):
	var node = scene.instantiate()
	node.global_position = data["pos"]
	
	return node
	
	
	
