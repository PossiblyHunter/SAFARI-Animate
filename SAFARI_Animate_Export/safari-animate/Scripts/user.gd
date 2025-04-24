extends CharacterBody3D


const SPEED = 7.0
@onready var camera_controller := $camera_controller
@onready var camera := $camera_controller/Camera3D

func _ready() -> void:
	var parent = get_parent()
	parent.connect("initialization_complete", ion_move)
	

func ion_move() -> void: # Function to bring ion_val to this script once it's done
	var parent = get_parent()
	var ion_m = parent.ion_val

# Camera Control
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_controller.rotate_y(-event.relative.x * 0.003)
			camera.rotate_x(-event.relative.y * 0.003)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

# Movement
func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back") # Handles horizontal movement
	var input_vert := Input.get_axis("move_down", "move_up") # Vertical movement
	var direction = (camera_controller.transform.basis * Vector3(input_dir.x, input_vert, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
