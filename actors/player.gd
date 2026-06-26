extends CharacterBody3D

@export var force = 1.0
		
const INPUT_MAP: Dictionary[String, Vector3] = {
	"left": Vector3.LEFT,
	"right": Vector3.RIGHT,
	"forward": Vector3.FORWARD,
	"back": Vector3.BACK
}

@export var camera_mouse_sensitivity: float = 0.005
@export var camera_min_pitch: float = -1.5 # Looking down limit in radians (~ -85 deg)
@export var camera_max_pitch: float = 1.5  # Looking up limit in radians (~ 85 deg)

@onready var head_camera: Camera3D = $Head/HeadCam
@onready var third_person_camera: Camera3D = $ThirdPersonCamera
@onready var current_camera:
	get(): return get_viewport().get_camera_3d()
		

@export var gravity = 1

@onready var pointer = $Head/Pointer

@onready var outline_viewport : SubViewport = $OutlineViewport
@onready var outline_camera : Camera3D = $OutlineViewport/Camera3D

func sync_outline_viewport() -> void:
	var viewport := get_viewport()

	if outline_viewport.size != viewport.size:
		outline_viewport.size = viewport.size

	if current_camera:
		outline_camera.fov = current_camera.fov
		outline_camera.global_transform = current_camera.global_transform

var id: int:
	get():
		return str(name).to_int()

func _process(_delta):
	if is_multiplayer_authority():
		handle_light_toggle()
		handle_input()
		sync_outline_viewport()
	
func _physics_process(_delta):
	if is_multiplayer_authority():
		process_movement()
		move_and_slide()
		
func handle_input():
	if Input.is_action_just_pressed("action_primary"):
		if $BodySlots/LeftHand.is_assigned():
			var ball = $BodySlots/LeftHand.take_from_slot()
			if ball: 
				ball = SpawnHandler.move_to_space(ball, $BodySlots/LeftHand.global_position)
				ball.apply_impulse(pointer.current_global_direction * 5.0)
		elif pointer.current_collider and pointer.current_collider is Ball:
			$BodySlots/LeftHand.add_to_slot(pointer.current_collider)
			
	if Input.is_action_just_pressed("camera_toggle"):
		if head_camera.current:
			third_person_camera.current = true
		else: head_camera.current = true
		
	if Input.is_action_just_pressed("detach_cursor"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func get_motion_input():
	var direction = Vector3.ZERO
	for action in INPUT_MAP.keys():
		if Input.is_action_pressed(action):
			direction += INPUT_MAP[action]
			
	return (transform.basis * direction).normalized()
			
	
func process_movement():
	var movement_direction = get_motion_input()
	if movement_direction != Vector3.ZERO:
		velocity += movement_direction * force
	else:
		velocity.x = move_toward(velocity.x, 0, force)
		velocity.z = move_toward(velocity.z, 0, force)
		
	if not is_on_floor():
		velocity += Vector3.DOWN * gravity
	
func handle_light_toggle():
	if Input.is_action_just_pressed("light_toggle"):
		$Head/SpotLight3D.visible = !$Head/SpotLight3D.visible

func _ready() -> void:
	set_multiplayer_authority(id)
	$BodySlots/LeftHand.set_multiplayer_authority(id)

	if is_multiplayer_authority():
		# Lock and hide the mouse cursor for first-person style
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		head_camera.current = true

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	# Check if the mouse is moving
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate horizontally (Y-axis)
		rotate_y(-event.relative.x * camera_mouse_sensitivity)
		
		# Rotate vertically (X-axis) and clamp it so the camera doesn't flip
		current_camera.rotate_x(-event.relative.y * camera_mouse_sensitivity)
		current_camera.rotation.x = clamp(current_camera.rotation.x, camera_min_pitch, camera_max_pitch)
		
