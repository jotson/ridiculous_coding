@tool
class_name Boom extends Node2D

var destroy:bool = false
var last_key:String = ""
var sound:bool = true
var sound_addend:int = 0

@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite_2d:AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var timer:Timer = $Timer
@onready var label:Label = $Label

func _ready():
	if sound:
		var base_db:int = -25
		audio_stream_player.volume_db = base_db+sound_addend
		audio_stream_player.play()
	animated_sprite_2d.frame = 0
	animated_sprite_2d.play("default")
	animation_player.play("default")
	timer.start()
	label.text = last_key
	label.modulate = Color(randf_range(0,2),randf_range(0,2),randf_range(0,2),randf_range(0.9,1))

func _on_Timer_timeout(): if destroy: queue_free()
