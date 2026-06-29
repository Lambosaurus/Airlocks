class_name ItemType
extends Resource

@export_category("Physical 3D")
@export var mesh: Mesh
@export var physics_material: PhysicsMaterial
@export var mass: float

@export_group("Shape")
@export var shape: Shape3D

func initialize(item: Item):
	if mesh:
		var mesh_instance = build_mesh_instance()
		item.mesh = mesh_instance
		item.add_child(mesh_instance)
	
		var collision_shape = build_collision_shape()
		item.add_child(collision_shape)
		
	if physics_material: item.physics_material_override = physics_material
	if mass: item.mass = mass
	
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
	
