class_name weapon extends Node3D 

#NEEDS REFACTORING

var character:CharacterController

@export var left_hand_target:Node3D
@export var right_hand_target:Node3D

var bob:bool = true
@export var frequency:float = 5
@export var amplitude:float = .02
@export var vertical_influence:float = .05

var time:float = 0
var movement:float
var theta:float = 0

var default_position:Vector3
var target_position:Vector3

@export_category("Sway")
@export var sway:bool = true;
@export var sway_lerp:float = 5
@export var sway_amnt: float = .05
@export var sway_treshold: float = 2

func _ready():
	default_position = position
	target_position = default_position

func _process(delta):
	if character:
		BobbingAnimation(delta)
		SwayAnimation(delta)
		
#		#Raycast from screen center
#		var space_state = get_world_3d().direct_space_state
#		var point = get_viewport().size/2
#		var start = character.camera.project_ray_origin(point)
#		var finish = start + character.camera.project_ray_normal(point) * 1000
#
#		var rayPar = PhysicsRayQueryParameters3D.create(start, finish)
#
#		var worldhitPoint = space_state.intersect_ray(rayPar)
#		if worldhitPoint:
#			look_at(worldhitPoint.position, Vector3.UP)
#
#		pass

func SwayAnimation(delta):
	if !sway:
		return
	
	var mouse_mov = character.mouse_mov
	if character.mouse_mov != null:
		if mouse_mov.length() > sway_treshold:
			var finalRot = Vector3()
			finalRot.y = sway_amnt * -mouse_mov.normalized().x
			finalRot.x = sway_amnt * -mouse_mov.normalized().y
			rotation = rotation.lerp(finalRot, sway_lerp * delta)
		else:
			rotation = rotation.lerp(Vector3.ZERO, sway_lerp * delta)

func BobbingAnimation(delta):
	time += delta
	
	var verticalMove:float = signf(character.gravity_vec.y)
	var horizontalMove:float = 0
	if verticalMove == 0: 
		horizontalMove = (Vector2(character.direction.x,character.direction.z).length() + 1) 
		horizontalMove *= frequency
	
	movement = cos(delta * horizontalMove + theta) * amplitude
	
	var finalY = default_position.y + movement
	if verticalMove != 0: 
		finalY += vertical_influence
	
	if bob:
		target_position.y = finalY
	
	position = lerp(position ,target_position, 10 * delta)
	
	theta = fmod(delta * horizontalMove + theta, 2 * PI) 

func action_1(pressed: bool) -> void:
	pass

func action_2(pressed: bool) -> void:
	pass

func reload(pressed: bool) -> void:
	pass
