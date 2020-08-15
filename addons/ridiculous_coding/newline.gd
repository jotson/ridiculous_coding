tool
extends Node2D

var destroy = false

func _ready():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("default")
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("default")
	$Timer.start()

func _on_Timer_timeout():
	if destroy:
		queue_free()
