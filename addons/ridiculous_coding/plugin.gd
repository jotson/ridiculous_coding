@tool
extends EditorPlugin

signal typing

#region Preloaded Resources
const NEWLINE:Resource = preload("res://addons/ridiculous_coding/resources/effects/newline.tscn")
const BOOM:Resource = preload("res://addons/ridiculous_coding/resources/effects/boom.tscn")
const BLIP:Resource = preload("res://addons/ridiculous_coding/resources/effects/blip.tscn")
const DOCK:Resource = preload("res://addons/ridiculous_coding/resources/interfaces/dock.tscn")
#endregion
#region Variables
var pitch_decrement:float = 2.7
var pitch_clamp:float = 25.5
var pitch_increase:float = 0.0

var shake_duration:float = 0.0
var shake_intensity:float  = 0.0

var timer:float = 0.0
var last_key:String = ""
var editors := {}
var dock:RidiculousCodingDock
#endregion

func _enter_tree() -> void:
	var editor:EditorInterface = get_editor_interface()
	var script_editor:ScriptEditor = editor.get_script_editor()
	script_editor.editor_script_changed.connect(_editor_script_changed)
	dock = DOCK.instantiate()
	typing.connect(Callable(dock,"_on_typing"))
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)

func _exit_tree() -> void:
	if dock:
		dock.write_savefile()
		remove_control_from_docks(dock)
		dock.queue_free()

func _get_all_text_editors(parent:Node) -> void:
	for child in parent.get_children():
		if child.get_child_count():
			_get_all_text_editors(child)
		if child is TextEdit:
			editors[child] = {
				"text" : child.text,
				"line" : child.get_caret_line(),
			}
			_reconnect_signal(child.caret_changed,_caret_changed,_caret_changed.bind(child))
			_reconnect_signal(child.text_changed,_text_changed,_text_changed.bind(child))
			_reconnect_signal(child.gui_input,_gui_input,_gui_input)

func _reconnect_signal(my_signal,connection,connect_to) -> void:
	if my_signal.is_connected(connection): my_signal.disconnect(connection)
	my_signal.connect(connect_to)

func _gui_input(event) -> void:
	if event is InputEventKey and event.pressed:
		event = event as InputEventKey
		last_key = OS.get_keycode_string(event.get_keycode_with_modifiers())

func _editor_script_changed(_script) -> void:
	var editor := get_editor_interface()
	var script_editor := editor.get_script_editor()
	editors.clear()
	_get_all_text_editors(script_editor)

func _process(delta:float) -> void:
	var editor := get_editor_interface()
	if dock.stats.shake == true:
		if shake_duration > 0:
			shake_duration -= delta
			var random_pos:float = randf_range(-shake_intensity,shake_intensity)
			editor.get_base_control().position = Vector2(random_pos,random_pos)
		else:
			editor.get_base_control().position = Vector2.ZERO
	timer += delta
	if dock.stats.blips_sound_pitch == true:
		if (pitch_increase > 0.0):
			if (pitch_increase > pitch_clamp): pitch_increase = pitch_clamp - 0.1
			pitch_increase -= delta * pitch_decrement

func _shake_screen(duration:float,intensity:float,unqiue_scalar:float) -> void:
	if shake_duration > 0: return
	else: pass
	shake_duration = duration
	var final_scalar:float = dock.stats.shake_scalar * unqiue_scalar
	shake_intensity = intensity * final_scalar

func _caret_changed(textedit) -> void:
	var editor := get_editor_interface()
	if not editors.has(textedit):
		editors.clear()
		_get_all_text_editors(editor.get_script_editor())
	editors[textedit]["line"] = textedit.get_caret_line()

# Instanciate and add the defined scenes
func _text_changed(textedit : TextEdit) -> void:
	var line_height:int = textedit.get_line_height()
	var pos:Vector2 = textedit.get_caret_draw_pos() + Vector2(0,(line_height*-1)/2.0)
	emit_signal("typing")
	if editors.has(textedit):

		# TODO: Make the scenes more modular
		# Deleting
		if timer > 0.1 and len(textedit.text) < len(editors[textedit]["text"]):
			timer = 0.0
			# Draw the boom
			var boom:Boom = BOOM.instantiate()
			boom.position = pos
			boom.destroy = true
			boom.explosions = dock.stats.explosions
			if dock.stats.chars == true and dock.stats.explosions_chars == true:
				boom.last_key = last_key
			if dock.stats.sound == true and dock.stats.explosions_sound == true:
				boom.sound = true
				boom.sound_addend = dock.stats.sound_addend + dock.stats.explosions_sound_addend
			textedit.add_child(boom)
			if dock.stats.shake == true and dock.stats.explosions_shake == true:
				_shake_screen(0.2,10,dock.stats.explosions_shake_scalar)

		# Typing
		if timer > 0.02 and len(textedit.text) >= len(editors[textedit]["text"]):
			timer = 0.0
			# Draw the blip
			var blip:Blip = BLIP.instantiate()
			blip.position = pos
			blip.destroy = true
			blip.blips = dock.stats.blips
			if dock.stats.chars == true and dock.stats.blips_chars == true:
				blip.last_key = last_key
			if dock.stats.sound == true and dock.stats.blips_sound == true:
				blip.sound = true
				blip.sound_addend = dock.stats.sound_addend + dock.stats.blips_sound_addend
				match dock.stats.blips_sound_selected:
					0: blip.sound_selected = load("res://addons/ridiculous_coding/sounds/typing/typewriter.wav")
					1: blip.sound_selected = load("res://addons/ridiculous_coding/sounds/typing/blip.wav")
				if dock.stats.blips_sound_pitch == true:
					blip.pitch_increase = pitch_increase
					pitch_increase += 0.88
			textedit.add_child(blip)
			if dock.stats.shake == true and dock.stats.blips_shake == true:
				_shake_screen(0.05,5,dock.stats.blips_shake_scalar)

		# Newline
		if textedit.get_caret_line() != editors[textedit]["line"]:
			# Draw the newline
			if dock.stats.newline == true:
				var newline:Newline = NEWLINE.instantiate()
				newline.position = pos
				newline.destroy = true
				newline.newline = dock.stats.newline
				textedit.add_child(newline)
			if dock.stats.shake == true and dock.stats.newline_shake == true:
				_shake_screen(0.05,5,dock.stats.newline_shake_scalar)
	else: pass
	editors[textedit]["text"] = textedit.text
	editors[textedit]["line"] = textedit.get_caret_line()
