@tool
extends Node2D

var destroy = false
var last_key = ""
var sound = true

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var label: Label = $Label


func _ready():
	if sound:
		audio_stream_player.play()
	
	animated_sprite_2d.frame = 0
	animated_sprite_2d.play("default")
	animation_player.play("default")
	timer.start()
	label.text = last_key
	label.modulate = Color(randf_range(0,2), randf_range(0,2), randf_range(0,2))


func _on_Timer_timeout():
	if destroy:
		queue_free()
