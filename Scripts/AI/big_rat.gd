extends CharacterBody3D

@export var death_chunks_scene:PackedScene

var explosion_force:float = 12
var chunks_to_spawn:int = 6

func _ready():
	death_chunks_scene = load("res://Scenes/Characters/Rat/rat_chunk.tscn")

func take_damage(normal:Vector3) -> void:
	die(normal)
	queue_free()

func die(normal:Vector3) -> void:
	for i in chunks_to_spawn:
		var chunk:gore_chunk = death_chunks_scene.instantiate()
		get_parent().add_child(chunk)
		chunk.position = position
		chunk.init(normal, explosion_force)
