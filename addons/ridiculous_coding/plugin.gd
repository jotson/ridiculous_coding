@tool
extends EditorPlugin

signal typing

# Scenes preloaded
const Boom: PackedScene = preload("res://addons/ridiculous_coding/boom.tscn")
const Blip: PackedScene = preload("res://addons/ridiculous_coding/blip.tscn")
const Newline: PackedScene = preload("res://addons/ridiculous_coding/newline.tscn")
const Dock: PackedScene = preload("res://addons/ridiculous_coding/dock.tscn")

# Inner Variables
const PITCH_DECREMENT := 2.0

var shake: float = 0.0
var shake_intensity:float  = 0.0
var timer: float = 0.0
var last_key: String = ""
var pitch_increase: float = 0.0
var editors = {}
var dock


func _enter_tree():
	var editor: EditorInterface = get_editor_interface()
	var script_editor: ScriptEditor = editor.get_script_editor()
	script_editor.editor_script_changed.connect(editor_script_changed)

	# Add the main panel
	dock = Dock.instantiate()
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
				"line": child.get_caret_line() 
			}
			
			if child.caret_changed.is_connected(caret_changed):
				child.caret_changed.disconnect(caret_changed)
			child.caret_changed.connect(caret_changed.bind(child))
			
			if child.text_changed.is_connected(text_changed):
				child.text_changed.disconnect(text_changed)
			child.text_changed.connect(text_changed.bind(child))
			
			if child.gui_input.is_connected(gui_input):
				child.gui_input.disconnect(gui_input)
			child.gui_input.connect(gui_input)


func gui_input(event):
	# Get last key typed
	if event is InputEventKey and event.pressed:
		event = event as InputEventKey
		last_key = OS.get_keycode_string(event.get_keycode_with_modifiers())


func editor_script_changed(script):
	var editor = get_editor_interface()
	var script_editor = editor.get_script_editor()
	
	editors.clear()
	get_all_text_editors(script_editor)


func _process(delta):
	var editor = get_editor_interface()
	
	if shake > 0:
		shake -= delta
		editor.get_base_control().position = Vector2(randf_range(-shake_intensity,shake_intensity), randf_range(-shake_intensity,shake_intensity))
	else:
		editor.get_base_control().position = Vector2.ZERO
	
	timer += delta
	if (pitch_increase > 0.0):
		pitch_increase -= delta * PITCH_DECREMENT


func shake_screen(duration, intensity):
	if shake > 0:
		return
		
	shake = duration
	shake_intensity = intensity


func caret_changed(textedit):
	var editor = get_editor_interface()
	
	if not editors.has(textedit):
		# For some reason the editor instances all change
		# when the file is saved so you need to reload them
		editors.clear()
		get_all_text_editors(editor.get_script_editor())
		
	editors[textedit]["line"] = textedit.get_caret_line()


func text_changed(textedit : TextEdit):
	var line_height = textedit.get_line_height()
	var pos = textedit.get_caret_draw_pos() + Vector2(0,-line_height/2.0)
	emit_signal("typing")
	
	if editors.has(textedit):
		# Deleting
		if timer > 0.1 and len(textedit.text) < len(editors[textedit]["text"]):
			timer = 0.0
			
			if dock.explosions:
				# Draw the thing
				var thing = Boom.instantiate()
				thing.position = pos
				thing.destroy = true
				if dock.chars: thing.last_key = last_key
				thing.sound = dock.sound
				textedit.add_child(thing)
				
				if dock.shake:
					# Shake
					shake_screen(0.2, 10)
		
		# Typing
		if timer > 0.02 and len(textedit.text) >= len(editors[textedit]["text"]):
			timer = 0.0
			
			# Draw the thing
			var thing = Blip.instantiate()
			thing.pitch_increase = pitch_increase
			pitch_increase += 1.0
			thing.position = pos
			thing.destroy = true
			thing.blips = dock.blips
			if dock.chars: thing.last_key = last_key
			thing.sound = dock.sound
			textedit.add_child(thing)
			
			if dock.shake:
				# Shake
				shake_screen(0.05, 5)
			
		# Newline
		if textedit.get_caret_line() != editors[textedit]["line"]:
			# Draw the thing
			var thing = Newline.instantiate()
			thing.position = pos
			thing.destroy = true
			thing.blips = dock.blips
			textedit.add_child(thing)
			
			if dock.shake:
				# Shake
				shake_screen(0.05, 5)
	
	editors[textedit]["text"] = textedit.text
	editors[textedit]["line"] = textedit.get_caret_line()
