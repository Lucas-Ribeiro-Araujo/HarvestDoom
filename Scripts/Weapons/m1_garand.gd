extends "res://Scripts/Weapons/weapon.gd"

@export_category("m1 garand")
@export var ads_position:Vector3
@export var anim_player:AnimationPlayer

func action_2(pressed: bool) -> void:
	if pressed:
		target_position = ads_position
		bob = false
		sway = true
	else:
		target_position = default_position
		bob = true
		sway = true

func reload(pressed: bool) -> void:
	if pressed:
		anim_player.play("Reload")
		pass
