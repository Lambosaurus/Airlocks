extends Node

var global_spawn_space: Node3D

func add_to_space(node: Node3D, global_position: Vector3 = node.global_position, space: Node3D = global_spawn_space) -> Node3D:
	space.add_child(node, true)
	node.global_position = global_position
	
	return node

func move_to_space(node: Node3D, global_position: Vector3 = node.global_position, space: Node3D = global_spawn_space) -> Node3D:
	var node_duplicate = node.duplicate()
	node.queue_free()
	
	return add_to_space(node_duplicate, global_position, space)
	
func spawn(scene: PackedScene, global_position: Vector3 = global_spawn_space.position, space: Node3D = global_spawn_space) -> Node3D:
	var node = scene.instantiate()
	return add_to_space(node, global_position, space)

func set_global_spawn_space(space: Node3D):
	global_spawn_space = space
	
