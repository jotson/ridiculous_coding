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
@onready var key_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerMaster/KeyCheckbox

@onready var newline_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerNewline/NewlineCheckbox
@onready var newline_shake_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerNewline/NewlineShakeCheckbox
@onready var newline_shake_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerNewline/NewlineShakeSlider

@onready var boom_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBoom/BoomCheckbox
@onready var boom_key_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBoom/BoomKeyCheckbox
@onready var boom_shake_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBoom/BoomShakeCheckbox
@onready var boom_shake_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBoom/BoomShakeSlider
@onready var boom_sound_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBoom/BoomSound
@onready var boom_sound_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBoom/BoomSoundSlider

@onready var blip_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/BlipCheckbox
@onready var blip_key_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/BlipKeyCheckbox
@onready var blip_shake_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/BlipShakeCheckbox
@onready var blip_shake_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/BlipShakeSlider
@onready var blip_sound_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/BlipSoundCheckbox
@onready var blip_sound_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/BlipSoundSlider
@onready var blip_sound_selected:OptionButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/BlipSoundSelectionMenu
@onready var blip_sound_pitch_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/BlipSoundPitchCheckbox
@onready var pitch_clamp_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/PitchClampSlider
@onready var pitch_increment_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/PitchIncrementSlider
@onready var pitch_decrement_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/PitchDecrementSlider
@onready var pitch_debug_button:Button = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerBlip/PitchDebugButton

@onready var firework_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerFirework/FireworkCheckbox
@onready var firework_sound_checkbox:CheckButton = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerFirework/FireworkSoundCheckbox
@onready var firework_sound_slider:HSlider = $ScrollContainer/Control/MarginContainer/VBoxContainer/GridContainerFirework/FireworkSoundSlider
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
	key_checkbox.button_pressed = stats.key

	newline_checkbox.button_pressed = stats.newline
	newline_shake_checkbox.button_pressed = stats.newline_shake
	newline_shake_slider.value = stats.newline_shake_scalar

	boom_checkbox.button_pressed = stats.boom
	boom_key_checkbox.button_pressed = stats.boom_key
	boom_shake_checkbox.button_pressed = stats.boom_shake
	boom_shake_slider.value = stats.boom_shake_scalar
	boom_sound_checkbox.button_pressed = stats.boom_sound
	boom_sound_slider.value = stats.boom_sound_addend

	blip_checkbox.button_pressed = stats.blip
	blip_key_checkbox.button_pressed = stats.blip_key
	blip_shake_checkbox.button_pressed = stats.blip_shake
	blip_shake_slider.value = stats.blip_shake_scalar
	blip_sound_checkbox.button_pressed = stats.blip_sound
	blip_sound_slider.value = stats.blip_sound_addend
	blip_sound_selected.selected = stats.blip_sound_selected

	blip_sound_pitch_checkbox.button_pressed = stats.blip_sound_pitch
	pitch_clamp_slider.value = stats.pitch_clamp
	pitch_increment_slider.value = stats.pitch_increment
	pitch_decrement_slider.value = stats.pitch_decrement

	firework_checkbox.button_pressed = stats.firework
	firework_sound_checkbox.button_pressed = stats.firework_sound
	firework_sound_slider.value = stats.firework_sound_addend

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
	key_checkbox.toggled.connect(func(toggled:bool) -> void: stats.key = toggled)

	# Newline connections
	newline_checkbox.toggled.connect(func(toggled:bool) -> void: stats.newline = toggled)
	newline_shake_checkbox.toggled.connect(func(toggled:bool) -> void: stats.newline_shake = toggled)
	newline_shake_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG01 % ["Newline"]+str(newline_shake_slider.value))
		stats.newline_shake_scalar = newline_shake_slider.value
	)

	# Boom connections
	boom_checkbox.toggled.connect(func(toggled:bool) -> void: stats.boom = toggled)
	boom_key_checkbox.toggled.connect(func(toggled:bool) -> void: stats.boom_key = toggled)
	boom_shake_checkbox.toggled.connect(func(toggled:bool) -> void: stats.boom_shake = toggled)
	boom_shake_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG01 % ["Boom"]+str(boom_shake_slider.value))
		stats.boom_shake_scalar = boom_shake_slider.value
	)
	boom_sound_checkbox.toggled.connect(func(toggled:bool) -> void: stats.boom_sound = toggled)
	boom_sound_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG02 % ["Boom"]+str(boom_sound_slider.value))
		stats.boom_sound_addend = boom_sound_slider.value
	)

	# Blip connections
	blip_checkbox.toggled.connect(func(toggled:bool) -> void: stats.blip = toggled)
	blip_key_checkbox.toggled.connect(func(toggled:bool) -> void: stats.blip_key = toggled)
	blip_shake_checkbox.toggled.connect(func(toggled:bool) -> void: stats.blip_shake = toggled)
	blip_shake_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG01 % ["Typing"]+str(blip_shake_slider.value))
		stats.blip_shake_scalar = blip_shake_slider.value
	)
	blip_sound_checkbox.toggled.connect(func(toggled:bool) -> void: stats.blip_sound = toggled)
	blip_sound_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG02 % ["Typing"]+str(blip_sound_slider.value))
		stats.blip_sound_addend = blip_sound_slider.value
	)
	blip_sound_selected.item_selected.connect(func(index:int) -> void: stats.blip_sound_selected = index)

	# Blip Pitch connections
	blip_sound_pitch_checkbox.toggled.connect(func(toggled:bool) -> void:
		stats.blip_sound_pitch = toggled
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

	# Firework connections
	firework_checkbox.toggled.connect(func(toggled:bool) -> void: stats.firework = toggled)
	firework_sound_checkbox.toggled.connect(func(toggled:bool) -> void: stats.firework_sound = toggled)
	firework_sound_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG02 % ["Firework"]+str(firework_sound_slider.value))
		stats.firework_sound_addend = firework_sound_slider.value
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

