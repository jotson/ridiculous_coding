@tool
extends EditorPlugin

signal typing

# Scenes preloaded
const BOOM:Resource = preload("res://addons/ridiculous_coding/boom.tscn")
const BLIP:Resource = preload("res://addons/ridiculous_coding/blip.tscn")
const NEWLINE:Resource = preload("res://addons/ridiculous_coding/newline.tscn")
const DOCK:Resource = preload("res://addons/ridiculous_coding/dock.tscn")

# Inner Variables
const PITCH_DECREMENT:float = 2.0
var pitch_increase:float = 0.0

var timer:float = 0.0
var shake_duration:float = 0.0
var shake_intensity:float  = 0.0
var last_key:String = ""
var editors := {}
var dock:Dock

func _enter_tree():
	var editor:EditorInterface = get_editor_interface()
	var script_editor:ScriptEditor = editor.get_script_editor()
	script_editor.editor_script_changed.connect(editor_script_changed)
	dock = DOCK.instantiate()
	typing.connect(Callable(dock,"_on_typing"))
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)

func _exit_tree():
	if dock:
		remove_control_from_docks(dock)
		dock.free()

func get_all_text_editors(parent : Node):
	for child in parent.get_children():
		if child.get_child_count():
			get_all_text_editors(child)

		if child is TextEdit:
			editors[child] = {
				"text": child.text,
				"line": child.get_caret_line(),
			}
			_reconnect_signal(child.caret_changed,caret_changed,caret_changed.bind(child))
			_reconnect_signal(child.text_changed,text_changed,text_changed.bind(child))
			_reconnect_signal(child.gui_input,gui_input,gui_input)

func _reconnect_signal(my_signal,connection,connect_to):
	if my_signal.is_connected(connection): my_signal.disconnect(connection)
	my_signal.connect(connect_to)

func gui_input(event):
	if event is InputEventKey and event.pressed:
		event = event as InputEventKey
		last_key = OS.get_keycode_string(event.get_keycode_with_modifiers())

func editor_script_changed(script):
	var editor := get_editor_interface()
	var script_editor := editor.get_script_editor()
	editors.clear()
	get_all_text_editors(script_editor)

func _process(delta):
	var editor := get_editor_interface()
	if shake_duration > 0:
		shake_duration -= delta
		var random_pos:float = randf_range(-shake_intensity,shake_intensity)
		editor.get_base_control().position = Vector2(random_pos,random_pos)
	else:
		editor.get_base_control().position = Vector2.ZERO
	timer += delta
	if (pitch_increase > 0.0): pitch_increase -= delta * PITCH_DECREMENT

func shake_screen(duration, intensity):
	if shake_duration > 0: return
	else:
		shake_duration = duration
		shake_intensity = intensity

func caret_changed(textedit):
	var editor := get_editor_interface()
	if not editors.has(textedit):
		editors.clear()
		get_all_text_editors(editor.get_script_editor())
	editors[textedit]["line"] = textedit.get_caret_line()

# Instanciate and add the defined scenes
func text_changed(textedit : TextEdit):
	var line_height:int = textedit.get_line_height()
	var pos:Vector2 = textedit.get_caret_draw_pos() + Vector2(0,-line_height/2.0)
	emit_signal("typing")
	if editors.has(textedit):
		# Deleting
		if timer > 0.1 and len(textedit.text) < len(editors[textedit]["text"]):
			timer = 0.0
			if dock.stats.explosions:
				# Draw the boom
				var boom:Boom = BOOM.instantiate()
				boom.position = pos
				boom.destroy = true
				if dock.stats.chars: boom.last_key = last_key
				boom.sound = dock.stats.sound
				textedit.add_child(boom)
				if dock.stats.shake: shake_screen(0.2, 10)
		# Typing
		if timer > 0.02 and len(textedit.text) >= len(editors[textedit]["text"]):
			timer = 0.0
			# Draw the blip
			var blip:Blip = BLIP.instantiate()
			blip.pitch_increase = pitch_increase
			pitch_increase += 1.0
			blip.position = pos
			blip.destroy = true
			blip.blips = dock.stats.blips
			if dock.stats.chars: blip.last_key = last_key
			blip.sound = dock.stats.sound
			textedit.add_child(blip)
			if dock.stats.shake: shake_screen(0.05, 5)
		# Newline
		if textedit.get_caret_line() != editors[textedit]["line"]:
			# Draw the newline
			var newline:Newline = NEWLINE.instantiate()
			newline.position = pos
			newline.destroy = true
			newline.blips = dock.stats.blips
			textedit.add_child(newline)
			if dock.stats.shake: shake_screen(0.05, 5)
	else: pass
	editors[textedit]["text"] = textedit.text
	editors[textedit]["line"] = textedit.get_caret_line()
