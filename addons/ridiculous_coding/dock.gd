@tool
class_name RidiculousCodingDock extends Control

const BASE_XP:int = 50
const ROOT_PATH:String = "user://"
const FILE_NAME:String = "ridiculous_xp.tres"
const WARN:String = "RidiculousCoding plugin couldn't load any savedata, proceed to load and save default config!\nShould the addon not work proceed to RELOAD!"
const MSG01:String = "--> RC: Shake Intensity multiplier set: "
const MSG02:String = "--> RC: Sound Volume addend set: "

const RANKS := {
	10:  "initiate",
	20:  "novice",
	30:  "neophyte",
	40:  "apprentice",
	50:  "journeyman",
	60:  "adept",
	66:  "devilish",
	70:  "wayfarer",
	85:  "master",
	100: "devotee",
	115: "seasoned",
	135: "veteran",
	155: "elite",
	175: "legendary",
	200: "demigod",
	333: "G.O.A.T",
	999: "addicted",
}

var xp_next:int = 2 * BASE_XP
var stats:StatsDataRC

@onready var explosion_checkbox:CheckButton = $VBoxContainer/GridContainer/ExplosionCheckbox
@onready var blips_checkbox:CheckButton = $VBoxContainer/GridContainer/BlipCheckbox
@onready var newline_checkbox:CheckButton = $VBoxContainer/GridContainer/NewlineCheckbox
@onready var chars_checkbox:CheckButton = $VBoxContainer/GridContainer/CharsCheckbox
@onready var shake_checkbox:CheckButton = $VBoxContainer/GridContainer/ShakeCheckbox
@onready var shake_slider:HSlider = $VBoxContainer/GridContainer/ShakeSlider
@onready var sound_checkbox:CheckButton = $VBoxContainer/GridContainer/SoundCheckbox
@onready var sound_slider:HSlider = $VBoxContainer/GridContainer/SoundSlider
@onready var fireworks_checkbox:CheckButton = $VBoxContainer/GridContainer/FireworksCheckbox
@onready var progress:TextureProgressBar = $VBoxContainer/XP/ProgressBar
@onready var sfx_fireworks:AudioStreamPlayer = $VBoxContainer/XP/ProgressBar/SFXfireworks
@onready var fireworks_timer:Timer = $VBoxContainer/XP/ProgressBar/FireworksTimer
@onready var fire_particles_one:GPUParticles2D = $VBoxContainer/XP/ProgressBar/Fire1/GPUParticles2D
@onready var fire_particles_two:GPUParticles2D = $VBoxContainer/XP/ProgressBar/Fire2/GPUParticles2D
@onready var xp_label:Label = $VBoxContainer/XP/HBoxContainer/XPlabel
@onready var level_label:Label = $VBoxContainer/XP/HBoxContainer/LevelLabel
@onready var reset_button:Button = $VBoxContainer/CenterContainer/ResetButton

func _ready() -> void:
	if _verify_file() == false:
		push_warning(WARN)
		stats = StatsDataRC.new()
		write_savefile()
	else: stats = _load_savefile()

	reset_button.pressed.connect(_on_reset_button_pressed)
	fireworks_timer.timeout.connect(_stop_fireworks); _stop_fireworks()
	_connect_checkboxes()

	_load_checkbox_state()
	_load_experience_progress()
	_update_progress()

func _load_checkbox_state() -> void:
	explosion_checkbox.button_pressed = stats.explosions
	blips_checkbox.button_pressed = stats.blips
	newline_checkbox.button_pressed = stats.newline
	chars_checkbox.button_pressed = stats.chars
	shake_checkbox.button_pressed = stats.shake
	sound_checkbox.button_pressed = stats.sound
	fireworks_checkbox.button_pressed = stats.fireworks
	sound_slider.value = stats.sound_addend
	shake_slider.value = stats.shake_scalar

func _load_experience_progress() -> void:
	xp_next = 2 * BASE_XP
	progress.max_value = xp_next
	for i in range(2,stats.level+1):
		xp_next += round(BASE_XP * i / 10.0) * 10
		progress.max_value = round(BASE_XP * stats.level / 10.0) * 10
	progress.value = stats.xp - (xp_next - progress.max_value)

func _start_fireworks() -> void:
	if stats.sound == true:
		var base_db:float = -8.0
		sfx_fireworks.volume_db = base_db + stats.sound_addend
		sfx_fireworks.play()
	fireworks_timer.start()
	fire_particles_one.emitting = true
	fire_particles_two.emitting = true

func _stop_fireworks() -> void:
	fire_particles_one.emitting = false
	fire_particles_two.emitting = false

func _on_typing() -> void:
	stats.xp += 1
	progress.value += 1
	if progress.value >= progress.max_value:
		stats.level += 1
		xp_next = stats.xp + round(BASE_XP * stats.level / 10.0) * 10
		progress.value = 0
		progress.max_value = xp_next - stats.xp
		for level in RANKS.keys(): if stats.level >= level: stats.rank = RANKS[level]
		if stats.fireworks == true: _start_fireworks()
	_update_progress()

func _update_progress() -> void:
	xp_label.text = "XP %d / %d" % [stats.xp,xp_next]
	level_label.text = "%s dev - Lvl %d" % [stats.rank,stats.level]

func _connect_checkboxes() -> void:
	explosion_checkbox.toggled.connect(func(toggled) -> void:
		stats.explosions = toggled
	)
	blips_checkbox.toggled.connect(func(toggled) -> void:
		stats.blips = toggled
	)
	newline_checkbox.toggled.connect(func(toggled) -> void:
		stats.newline = toggled
	)
	chars_checkbox.toggled.connect(func(toggled) -> void:
		stats.chars = toggled
	)
	shake_checkbox.toggled.connect(func(toggled) -> void:
		stats.shake = toggled
	)
	shake_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG01+str(shake_slider.value))
		stats.shake_scalar = shake_slider.value
	)
	sound_checkbox.toggled.connect(func(toggled) -> void:
		stats.sound = toggled
	)
	sound_slider.drag_ended.connect(func(_bool:bool) -> void:
		print_debug(MSG02+str(sound_slider.value))
		stats.sound_addend = sound_slider.value
	)
	fireworks_checkbox.toggled.connect(func(toggled) -> void:
		stats.fireworks = toggled
	)

func _on_reset_button_pressed() -> void:
	xp_next = 2 * BASE_XP
	progress.value = 0
	progress.max_value = xp_next
	stats = StatsDataRC.new()
	_load_checkbox_state()
	_update_progress()

func write_savefile() -> void:
	ResourceSaver.save(stats,ROOT_PATH+FILE_NAME,0)

func _load_savefile() -> Resource:
	return ResourceLoader.load(ROOT_PATH+FILE_NAME,"",0)

func _verify_file() -> bool:
	if DirAccess.open(ROOT_PATH).file_exists(FILE_NAME) == true: return true
	else: return false
