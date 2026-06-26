class_name Slot
extends Node3D

@export var assigned: PhysicsBody3D

# TODO: Auto handle spawnable items/scenes
@onready var spawner = $Spawner

@rpc
func add_to_slot(body: PhysicsBody3D):
	#if not multiplayer.is_server(): return
	if assigned: return
	
	assigned = body.duplicate()
	body.queue_free()
	add_child(assigned, true)
	assigned.freeze = true
	assigned.position = Vector3.ZERO
	
	return assigned
	
@rpc
func take_from_slot():
	#if not multiplayer.is_server(): return
	if not assigned: return
	
	var removed = assigned.duplicate()
	assigned.queue_free()
	assigned = null
	removed.freeze = false
	
	return removed
	
func is_assigned():
	return !!assigned
