@tool
class_name Dock extends Control

const BASE_XP:int = 50
const ROOT_PATH:String = "user://"
const FILE_NAME:String = "ridiculous_xp.tres"
const WARN:String = "RidiculousCoding plugin couldn't load any savedata, proceed to load and save default config!\nShould the addon not work proceed to RELOAD!"
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
var xp_next:int = 2*BASE_XP
var stats:StatsDataRC

@onready var explosion_checkbox:CheckButton = $VBoxContainer/GridContainer/explosionCheckbox
@onready var blips_checkbox:CheckButton = $VBoxContainer/GridContainer/blipCheckbox
@onready var newline_checkbox:CheckButton = $VBoxContainer/GridContainer/newlineCheckbox
@onready var chars_checkbox:CheckButton = $VBoxContainer/GridContainer/charsCheckbox
@onready var shake_checkbox:CheckButton = $VBoxContainer/GridContainer/shakeCheckbox
@onready var shake_slider:HSlider = $VBoxContainer/GridContainer/shakeSlider
@onready var sound_checkbox:CheckButton = $VBoxContainer/GridContainer/soundCheckbox
@onready var sound_slider:HSlider = $VBoxContainer/GridContainer/soundSlider
@onready var fireworks_checkbox:CheckButton = $VBoxContainer/GridContainer/fireworksCheckbox
@onready var progress:TextureProgressBar = $VBoxContainer/XP/ProgressBar
@onready var sfx_fireworks:AudioStreamPlayer = $VBoxContainer/XP/ProgressBar/sfxFireworks
@onready var fireworks_timer:Timer = $VBoxContainer/XP/ProgressBar/fireworksTimer
@onready var fire_particles_one:GPUParticles2D = $VBoxContainer/XP/ProgressBar/fire1/GPUParticles2D
@onready var fire_particles_two:GPUParticles2D = $VBoxContainer/XP/ProgressBar/fire2/GPUParticles2D
@onready var xp_label:Label = $VBoxContainer/XP/HBoxContainer/xpLabel
@onready var level_label:Label = $VBoxContainer/XP/HBoxContainer/levelLabel
@onready var reset_button:Button = $VBoxContainer/CenterContainer/resetButton

func _ready():
	if _verify_file() == false:
		push_warning(WARN)
		stats = StatsDataRC.new()
		_write_savefile()
	else: stats = _load_savefile()

	reset_button.pressed.connect(on_reset_button_pressed)
	fireworks_timer.timeout.connect(stop_fireworks); stop_fireworks()
	connect_checkboxes()

	load_checkbox_state()
	load_experience_progress()
	update_progress()

func load_checkbox_state():
	explosion_checkbox.button_pressed = stats.explosions
	blips_checkbox.button_pressed = stats.blips
	newline_checkbox.button_pressed = stats.newline
	chars_checkbox.button_pressed = stats.chars
	shake_checkbox.button_pressed = stats.shake
	sound_checkbox.button_pressed = stats.sound
	fireworks_checkbox.button_pressed = stats.fireworks
	sound_slider.value = stats.sound_addend
	shake_slider.value = stats.shake_scalar

func load_experience_progress():
	xp_next = 2*BASE_XP
	progress.max_value = xp_next
	for i in range(2,stats.level+1):
		xp_next += round(BASE_XP * i / 10.0) * 10
		progress.max_value = round(BASE_XP * stats.level / 10.0) * 10
	progress.value = stats.xp - (xp_next - progress.max_value)

func start_fireworks():
	if stats.sound:
		var base_db:int = -8
		sfx_fireworks.volume_db = base_db+stats.sound_addend
		sfx_fireworks.play()
	fireworks_timer.start()
	fire_particles_one.emitting = true
	fire_particles_two.emitting = true

func stop_fireworks():
	fire_particles_one.emitting = false
	fire_particles_two.emitting = false

func _on_typing():
	stats.xp += 1
	progress.value += 1
	if progress.value >= progress.max_value:
		stats.level += 1
		xp_next = stats.xp + round(BASE_XP * stats.level / 10.0) * 10
		progress.value = 0
		progress.max_value = xp_next - stats.xp
		for level in RANKS.keys(): if stats.level >= level: stats.rank = RANKS[level]
		if stats.fireworks: start_fireworks()
	_write_savefile()
	update_progress()

func update_progress():
	xp_label.text = "XP %d / %d" % [ stats.xp, xp_next ]
	level_label.text = "%s dev - Lvl %d" % [ stats.rank, stats.level ]

func connect_checkboxes():
	explosion_checkbox.toggled.connect(func(toggled):
		stats.explosions = toggled
		_write_savefile()
	)
	blips_checkbox.toggled.connect(func(toggled):
		stats.blips = toggled
		_write_savefile()
	)
	newline_checkbox.toggled.connect(func(toggled):
		stats.newline = toggled
		_write_savefile()
	)
	chars_checkbox.toggled.connect(func(toggled):
		stats.chars = toggled
		_write_savefile()
	)
	shake_checkbox.toggled.connect(func(toggled):
		stats.shake = toggled
		_write_savefile()
	)
	shake_slider.drag_ended.connect(func(_bool:bool):
		print_debug("--> RC: Shake Intensity multiplier set: ",shake_slider.value)
		stats.shake_scalar = shake_slider.value
		_write_savefile()
	)
	sound_checkbox.toggled.connect(func(toggled):
		stats.sound = toggled
		_write_savefile()
	)
	sound_slider.drag_ended.connect(func(_bool:bool):
		print_debug("--> RC: Sound Volume addend set: ",sound_slider.value)
		stats.sound_addend = sound_slider.value
		_write_savefile()
	)
	fireworks_checkbox.toggled.connect(func(toggled):
		stats.fireworks = toggled
		_write_savefile()
	)

func on_reset_button_pressed():
	xp_next = 2*BASE_XP
	progress.value = 0
	progress.max_value = xp_next
	stats = StatsDataRC.new()
	_write_savefile()
	load_checkbox_state()
	update_progress()

func _write_savefile() -> void:
	ResourceSaver.save(stats,ROOT_PATH+FILE_NAME,0)

func _load_savefile() -> Resource:
	return ResourceLoader.load(ROOT_PATH+FILE_NAME,"",0)

func _verify_file() -> bool:
	if DirAccess.open(ROOT_PATH).file_exists(FILE_NAME) == true: return true
	else: return false
