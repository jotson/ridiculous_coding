@tool
extends Control

const BASE_XP: int = 50
const STATS_FILE: String = "user://ridiculous_xp.ini"

var explosions: bool = true
var blips: bool = true
var chars: bool = true
var shake: bool = true
var sound: bool = true
var fireworks: bool = true
var xp: int = 0
var xp_next: int = 2*BASE_XP
var level: int = 1
var stats: ConfigFile = ConfigFile.new()

@onready var explosion_checkbox: CheckButton = $VBoxContainer/GridContainer/explosionCheckbox
@onready var blip_checkbox: CheckButton = $VBoxContainer/GridContainer/blipCheckbox
@onready var chars_checkbox: CheckButton = $VBoxContainer/GridContainer/charsCheckbox
@onready var shake_checkbox: CheckButton = $VBoxContainer/GridContainer/shakeCheckbox
@onready var sound_checkbox: CheckButton = $VBoxContainer/GridContainer/soundCheckbox
@onready var fireworks_checkbox: CheckButton = $VBoxContainer/GridContainer/fireworksCheckbox
@onready var progress: TextureProgressBar = $VBoxContainer/XP/ProgressBar
@onready var sfx_fireworks: AudioStreamPlayer = $VBoxContainer/XP/ProgressBar/sfxFireworks
@onready var fireworks_timer: Timer = $VBoxContainer/XP/ProgressBar/fireworksTimer
@onready var fire_particles_one: GPUParticles2D = $VBoxContainer/XP/ProgressBar/fire1/GPUParticles2D
@onready var fire_particles_two: GPUParticles2D = $VBoxContainer/XP/ProgressBar/fire2/GPUParticles2D
@onready var xp_label: Label = $VBoxContainer/XP/HBoxContainer/xpLabel
@onready var level_label: Label = $VBoxContainer/XP/HBoxContainer/levelLabel
@onready var reset_button: Button = $VBoxContainer/CenterContainer/resetButton


func _ready():
	reset_button.pressed.connect(on_reset_button_pressed)
	
	load_checkbox_state()
	connect_checkboxes()
	fireworks_timer.timeout.connect(stop_fireworks)
	load_experience_progress()
	update_progress()
	stop_fireworks()


func load_experience_progress():
	if stats.load(STATS_FILE) == OK:
		level = stats.get_value("xp", "level", 1)
		xp = stats.get_value("xp", "xp", 0)
	else:
		level = 1
		xp = 0
	
	xp_next = 2*BASE_XP
	progress.max_value = xp_next
	
	for i in range(2,level+1):
		xp_next += round(BASE_XP * i / 10.0) * 10
		progress.max_value = round(BASE_XP * level / 10.0) * 10
	
	progress.value = xp - (xp_next - progress.max_value)


func save_experioence_progress():
	stats.set_value("xp", "level", level)
	stats.set_value("xp", "xp", xp)
	stats.save(STATS_FILE)


func _on_typing():
	xp += 1
	progress.value += 1
	
	if progress.value >= progress.max_value:
		level += 1
		xp_next = xp + round(BASE_XP * level / 10.0) * 10
		progress.value = 0
		progress.max_value = xp_next - xp
		
		if fireworks: 
			start_fireworks()
	
	save_experioence_progress()
	update_progress()


func start_fireworks():
	sfx_fireworks.play()
	fireworks_timer.start()
	
	fire_particles_one.emitting = true
	fire_particles_two.emitting = true


func stop_fireworks():
	fire_particles_one.emitting = false
	fire_particles_two.emitting = false


func update_progress():
	xp_label.text = "XP: %d / %d" % [ xp, xp_next ]
	level_label.text = "Level: %d" % level


func connect_checkboxes():
	explosion_checkbox.toggled.connect(func(toggled): 
		explosions = toggled
		save_checkbox_state()
	)
	
	blip_checkbox.toggled.connect(func(toggled): 
		blips = toggled
		save_checkbox_state()
	)
	
	chars_checkbox.toggled.connect(func(toggled): 
		chars = toggled
		save_checkbox_state()
	)
	
	shake_checkbox.toggled.connect(func(toggled): 
		shake = toggled
		save_checkbox_state()
	)
	
	sound_checkbox.toggled.connect(func(toggled): 
		sound = toggled
		save_checkbox_state()
	)
	
	fireworks_checkbox.toggled.connect(func(toggled): 
		fireworks = toggled
		save_checkbox_state()
	)


func save_checkbox_state():
	stats.set_value("settings", "explosion", explosions)
	stats.set_value("settings", "blips", blips)
	stats.set_value("settings", "chars", chars)
	stats.set_value("settings", "shake", shake)
	stats.set_value("settings", "sound", sound)
	stats.set_value("settings", "fireworks", fireworks)
	stats.save(STATS_FILE)


func load_checkbox_state():
	if stats.load(STATS_FILE) == OK:
		explosion_checkbox.button_pressed = stats.get_value("settings", "explosion", true)
		blip_checkbox.button_pressed = stats.get_value("settings", "blips", true)
		chars_checkbox.button_pressed = stats.get_value("settings", "chars", true)
		shake_checkbox.button_pressed = stats.get_value("settings", "shake", true)
		sound_checkbox.button_pressed = stats.get_value("settings", "sound", true)
		fireworks_checkbox.button_pressed = stats.get_value("settings", "fireworks", true)
	else:
		explosion_checkbox.button_pressed = explosions
		blip_checkbox.button_pressed = blips
		chars_checkbox.button_pressed = chars
		shake_checkbox.button_pressed = shake
		sound_checkbox.button_pressed = sound
		fireworks_checkbox.button_pressed = fireworks


func on_reset_button_pressed():
	level = 1
	xp = 0
	xp_next = 2*BASE_XP
	progress.value = 0
	progress.max_value = xp_next
	update_progress()
