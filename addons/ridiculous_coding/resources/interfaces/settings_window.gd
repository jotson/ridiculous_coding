@tool
class_name RcWindow extends Window

signal rc_window_debug_pitch

#region Constants
const ROOT_PATH:String = "user://"
const FILE_NAME:String = "ridiculous_xp.tres"

const MSG01:String = "--> RC: %s shake intensity multiplier set: "
const MSG02:String = "--> RC: %s sound volume addend set: "
const MSG03:String = "--> RC: Settings Window received close request!"
const MSG04:String = "--> RC: Pitch %s set: "
#endregion
var stats:StatsDataRC = StatsDataRC.new()
#region Onready Variables
@onready var update_addon_button:Button = $ScrollContainer/Control/MarginContainer/VBoxContainer/CenterContainerUpdate/UpdateButton
@onready var reset_settings_button:Button = $ScrollContainer/Control/MarginContainer/VBoxContainer/CenterContainerReset/ResetButton

@onready var sound_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/SoundCheckbox
@onready var sound_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/SoundSlider
@onready var shake_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/ShakeCheckbox
@onready var shake_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/ShakeSlider
@onready var chars_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/CharsCheckbox

@onready var newline_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerNewline/NewlineCheckbox
@onready var newline_shake_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerNewline/NewlineShakeCheckbox
@onready var newline_shake_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerNewline/NewlineShakeSlider

@onready var explosions_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerExplosions/ExplosionsCheckbox
@onready var explosions_chars_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerExplosions/ExplosionsCharsCheckbox
@onready var explosions_shake_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerExplosions/ExplosionsShakeCheckbox
@onready var explosions_shake_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerExplosions/ExplosionsShakeSlider
@onready var explosions_sound_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerExplosions/ExplosionsSound
@onready var explosions_sound_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerExplosions/ExplosionsSoundSlider

@onready var blips_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/BlipsCheckbox
@onready var blips_chars_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/BlipsCharsCheckbox
@onready var blips_shake_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/BlipsShakeCheckbox
@onready var blips_shake_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/BlipsShakeSlider
@onready var blips_sound_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/BlipsSoundCheckbox
@onready var blips_sound_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/BlipsSoundSlider
@onready var blips_sound_selected:OptionButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/BlipsSoundSelectionMenu
@onready var blips_sound_pitch_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/BlipsSoundPitchCheckbox
@onready var pitch_clamp_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/PitchClampSlider
@onready var pitch_increment_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/PitchIncrementSlider
@onready var pitch_decrement_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/PitchDecrementSlider
@onready var pitch_debug_button:Button = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlips/PitchDebugButton

@onready var fireworks_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerFireworks/FireworksCheckbox
@onready var fireworks_sound_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerFireworks/FireworksSoundCheckbox
@onready var fireworks_sound_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerFireworks/FireworksSoundSlider
#endregion

