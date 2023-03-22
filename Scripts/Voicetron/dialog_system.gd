extends Control

const TEXT_SPEED:float = 0.05

@onready var text_field:Label = $Panel/DialogText
@onready var timer:Timer = $Panel/Timer
@onready var audio_player:AudioStreamPlayer = $Panel/AudioStreamPlayer
@onready var continue_prompt:Control = $Panel/ContinuePrompt
@onready var panel:Panel = $Panel

var dialog: dialog_resource
var writing: bool = false

var dialogs_to_display: int
var current_dialog_index: int = 0

var chars_to_write: int
var current_char_index: int = 0

func _ready():
	timer.wait_time = TEXT_SPEED
	
#	dialog = load("res://Scripts/Voicetron/test_dialog.tres")
#	init(dialog)

func init(dialog_res:dialog_resource) -> void:
	panel.visible = true
	
	dialog = dialog_res
	
	if dialog:
		text_field.text = ""
		writing = true
		timer.start()
		chars_to_write = dialog.textSegments[0].length()
		dialogs_to_display = dialog.textSegments.size()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		next_dialog()


func _on_timer_timeout():
	text_field.text += dialog.textSegments[current_dialog_index][current_char_index]
	play_char_audio(dialog.textSegments[current_dialog_index][current_char_index])
	current_char_index += 1
	
	if current_char_index == chars_to_write:
		writing = false
		timer.stop()
		continue_prompt.visible = true

func next_dialog() -> void:
	if dialog:
		text_field.text = ""
		current_dialog_index += 1
		continue_prompt.visible = false
		
		
		if current_dialog_index < dialogs_to_display:
			chars_to_write = dialog.textSegments[current_dialog_index].length()
			current_char_index = 0
			timer.start()
		
		else:
			timer.stop()
			dialog = null
			panel.visible = false
	

func play_char_audio(char:String) -> void:
	var sound_to_play:AudioStream = load("res://Data/Audio/Voicetron/Voice0/%s.wav" % char.capitalize())
	audio_player.stream = sound_to_play
	audio_player.play()
