class_name Slot
extends Node3D

var assigned: Item
@export_node_path("Item") var _assigned_path: Variant:
	set(value):
		assigned = get_node(value) if value else null
	get():
		if not assigned: return
		return assigned.get_path()
@onready var hold_point := $HoldPoint

# Spawn functions are responsibility of server, so must be assigned as authority
func _enter_tree():
	set_multiplayer_authority(1)

func add_to_slot(body: Item):
	if not multiplayer.is_server(): return
	if assigned: return
	
	body.mesh.set_layer_mask_value(12, false)
	assigned = SpawnHandler.move_to_space(body, hold_point.global_position, hold_point)
	assigned.rotation = Vector3.ZERO
	assigned.held = true
	
	return assigned
	
func take_from_slot():
	if not multiplayer.is_server(): return
	if not assigned: return
	
	assigned.mesh.set_layer_mask_value(12, false)
	var removed = SpawnHandler.move_to_space(assigned, hold_point.global_position)
	removed.held = false
	
	return removed
	
func is_assigned():
	return !!assigned
