class_name Rat
extends CharacterBody3D

@export var death_chunks_scene:PackedScene

var _explosion_force:float = 25
var _chunks_to_spawn:int = 6

@onready var anim = $RatAnimationPlayer 
@onready var music_man:MusicPlayer = get_node("/root/MusicPlayerSingleton")

func _ready():
	var stream_player:AudioStreamPlayer = music_man.audio_player
	var stream:AudioStream = stream_player.stream
	var bpm = stream.bpm
	var beats_per_second = bpm / 60
	print(beats_per_second)
	anim.speed_scale = beats_per_second 

func take_damage(normal:Vector3) -> void:
	die(normal)
	queue_free()

func die(normal:Vector3) -> void:
	for i in _chunks_to_spawn:
		var chunk:GoreChunk = death_chunks_scene.instantiate()
		get_parent().add_child(chunk)
		chunk.position = position
		chunk.init(normal, _explosion_force)

@onready var dialog_man:DialogSystem = get_node("/root/UISingleton").DIALOG_MANAGER
@export var dialog:dialog_resource
func interact() -> void:
	if (dialog):
		dialog_man.init(dialog)
