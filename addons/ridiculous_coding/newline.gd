@tool
extends Node2D

var destroy = false
var blips = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer


func _ready():
	if blips:
		animation_player.stop()
		animation_player.play("default")
		animated_sprite_2d.frame = 0
		animated_sprite_2d.play("default")
		
	timer.start()


func _on_Timer_timeout():
	if destroy:
		queue_free()
