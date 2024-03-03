@tool
extends Window

signal transfer_stats_data_rc

const MSG01:String = "--> RC: Shake Intensity multiplier set: "
const MSG02:String = "--> RC: Sound Volume addend set: "

var stats:StatsDataRC = StatsDataRC.new()

@onready var sound_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/SoundCheckbox
@onready var sound_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/SoundSliderMaster
@onready var shake_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/ShakeCheckbox
@onready var shake_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/ShakeSlider
@onready var chars_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/CharsCheckbox

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			emit_signal("transfer_stats_data_rc")
			print_debug("--> RC: Settings menu closed")
			queue_free()

func _ready() -> void:
	_connect_checkboxes()
	_load_checkbox_state()

func _load_checkbox_state() -> void:
	sound_checkbox.button_pressed = stats.sound
	sound_slider.value = stats.sound_addend
	shake_checkbox.button_pressed = stats.shake
	shake_slider.value = stats.shake_scalar
	chars_checkbox.button_pressed = stats.chars

func _connect_checkboxes() -> void:
	sound_checkbox.toggled.connect(func(toggled) -> void:
		stats.sound = toggled
	)
	sound_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG02+str(sound_slider.value))
		stats.sound_addend = sound_slider.value
	)
	shake_checkbox.toggled.connect(func(toggled) -> void:
		stats.shake = toggled
	)
	shake_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG01+str(shake_slider.value))
		stats.shake_scalar = shake_slider.value
	)
	chars_checkbox.toggled.connect(func(toggled) -> void:
		stats.chars = toggled
	)
