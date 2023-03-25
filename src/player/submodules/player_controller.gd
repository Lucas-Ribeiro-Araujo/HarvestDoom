class_name PlayerController
extends CharacterBody3D

const SPEED_DEFAULT = 7
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 7

var direction = Vector3()
var gravity_vec = Vector3()
var mouse_mov = Vector3()

var _accel = ACCEL_DEFAULT
var _speed = 7
var _gravity = 5
var _jump = 1.5
var _cam_accel = 40
var _mouse_sense = 0.1
var _movement = Vector3()
var _has_control = true

@onready var head:Node3D = $Head
@onready var camera:Camera3D = $Head/Camera3D
@onready var equipedWeapon:Weapon = $Head/Camera3D/Hand/M1Garand
@onready var interaction:interactor = $Head/Camera3D/InteractionRayCast

func _ready():
	if equipedWeapon:
		equipedWeapon.character = self
		

func _input(event):
	#check mouse input to confine it
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#get mouse input for camera rotation
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_mov = event.relative
		rotate_y(deg_to_rad(-event.relative.x * _mouse_sense))
		head.rotate_x(deg_to_rad(-event.relative.y * _mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	if _has_control:
		if event.is_action_pressed("interact"):
			interaction.interact()
	
	if equipedWeapon:
		if event.is_action_pressed("action_1"):
			equipedWeapon.action_1(true)
		elif  event.is_action_released("action_1"):
			equipedWeapon.action_1(false)
		if event.is_action_pressed("action_2"):
			equipedWeapon.action_2(true)
		elif  event.is_action_released("action_2"):
			equipedWeapon.action_2(false)
		elif  event.is_action_pressed("reload"):
			equipedWeapon.reload(true)

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.physics_ticks_per_second:
		camera.top_level = true
		camera.global_transform.origin = camera.global_transform.origin.lerp(head.global_transform.origin, _cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.top_level = false
		camera.global_transform = head.global_transform

func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var h_input = Input.get_action_strength("strafe_right") - Input.get_action_strength("strafe_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
	if is_on_floor():
		_accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		_accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * _gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vec = Vector3.UP * _jump
	
	#make it move
	
	velocity = velocity.lerp(direction * _speed, _accel * delta) + gravity_vec
	
	move_and_slide()
