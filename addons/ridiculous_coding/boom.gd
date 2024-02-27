@tool
class_name Boom extends Node2D

var destroy:bool = false
var last_key:String = ""
var sound:bool = true
var sound_addend:float = 0.0
var explosions:bool = false

@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite_2d:AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var timer:Timer = $Timer
@onready var label:Label = $Label

func _ready():
	if explosions and sound:
		var base_db:float = -25.0
		audio_stream_player.volume_db = base_db+sound_addend
		audio_stream_player.play()
	if explosions:
		animated_sprite_2d.frame = 0
		animated_sprite_2d.play("default")
	animation_player.play("default")
	timer.start()
	label.text = last_key
	label.modulate = Color(randf_range(1,2),randf_range(0,1.5),randf_range(0,0.4),randf_range(0.85,1))

func _on_Timer_timeout(): if destroy: queue_free()
