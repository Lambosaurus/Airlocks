class_name Slot
extends Node3D

@export var assigned: PhysicsBody3D
		
func add_to_slot(body: PhysicsBody3D):
	if assigned: return
	
	assigned = body
	assigned.reparent(self)
	assigned.freeze = true
	assigned.position = Vector3.ZERO
	
	return assigned
	
func take_from_slot():
	if not assigned: return
	
	var removed = assigned
	assigned = null
	remove_child(removed)
	removed.freeze = false
	removed.global_position = global_position
	
	return removed
	
func is_assigned():
	return !!assigned
