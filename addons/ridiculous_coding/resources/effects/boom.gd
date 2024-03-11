@tool
class_name RcBoom extends Node2D

var destroy:bool = false

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var boom_sprite:AnimatedSprite2D = $BoomSprite
@onready var timer:Timer = $Timer

func _ready() -> void:
	animation_player.play("default")
	boom_sprite.frame = 0
	boom_sprite.play("default")
	timer.start()

func _on_timer_timeout() -> void: if destroy == true: queue_free()
