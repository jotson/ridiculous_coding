@tool
class_name RidiculousCodingDock extends Control

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

var xp_next:int = 2 * BASE_XP
var stats:StatsDataRC

var backup_xp:int
var backup_level:int = 0
var backup_rank:String

@onready var progress:TextureProgressBar = $VBoxContainer/XP/ProgressBar
@onready var sfx_fireworks:AudioStreamPlayer = $VBoxContainer/XP/ProgressBar/SFXfireworks
@onready var fireworks_timer:Timer = $VBoxContainer/XP/ProgressBar/FireworksTimer
@onready var fire_particles_one:GPUParticles2D = $VBoxContainer/XP/ProgressBar/Fire1/GPUParticles2D
@onready var fire_particles_two:GPUParticles2D = $VBoxContainer/XP/ProgressBar/Fire2/GPUParticles2D
@onready var xp_label:Label = $VBoxContainer/XP/HBoxContainer/XPlabel
@onready var level_label:Label = $VBoxContainer/XP/HBoxContainer/LevelLabel

@onready var restore_button:Button = $VBoxContainer/GridContainer/ResetUndoButton
@onready var reset_button:Button = $VBoxContainer/GridContainer/ResetButton
@onready var settings_button:Button = $VBoxContainer/GridContainer/SettingsButton

func _ready() -> void:
	if _verify_file() == false:
		push_warning(WARN)
		stats = StatsDataRC.new()
		write_savefile()
	else: stats = _load_savefile()

	fireworks_timer.timeout.connect(_stop_fireworks); _stop_fireworks()
	_connect_signals()

	_load_experience_progress()
	_update_progress()

func _load_experience_progress() -> void:
	xp_next = 2 * BASE_XP
	progress.max_value = xp_next
	for i in range(1,stats.level+1):
		xp_next += round(BASE_XP * i / 10.0) * 10
		progress.max_value = round(BASE_XP * stats.level / 10.0) * 10
	progress.value = stats.xp - (xp_next - progress.max_value)

func _start_fireworks() -> void:
	if stats.sound == true and stats.fireworks_sound == true:
		var base_db:float = -8.0
		sfx_fireworks.volume_db = base_db + stats.sound_addend + stats.fireworks_sound_addend
		sfx_fireworks.play()
	if stats.fireworks == true:
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
		_start_fireworks()
	_update_progress()

func _update_progress() -> void:
	xp_label.text = "XP %d / %d" % [stats.xp,xp_next]
	level_label.text = "%s dev - Lvl %d" % [stats.rank,stats.level]

func _connect_signals() -> void:
	settings_button.pressed.connect(func() -> void:
		settings_button.disabled = true
		var window:Resource = load("res://addons/ridiculous_coding/resources/interfaces/settings_window.tscn")
		var window_instance:RcWindow = window.instantiate()
		window_instance.stats = stats
		window_instance.position = DisplayServer.screen_get_size() / 2 - window_instance.size / 2
		DisplayServer.set_native_icon("res://addons/ridiculous_coding/icon_small.ico")
		add_child(window_instance,false,Node.INTERNAL_MODE_FRONT)
		window_instance.tree_exiting.connect(func() -> void:
			var settings_window:Window = get_child(0,true)
			stats = settings_window.stats
			settings_button.disabled = false
		)
	)
	restore_button.pressed.connect(func() -> void:
		if backup_level == 0: return
		stats.xp = backup_xp
		stats.level = backup_level
		stats.rank = backup_rank
		_load_experience_progress()
		_update_progress()
	)
	reset_button.pressed.connect(func() -> void:
		backup_xp = stats.xp
		backup_level = stats.level
		backup_rank = stats.rank

		xp_next = 2 * BASE_XP
		progress.value = 0
		progress.max_value = xp_next
		var default_stats = StatsDataRC.new()
		stats.xp = default_stats.xp
		stats.level = default_stats.level
		stats.rank = default_stats.rank
		_update_progress()
	)

func write_savefile() -> void:
	ResourceSaver.save(stats,ROOT_PATH+FILE_NAME,0)

func _load_savefile() -> Resource:
	return ResourceLoader.load(ROOT_PATH+FILE_NAME,"",0)

func _verify_file() -> bool:
	if DirAccess.open(ROOT_PATH).file_exists(FILE_NAME) == true: return true
	else: return false
