tool
extends EditorPlugin

var shake = 0.0
var shake_intensity = 0.0
var timer = 0.0
var last_key = ""
var pitch_increase := 0.0
var editors = {}
const PITCH_DECREMENT := 2.0

const Boom = preload("boom.tscn")
const Blip = preload("blip.tscn")
const Newline = preload("newline.tscn")

const Dock = preload("res://addons/ridiculous_coding/dock.tscn")
var dock

signal typing


func _enter_tree():
	var editor = get_editor_interface()
	var script_editor = editor.get_script_editor()
	script_editor.connect("editor_script_changed", self, "editor_script_changed")

	# Add the main panel
	dock = Dock.instance()
	connect("typing", dock, "_on_typing")
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
			editors[child] = { "text": child.text, "line": child.cursor_get_line() }
			
			if child.is_connected("cursor_changed", self, "cursor_changed"):
				child.disconnect("cursor_changed", self, "cursor_changed")
			child.connect("cursor_changed", self, "cursor_changed", [child])
				
			if child.is_connected("text_changed", self, "text_changed"):
				child.disconnect("text_changed", self, "text_changed")
			child.connect("text_changed", self, "text_changed", [child])

			if child.is_connected("gui_input", self, "gui_input"):
				child.disconnect("gui_input", self, "gui_input")
			child.connect("gui_input", self, "gui_input")


func gui_input(event):
	# Get last key typed
	if event is InputEventKey and event.pressed:
		event = event as InputEventKey
		last_key = OS.get_scancode_string(event.get_scancode_with_modifiers())
		

func editor_script_changed(script):
	var editor = get_editor_interface()
	var script_editor = editor.get_script_editor()
	
	editors.clear()
	get_all_text_editors(script_editor)


func _process(delta):
	var editor = get_editor_interface()
	
	if shake > 0:
		shake -= delta
		editor.get_base_control().rect_position = Vector2(rand_range(-shake_intensity,shake_intensity), rand_range(-shake_intensity,shake_intensity))
	else:
		editor.get_base_control().rect_position = Vector2.ZERO

	timer += delta
	if (pitch_increase > 0.0):
		pitch_increase -= delta * PITCH_DECREMENT


func shake(duration, intensity):
	if shake > 0:
		return
		
	shake = duration
	shake_intensity = intensity
	
	
func cursor_changed(textedit):
	var editor = get_editor_interface()
	
	if not editors.has(textedit):
		# For some reason the editor instances all change
		# when the file is saved so you need to reload them
		editors.clear()
		get_all_text_editors(editor.get_script_editor())
		
	editors[textedit]["line"] = textedit.cursor_get_line()


func text_changed(textedit : TextEdit):
	var editor = get_editor_interface()
	var settings = editor.get_editor_settings()
	
	if not editors.has(textedit):
		# For some reason the editor instances all change
		# when the file is saved so you need to reload them
		editors.clear()
		get_all_text_editors(editor.get_script_editor())
	
	# Get line and character count
	var line = textedit.cursor_get_line()
	var column = textedit.cursor_get_column()
	
	# Compensate for code folding
	var folding_adjustment = 0
	for i in range(textedit.get_line_count()):
		if i > line:
			break
		if textedit.is_line_hidden(i):
			folding_adjustment += 1

	# Compensate for tab size
	var tab_size = settings.get_setting("text_editor/indent/size")
	var line_text = textedit.get_line(line).substr(0,column)
	column += line_text.count("\t") * (tab_size - 1)

	# Compensate for scroll
	var vscroll = textedit.scroll_vertical
	var hscroll = textedit.scroll_horizontal
	
	# When you are scrolled to the bottom of a file
	# and you delete some lines from the bottom using Ctrl+X
	# then the vscroll can go down without changing the visible
	# scroll position. That throws off the calculation because
	# we're calculating the position from the lower position but
	# visually the position hasn't moved. By setting vscroll
	# to the new actual position, the editor moves the visible
	# lines to remove the gap. It changes the editor behavior
	# slightly for a better result.
	textedit.scroll_vertical = vscroll
	
	# Compensate for line spacing
	var line_spacing = settings.get_setting("text_editor/theme/line_spacing")
	
	# Load editor font
	var font : DynamicFont = DynamicFont.new()
	font.font_data = load(settings.get_setting("interface/editor/code_font"))
	font.size = settings.get_setting("interface/editor/code_font_size")
	var fontsize = font.get_string_size(" ")
	
	# Compensate for editor scaling
	var scale = editor.get_editor_scale()

	# Compute gutter width in characters
	var line_count = textedit.get_line_count()
	var gutter = str(line_count).length() + 6
	
	# Compute caret position
	var pos = Vector2()
	pos.x = (gutter + column) * fontsize.x * scale - hscroll
	pos.y = (line - folding_adjustment - vscroll) * (fontsize.y + line_spacing - 2) + 16
	pos.y *= scale
	
	emit_signal("typing")
	
	if editors.has(textedit):
		# Deleting
		if timer > 0.1 and len(textedit.text) < len(editors[textedit]["text"]):
			timer = 0.0
			
			if dock.explosions:
				# Draw the thing
				var thing = Boom.instance()
				thing.position = pos
				thing.destroy = true
				if dock.chars: thing.last_key = last_key
				thing.sound = dock.sound
				textedit.add_child(thing)
				
				if dock.shake:
					# Shake
					shake(0.2, 10)

		# Typing
		if timer > 0.02 and len(textedit.text) >= len(editors[textedit]["text"]):
			timer = 0.0

			# Draw the thing
			var thing = Blip.instance()
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
				shake(0.05, 5)
			
		# Newline
		if textedit.cursor_get_line() != editors[textedit]["line"]:
			# Draw the thing
			var thing = Newline.instance()
			thing.position = pos
			thing.destroy = true
			thing.blips = dock.blips
			textedit.add_child(thing)
			
			if dock.shake:
				# Shake
				shake(0.05, 5)

	editors[textedit]["text"] = textedit.text
	editors[textedit]["line"] = textedit.cursor_get_line()
	
