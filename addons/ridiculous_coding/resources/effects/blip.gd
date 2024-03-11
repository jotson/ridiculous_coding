@tool
class_name RcBlip extends Node2D

var destroy:bool = false
var blips:bool = false

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var blip_sprite:AnimatedSprite2D = $BlipSprite
@onready var timer:Timer = $Timer

func _ready() -> void:
	if blips == true:
		animation_player.stop()
		animation_player.play("default")
		blip_sprite.frame = 0
		blip_sprite.play("default")
	timer.start()

func _on_timer_timeout() -> void: if destroy == true: queue_free()
