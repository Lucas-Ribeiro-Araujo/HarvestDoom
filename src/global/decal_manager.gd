class_name DecalManager
extends Node

const max_decals = 50

var instantiated_decals:Array = []

func new_decal(scene:PackedScene, position:Vector3, normal:Vector3):
	var instance:Node3D = scene.instantiate()
	add_child(instance)
	
	instance.position = position
	instance.look_at(Vector3.FORWARD, normal)
	
	print(normal, instance.rotation)
	
	instantiated_decals.append(instance)
	decal_dequeue()

func decal_dequeue():
	if instantiated_decals.size() > max_decals:
		instantiated_decals.pop_front().queue_free()
		
	
