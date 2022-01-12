tool
extends Control

var explosions = true
var blips = true
var chars = true
var shake = true
var sound = true
var fireworks = true

const BASE_XP = 50
var xp : int = 0
var xp_next : int = 2*BASE_XP
var level : int = 1
var stats : ConfigFile = ConfigFile.new()
const STATS_FILE = "user://ridiculous_xp.ini"


func _ready():
	$VBoxContainer/GridContainer/explosionCheckbox.pressed = explosions
	$VBoxContainer/GridContainer/blipCheckbox.pressed = blips
	$VBoxContainer/GridContainer/charsCheckbox.pressed = chars
	$VBoxContainer/GridContainer/shakeCheckbox.pressed = shake
	$VBoxContainer/GridContainer/soundCheckbox.pressed = sound
	$VBoxContainer/GridContainer/fireworksCheckbox.pressed = fireworks

	# Load saved XP and level
	if stats.load(STATS_FILE) == OK:
		level = stats.get_value("xp", "level", 1)
		xp = stats.get_value("xp", "xp", 0)
	else:
		level = 1
		xp = 0
	var progress : TextureProgress = $VBoxContainer/XP/ProgressBar
	xp_next = 2*BASE_XP
	progress.max_value = xp_next
	for i in range(2,level+1):
		xp_next += round(BASE_XP * i / 10.0) * 10
		progress.max_value = round(BASE_XP * level / 10.0) * 10
	progress.value = xp - (xp_next - progress.max_value)

	update_progress()
	stop_fireworks()
	

func _on_typing():
	var progress : TextureProgress = $VBoxContainer/XP/ProgressBar
	
	xp += 1
	progress.value += 1
	
	if progress.value >= progress.max_value:
		level += 1
		xp_next = xp + round(BASE_XP * level / 10.0) * 10
		progress.value = 0
		progress.max_value = xp_next - xp
		
		if fireworks: start_fireworks()
	
	# Save settings	
	stats.set_value("xp", "level", level)
	stats.set_value("xp", "xp", xp)
	stats.save(STATS_FILE)
	
	update_progress()


func start_fireworks():
	$VBoxContainer/XP/ProgressBar/sfxFireworks.play()
	$VBoxContainer/XP/ProgressBar/fireworksTimer.start()
	
	$VBoxContainer/XP/ProgressBar/fire1/Particles2D.emitting = true
	$VBoxContainer/XP/ProgressBar/fire2/Particles2D.emitting = true


func stop_fireworks():
	$VBoxContainer/XP/ProgressBar/fire1/Particles2D.emitting = false
	$VBoxContainer/XP/ProgressBar/fire2/Particles2D.emitting = false

	
func update_progress():
	var xpLabel := $VBoxContainer/XP/HBoxContainer/xpLabel
	xpLabel.text = "XP: %d / %d" % [ xp, xp_next ]
	
	var levelLabel := $VBoxContainer/XP/HBoxContainer/levelLabel
	levelLabel.text = "Level: %d" % level
	

func _on_explosionCheckbox_toggled(button_pressed):
	explosions = button_pressed


func _on_blipCheckbox_toggled(button_pressed):
	blips = button_pressed


func _on_shakeCheckbox_toggled(button_pressed):
	shake = button_pressed


func _on_charsCheckbox_toggled(button_pressed):
	chars = button_pressed


func _on_soundCheckbox_toggled(button_pressed):
	sound = button_pressed


func _on_fireworksCheckbox_toggled(button_pressed):
	fireworks = button_pressed


func _on_resetButton_pressed():
	var progress = $VBoxContainer/XP/ProgressBar
	level = 1
	xp = 0
	xp_next = 2*BASE_XP
	progress.value = 0
	progress.max_value = xp_next
	update_progress()
