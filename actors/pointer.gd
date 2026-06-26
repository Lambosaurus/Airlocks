extends RayCast3D

@export var distance: float = 1
@export var camera: Camera3D

signal detected(body: PhysicsBody3D)

var current_collider: PhysicsBody3D
var current_point: Variant
var current_direction: Vector3
var current_global_direction: Vector3
	
func _process(_delta):
	if not is_multiplayer_authority(): return
	current_direction = -camera.transform.basis.z
	current_global_direction = -camera.global_transform.basis.z
	target_position = current_direction * distance
	enabled = true
	
	if is_colliding():
		if is_instance_valid(current_collider) and current_collider is Ball:
			current_collider.mesh.set_layer_mask_value(12, false)
		current_collider = get_collider()
		if is_instance_valid(current_collider) and current_collider is Ball:
			current_collider.mesh.set_layer_mask_value(12, true)
		current_point = get_collision_point()
		detected.emit(current_collider, current_point)
	else:
		if is_instance_valid(current_collider) and current_collider is Ball: 
			current_collider.mesh.set_layer_mask_value(12, false)
		current_collider = null
		current_point = null
	
