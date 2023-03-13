extends Node3D

@export var left_skeleton_ik:SkeletonIK3D
@export var right_skeleton_ik:SkeletonIK3D
@export var targetWeapon:weapon


func _ready():
	if right_skeleton_ik != null:
		right_skeleton_ik.target_node = targetWeapon.hand1_target.get_path()
		right_skeleton_ik.start()
	if left_skeleton_ik != null:
		left_skeleton_ik.target_node = targetWeapon.hand2_target.get_path()
		left_skeleton_ik.start()

