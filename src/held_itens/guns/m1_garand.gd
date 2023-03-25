class_name M1Garand
extends Weapon

@export_category("M1 Garand")
@export var ads_position:Vector3
@export var ads_zoom:float
@export var bullet_hole:PackedScene

var default_fov:float
var can_fire:bool = true
var max_ammo:int = 9999
var current_ammo:int = max_ammo

@onready var decal_manager = get_node("/root/DecalSingleton")
@onready var anim_player:AnimationPlayer = $AnimationPlayer
@onready var audio_player:AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var gun_tip:BoneAttachment3D = $Armature/Skeleton3D/GunTipTarget

func action_1(pressed:bool) -> void:
	if pressed and can_fire and !anim_player.is_playing() and current_ammo > 0:
		anim_player.play("Fire")
		audio_player.play(0)
		can_fire = false
		current_ammo -= 1
		
		#Raycast from gun tip
		var forward = -gun_tip.global_transform.basis.z
		var from = gun_tip.global_transform.origin
		var to = gun_tip.global_transform.origin + forward * 100
		var space_state = get_world_3d().direct_space_state
		var ray_parameters = PhysicsRayQueryParameters3D.create(from, to)
		ray_parameters.hit_from_inside = true
		var _result = space_state.intersect_ray(ray_parameters)
		
		if _result:
			decal_manager.new_decal(bullet_hole, _result.position, _result.normal)
			var object = _result.collider
			if object.is_in_group("Unit"):
				if object.has_method("take_damage"):
					object.take_damage((from - to).normalized())
	
	elif current_ammo == 0:
		reload(true)

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
	if pressed and !anim_player.is_playing():
		anim_player.play("Reload")
		pass

func refresh_ammo() -> void:
	current_ammo = max_ammo

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fire":
		can_fire = true

