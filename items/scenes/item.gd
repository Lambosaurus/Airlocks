class_name Item
extends RigidBody3D

@export_category("Configuration")
@export var item_type: ItemType: # Property getter/setter
	set(value):
		_item_type_path = value.resource_path
	get():
		return _item_type
@export var _item_type_path: String: # Store resource path for synchronizer
	set(value):
		_item_type_path = value
		_item_type = load(value)
	
var _item_type: ItemType # private item variable to detach resource name sync
		
@export_category("Properties")
@export var held = false:
	set(value):
		freeze = value
		held = value
		if value:
			set_collision_layer_value(9, false)
		else:
			set_collision_layer_value(9, true)
@export var activated = false

@export_group("Physical 3D")
@export var mesh: MeshInstance3D

var hold_position: Node3D = self

var _initialized = false

func init_type():
	if _initialized or not item_type: return
	
	item_type.initialize(self)
	_initialized = true
	
func _ready():
	init_type()
	
@rpc("call_local", "any_peer")
func activate():
	activated = true
	
@rpc("call_local", "any_peer")
func deactivate():
	activated = false

@rpc("call_local", "any_peer")
func toggle_activate():
	activated = !activated
