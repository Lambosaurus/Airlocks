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

@onready var camera: Camera3D = $Head/HeadCam

@export var gravity = 1

@onready var pointer = $Head/Pointer

func is_current_player():
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func _process(delta):
	if is_current_player():
		handle_light_toggle()
		handle_input()
	
func _physics_process(delta):
	if is_current_player():
		process_movement()
		move_and_slide()
		
func handle_input():
	if Input.is_action_just_pressed("action_primary"):
		if $BodySlots/LeftHand.is_assigned():
			var ball = $BodySlots/LeftHand.take_from_slot()
			if ball: 
				add_sibling(ball) # We just make assumptions like this. How do we handle changing of spaces
				ball.apply_impulse(pointer.current_global_direction * 5.0)
		elif pointer.current_collider and pointer.current_collider is Ball:
			$BodySlots/LeftHand.add_to_slot(pointer.current_collider)
			
	if Input.is_action_just_pressed("camera_toggle"):
		if $Head/HeadCam.current:
			$ThirdPersonCamera.current = true
		else: $Head/HeadCam.current = true
		
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
	# Configure the MultiplayerSynchronizer to know who owns this node
	# The NetworkManager named this node after its Peer ID string
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if is_current_player():
		# Lock and hide the mouse cursor for first-person style
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$Head/HeadCam.current = true

func _input(event: InputEvent) -> void:
	if not is_current_player(): return
	# Check if the mouse is moving
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate horizontally (Y-axis)
		rotate_y(-event.relative.x * camera_mouse_sensitivity)
		
		# Rotate vertically (X-axis) and clamp it so the camera doesn't flip
		camera.rotate_x(-event.relative.y * camera_mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, camera_min_pitch, camera_max_pitch)
		
