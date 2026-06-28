class_name ItemType
extends Resource

@export_category("Physical 3D")
@export var mesh: Mesh
@export var physics_material: PhysicsMaterial
@export_group("Shape")
@export var shape: Shape3D

@export_category("Activatable")
@export var actions: Dictionary[String, Callable]

func initialize(item: Item):
	var mesh_instance = build_mesh_instance()
	var collision_shape = build_collision_shape()
	
	item.mesh = mesh_instance
	item.add_child(mesh_instance)
	item.add_child(collision_shape)
	item.physics_material_override = physics_material
	
	return item
	
func get_shape():
	if shape: return shape
	var bb := mesh.get_aabb()
	var radius = bb.get_longest_axis_size() / 2.0
	shape = SphereShape3D.new()
	shape.radius = radius
	
	return shape
	
func build_collision_shape():
	var collision_shape := CollisionShape3D.new()
	collision_shape.shape = get_shape()
	
	return collision_shape
	
func build_mesh_instance():
	var item_mesh := MeshInstance3D.new()
	item_mesh.mesh = mesh
	
	return item_mesh
	
func activate(action: String):
	if not can_activate(action): return
	
	# Do nothing for now, future we can fill out actions
	return actions[action]
	
func can_activate(action: String):
	return actions.has(action)
