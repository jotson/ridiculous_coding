@tool
class_name RCwindow extends Window

signal rc_settings_window_is_exiting

const MSG01:String = "--> RC: Shake Intensity multiplier set: "
const MSG02:String = "--> RC: Sound Volume addend set: "

var stats:StatsDataRC = StatsDataRC.new()

@onready var update_addon_button:Button = $ScrollContainer/Control/MarginContainer/VBoxContainer/CenterContainerUpdate/UpdateButton
@onready var reset_settings_button:Button = $ScrollContainer/Control/MarginContainer/VBoxContainer/CenterContainerReset/ResetButton
@onready var sound_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/SoundCheckbox
@onready var sound_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/SoundSliderMaster
@onready var shake_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/ShakeCheckbox
@onready var shake_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/ShakeSlider
@onready var chars_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/CharsCheckbox
@onready var newline_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerNewline/NewlineCheckbox
@onready var explosion_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerExplosion/ExplosionCheckbox
@onready var blips_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/BlipCheckbox
@onready var fireworks_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerFireworks/FireworksCheckbox

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			emit_signal("rc_settings_window_is_exiting")
			print_debug("--> RC: Settings menu closed")
			queue_free()

func _ready() -> void:
	_connect_settings()
	_load_settings_state()

func _load_settings_state() -> void:
	sound_checkbox.button_pressed = stats.sound
	sound_slider.value = stats.sound_addend
	shake_checkbox.button_pressed = stats.shake
	shake_slider.value = stats.shake_scalar
	chars_checkbox.button_pressed = stats.chars
	newline_checkbox.button_pressed = stats.newline
	explosion_checkbox.button_pressed = stats.explosions
	blips_checkbox.button_pressed = stats.blips
	fireworks_checkbox.button_pressed = stats.fireworks

func _connect_settings() -> void:
	update_addon_button.pressed.connect(func() -> void:
		_reset_settings()
	)
	reset_settings_button.pressed.connect(func() -> void:
		_reset_settings()
	)
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
	newline_checkbox.toggled.connect(func(toggled) -> void:
		stats.newline = toggled
	)
	explosion_checkbox.toggled.connect(func(toggled) -> void:
		stats.explosions = toggled
	)
	blips_checkbox.toggled.connect(func(toggled) -> void:
		stats.blips = toggled
	)
	fireworks_checkbox.toggled.connect(func(toggled) -> void:
		stats.fireworks = toggled
	)

func _reset_settings() -> void:
	var xp:int = stats.xp
	var level:int = stats.level
	var rank:String = stats.rank
	stats = StatsDataRC.new()
	stats.xp = xp
	stats.level = level
	stats.rank = rank
	_load_settings_state()