func _notification(what:int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			print_debug(MSG03)
			queue_free()
		_: pass

func _ready() -> void:
	# My hex color '201829' for the background
	# FIX: The return value of the editor settings color is unequal to the actual color set.

	#var editor_settings:EditorSettings = EditorSettings.new()
	#var editor_theme_color:Color = editor_settings.get("interface/theme/base_color")
	#%BackgroundColorRect.color = editor_theme_color
	#print("Color: ", editor_theme_color)

	_connect_settings()
	_load_settings_state()

func _load_settings_state() -> void:
	sound_checkbox.button_pressed = stats.sound
	sound_slider.value = stats.sound_addend
	shake_checkbox.button_pressed = stats.shake
	shake_slider.value = stats.shake_scalar
	chars_checkbox.button_pressed = stats.chars

	newline_checkbox.button_pressed = stats.newline
	newline_shake_checkbox.button_pressed = stats.newline_shake
	newline_shake_slider.value = stats.newline_shake_scalar

	explosions_checkbox.button_pressed = stats.explosions
	explosions_chars_checkbox.button_pressed = stats.explosions_chars
	explosions_shake_checkbox.button_pressed = stats.explosions_shake
	explosions_shake_slider.value = stats.explosions_shake_scalar
	explosions_sound_checkbox.button_pressed = stats.explosions_sound
	explosions_sound_slider.value = stats.explosions_sound_addend

	blips_checkbox.button_pressed = stats.blips
	blips_chars_checkbox.button_pressed = stats.blips_chars
	blips_shake_checkbox.button_pressed = stats.blips_shake
	blips_shake_slider.value = stats.blips_shake_scalar
	blips_sound_checkbox.button_pressed = stats.blips_sound
	blips_sound_slider.value = stats.blips_sound_addend
	blips_sound_selected.selected = stats.blips_sound_selected

	blips_sound_pitch_checkbox.button_pressed = stats.blips_sound_pitch
	pitch_clamp_slider.value = stats.pitch_clamp
	pitch_increment_slider.value = stats.pitch_increment
	pitch_decrement_slider.value = stats.pitch_decrement

	fireworks_checkbox.button_pressed = stats.fireworks
	fireworks_sound_checkbox.button_pressed = stats.fireworks_sound
	fireworks_sound_slider.value = stats.fireworks_sound_addend

func _connect_settings() -> void:
	# Util connections
	update_addon_button.pressed.connect(func() -> void:
		DirAccess.remove_absolute(ROOT_PATH+FILE_NAME)
		_reset_settings()
	)
	reset_settings_button.pressed.connect(func() -> void: _reset_settings())

	# Master connections
	sound_checkbox.toggled.connect(func(toggled:bool) -> void: stats.sound = toggled)
	sound_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG02 % ["Master"]+str(sound_slider.value))
		stats.sound_addend = sound_slider.value
	)
	shake_checkbox.toggled.connect(func(toggled:bool) -> void: stats.shake = toggled)
	shake_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG01 % ["Global"]+str(shake_slider.value))
		stats.shake_scalar = shake_slider.value
	)
	chars_checkbox.toggled.connect(func(toggled:bool) -> void: stats.chars = toggled)

	# Newline connections
	newline_checkbox.toggled.connect(func(toggled:bool) -> void: stats.newline = toggled)
	newline_shake_checkbox.toggled.connect(func(toggled:bool) -> void: stats.newline_shake = toggled)
	newline_shake_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG01 % ["Newline"]+str(newline_shake_slider.value))
		stats.newline_shake_scalar = newline_shake_slider.value
	)

	# Explosions connections
	explosions_checkbox.toggled.connect(func(toggled:bool) -> void: stats.explosions = toggled)
	explosions_chars_checkbox.toggled.connect(func(toggled:bool) -> void: stats.explosions_chars = toggled)
	explosions_shake_checkbox.toggled.connect(func(toggled:bool) -> void: stats.explosions_shake = toggled)
	explosions_shake_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG01 % ["Explosions"]+str(explosions_shake_slider.value))
		stats.explosions_shake_scalar = explosions_shake_slider.value
	)
	explosions_sound_checkbox.toggled.connect(func(toggled:bool) -> void: stats.explosions_sound = toggled)
	explosions_sound_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG02 % ["Explosions"]+str(explosions_sound_slider.value))
		stats.explosions_sound_addend = explosions_sound_slider.value
	)

	# Blips connections
	blips_checkbox.toggled.connect(func(toggled:bool) -> void: stats.blips = toggled)
	blips_chars_checkbox.toggled.connect(func(toggled:bool) -> void: stats.blips_chars = toggled)
	blips_shake_checkbox.toggled.connect(func(toggled:bool) -> void: stats.blips_shake = toggled)
	blips_shake_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG01 % ["Typing"]+str(blips_shake_slider.value))
		stats.blips_shake_scalar = blips_shake_slider.value
	)
	blips_sound_checkbox.toggled.connect(func(toggled:bool) -> void: stats.blips_sound = toggled)
	blips_sound_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG02 % ["Typing"]+str(blips_sound_slider.value))
		stats.blips_sound_addend = blips_sound_slider.value
	)
	blips_sound_selected.item_selected.connect(func(index:int) -> void: stats.blips_sound_selected = index)

	# Blips Pitch connections
	blips_sound_pitch_checkbox.toggled.connect(func(toggled:bool) -> void:
		stats.blips_sound_pitch = toggled
	)
	pitch_clamp_slider.drag_ended.connect(func(_bool:bool) -> void:
		stats.pitch_clamp = pitch_clamp_slider.value
		print_debug(MSG04 % ["clamp"]+str(pitch_clamp_slider.value))
	)
	pitch_increment_slider.drag_ended.connect(func(_bool:bool) -> void:
		stats.pitch_increment = pitch_increment_slider.value
		print_debug(MSG04 % ["increment"]+str(pitch_increment_slider.value))
	)
	pitch_decrement_slider.drag_ended.connect(func(_bool:bool) -> void:
		stats.pitch_decrement = pitch_decrement_slider.value
		print_debug(MSG04 % ["decrement"]+str(pitch_decrement_slider.value))
	)
	pitch_debug_button.pressed.connect(func() -> void: emit_signal("rc_window_debug_pitch"))

	# Fireworks connections
	fireworks_checkbox.toggled.connect(func(toggled:bool) -> void: stats.fireworks = toggled)
	fireworks_sound_checkbox.toggled.connect(func(toggled:bool) -> void: stats.fireworks_sound = toggled)
	fireworks_sound_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG02 % ["Fireworks"]+str(fireworks_sound_slider.value))
		stats.fireworks_sound_addend = fireworks_sound_slider.value
	)

func _reset_settings() -> void:
	var backup_xp:int = stats.xp
	var backup_level:int = stats.level
	var backup_rank:String = stats.rank

	stats = StatsDataRC.new()
	_load_settings_state()
	stats.xp = backup_xp
	stats.level = backup_level
	stats.rank = backup_rank

