class_name gore_chunk extends Node3D

@export var rigidbody:RigidBody3D 
var direction_range:float = .5
var force_range:float = .1
var max_bounces:int = 4
var cur_bounces:int = 0

func init(direction:Vector3, force:float) -> void:
	var x:float = randf_range(direction_range,  -direction_range)
	var y:float = randf_range(direction_range,  -direction_range)
	var z:float = randf_range(direction_range,  -direction_range)
	var final_dir:Vector3 = (direction + Vector3(x,y,z)).normalized()
	
	var final_force:float = force * randf_range(1 + force_range, 1 - force_range)
	
	rigidbody.apply_impulse(final_dir * -final_force, position)


func _on_rat_chunk_body_entered(body):
	cur_bounces += 1
	print(body)
	if cur_bounces > max_bounces:
		queue_free()


func _on_timer_timeout():
	queue_free()
