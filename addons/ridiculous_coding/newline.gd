@tool
class_name Newline extends Node2D

var destroy:bool = false
var newline:bool = true

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var newline_sprite:AnimatedSprite2D = $NewlineSprite
@onready var timer:Timer = $Timer

func _ready() -> void:
	if newline == true:
		animation_player.stop()
		animation_player.play("default")
		newline_sprite.frame = 0
		newline_sprite.play("default")
	timer.start()

func _on_timer_timeout() -> void: if destroy == true: queue_free()
