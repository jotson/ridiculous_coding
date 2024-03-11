@tool
class_name RcKey extends Node

var destroy:bool = false
var key:bool = false
var last_key:String = ""
var animation_name:String = "default"

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var key_label:Label = $Label
@onready var timer:Timer = $Timer

func _ready() -> void:
	if key == true:
		key_label.text = last_key
		animation_player.stop()
		animation_player.play(animation_name)
	timer.start()
	print("finished READY for key",key_label.text)

func set_key_color(r1:float,r2:float,g1:float,g2:float,b1:float,b2:float,a1:float,a2:float) -> void:
	var key_label_:Label = $Label
	key_label_.modulate = Color(randf_range(r1,r2),randf_range(g1,g2),randf_range(b1,b2),randf_range(a1,a2))

func _on_timer_timeout() -> void: if destroy == true: queue_free()
