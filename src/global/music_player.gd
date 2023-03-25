class_name MusicPlayer
extends Node

signal music_beat

var beats_per_minute:float
var beats_per_second:float

@onready var audio_player:AudioStreamPlayer = $AudioPlayer
@onready var timer:Timer = $BeatTimer

func _ready():
	beats_per_second = audio_player.stream.bpm
	beats_per_second = beats_per_second/60
	print(beats_per_second)
	timer.wait_time = beats_per_second
	timer.start()


func _on_beat_timer_timeout():
	music_beat.emit()
	print("I IS BEAT")
