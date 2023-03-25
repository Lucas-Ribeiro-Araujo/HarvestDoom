extends Node3D

@export var left_skeleton_ik:SkeletonIK3D
@export var right_skeleton_ik:SkeletonIK3D
@export var targetWeapon:Weapon


func _ready():
	if targetWeapon:
		if right_skeleton_ik != null and targetWeapon.right_hand_target:
			right_skeleton_ik.target_node = targetWeapon.right_hand_target.get_path()
			right_skeleton_ik.start()
		if left_skeleton_ik != null and targetWeapon.left_hand_target:
			left_skeleton_ik.target_node = targetWeapon.left_hand_target.get_path()
			left_skeleton_ik.start()
