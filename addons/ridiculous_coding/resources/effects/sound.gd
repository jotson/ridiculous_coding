@tool
class_name RcSound extends Node

var destroy:bool = false
var pitch_increment:float = 0.0
var base_db:float = 0.0
var sound_addend:float = 0.0
var sound_selected:AudioStreamWAV

@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer
@onready var timer:Timer = $Timer

func _ready() -> void:
	audio_stream_player.stream = sound_selected
	audio_stream_player.volume_db = base_db + sound_addend
	audio_stream_player.pitch_scale = 1.0 + pitch_increment * 0.01
	audio_stream_player.play()
	timer.start()

func _on_timer_timeout() -> void: if destroy == true: queue_free()
