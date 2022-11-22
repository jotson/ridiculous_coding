@tool
extends Node2D

var destroy: bool = false
var last_key: String = ""
var pitch_increase: float = 0.0
var sound: bool = true
var blips: bool = true

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particle_2d: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer
@onready var label: Label = $Label


func _ready():
	if sound:
		audio_stream_player.pitch_scale = 1.0 + pitch_increase * 0.01
		audio_stream_player.play()
	
	if blips:
		animated_sprite_2d.frame = 0
		animated_sprite_2d.play("default")
		animated_player.play("default")
		gpu_particle_2d.emitting = true
	
	timer.start()
	label.text = last_key
	label.modulate = Color(randf_range(0,2), randf_range(0,2), randf_range(0,2))


func _on_Timer_timeout():
	if destroy:
		queue_free()
