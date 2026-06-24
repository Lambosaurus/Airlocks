extends RayCast3D

@onready var collision_shape = $DetectionArea/CollisionShape3D
@onready var detection_area = $DetectionArea

@export var distance: float = 1
@export var camera: Camera3D

signal detected(body: PhysicsBody3D)

var current_collider: PhysicsBody3D
var current_point: Variant
var current_direction: Vector3
var current_global_direction: Vector3
	
func _process(_delta):
	current_direction = -camera.transform.basis.z
	current_global_direction = -camera.global_transform.basis.z
	target_position = current_direction * distance
	enabled = true
	
	if is_colliding():
		current_collider = get_collider()
		current_point = get_collision_point()
		detected.emit(current_collider, current_point)
	else:
		current_collider = null
		current_point = null
	
