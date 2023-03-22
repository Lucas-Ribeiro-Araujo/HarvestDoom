extends CharacterBody3D

@export var death_chunks_scene:PackedScene

func take_damage():
	queue_free()
	print("oof ouchie ouwie")
