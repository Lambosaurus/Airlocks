extends Node

var global_spawn_space: Node3D

func move_to_space(node: Node3D, global_position: Vector3 = node.global_position, space: Node3D = global_spawn_space) -> Node3D:
	var node_duplicate = node.duplicate()
	node.queue_free()
	space.add_child(node_duplicate, true)
	node_duplicate.global_position = global_position
	
	return node_duplicate

func set_global_spawn_space(space: Node3D):
	global_spawn_space = space
	
