class_name weapon extends Node3D 

var character:CharacterController

@export var hand1_target:Node3D
@export var hand2_target:Node3D

var bob:bool = true
@export var frequency:float = 5
@export var amplitude:float = .02
@export var vertical_influence:float = .05

var time:float = 0
var movement:float
var theta:float = 0

var default_position:Vector3
var target_position:Vector3

var sway:bool = true;
var sway_lerp:float = 5
@export var sway_amnt: float

func _ready():
	default_position = position
	target_position = default_position

func _process(delta):
	if character:
		BobbingAnimation(delta)
		SwayAnimation(delta)
		pass

func SwayAnimation(delta):
	if !sway:
		return
	
	var mouse_mov = character.mouse_mov
	if character.mouse_mov != null:
		if mouse_mov.length() > 5:
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
