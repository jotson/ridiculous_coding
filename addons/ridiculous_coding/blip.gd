@tool
class_name Blip extends Node2D

var destroy:bool = false
var last_key:String = ""
var pitch_increase:float = 0.0
var sound:bool = true
var sound_addend:float = 0.0
var blips:bool = true

@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer
@onready var blips_sprite:AnimatedSprite2D = $BlipsSprite
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var timer:Timer = $Timer
@onready var key_label:Label = $Label

func _ready() -> void:
	if sound == true:
		var base_db:float = -5.0
		audio_stream_player.volume_db = base_db + sound_addend
		audio_stream_player.pitch_scale = 1.0 + pitch_increase * 0.01
		audio_stream_player.play()
	if blips == true:
		blips_sprite.frame = 0
		blips_sprite.play("default")
	animation_player.play("default")
	timer.start()
	key_label.text = last_key
	key_label.modulate = Color(randf_range(0,2),randf_range(0,2),randf_range(0,2))

func _on_timer_timeout() -> void: if destroy == true: queue_free()
