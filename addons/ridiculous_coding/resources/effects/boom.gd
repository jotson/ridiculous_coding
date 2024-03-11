@tool
class_name RcBoom extends Node2D

var destroy:bool = false
var last_key:String = ""
var sound:bool = false
var sound_addend:float = 0.0
var explosions:bool = false

@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer
@onready var booms_sprite:AnimatedSprite2D = $BoomSprite
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var timer:Timer = $Timer
@onready var key_label:Label = $Label

func _ready() -> void:
	if sound == true:
		var base_db:float = -30.0
		audio_stream_player.volume_db = base_db + sound_addend
		audio_stream_player.play()
	if explosions == true:
		booms_sprite.frame = 0
		booms_sprite.play("default")
	animation_player.play("default")
	timer.start()
	key_label.text = last_key
	key_label.modulate = Color(randf_range(1,2),randf_range(0,1.5),randf_range(0,0.4),randf_range(0.85,1))

func _on_timer_timeout() -> void: if destroy == true: queue_free()
