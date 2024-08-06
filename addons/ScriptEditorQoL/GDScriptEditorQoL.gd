@tool
class_name GDScriptQualityOfLife
extends EditorPlugin
# Did you know that this code documentation is done?
# Press F1 and search for GDScriptQualityOfLife (or click on the class_name above and press alt + F1)
# You can also click on global variables or method names and press alt + F1

## GDScript Quality of Life (or GDSQoL) brings to you more quality of life and
## speed while programming in Godot.[br][br]
## Here is a list of features from this plugin:[br]
## - [code]Type var_name = value[/code] to [code]var var_name: Type = value[/code][br]
## - [code]var_number++[/code] to [code]var_number += 1[/code] (also works with --)[br]
## - [code]var_number++ 2[/code] to [code]var_number += 2[/code] (also works with -- and any float)[br]
## - [code]var_bool![/code] to [code]var_bool = !var_bool[/code][br]
## - [code]class?[/code] to [code]if class:[/code][br]
## - [code]class?method()[/code] to [code]if class: class.method()[/code][br]
## - [code]method() cd[/code] to [code]method.call_deferred()[/code][br]
## - [code]my_var = value sd[/code] to [code]set_deferred("my_var", value)[/code][br]
## - [code]await 1[/code] to [code]await get_tree().create_timer(1).timeout[/code] (any float is valid)[br]
## - Declare multiple variables in the same line[br]
## - Auto correct indentation from pasted blocks to match the line above[br]
## - Auto replace set keywords to any line set by you at [code]Editor -> Editor Settings -> GDScript QoL -> Change To[/code][br]
## - Auto remove one indentation after [code]return[/code], [code]break[/code] and [code]continue[/code][br]
## - On delete line, auto remove remaining indentation from middle of the line
## - Auto add [code]:[/code] at the end of [code]if[/code] statements if they are not closed[br]
## - Auto find [code]if[/code] above to match indentation when write [code]else[/code] or [code]elif[/code][br]
## - Auto complete [code]match[/code] with enum list if any[br]
## - Auto complete methods if write [code]func method_name[/code][br]
## - Optionally you can write the method return type and/or parameters, like [code]func name(param) Type[/code][br]
## - Auto create method from selection when shortcut is pressed (default is [kbd]Ctrl + M[/kbd])[br]
## - Update the line when [kbd]Enter[/kbd] or the shortcut is pressed (default shortcut is [kbd]Ctrl + U[/kbd])[br]
## [br]You may change or disable some of these settings at [code]Editor -> Editor Settings -> GDScript QoL[/code]
## [br]To see what each setting does, please give a look at [member settings].[br]
## [br]This plugin saves its settings at [method EditorPaths.get_config_dir] path, with the name defined at [constant SAVE_FILE_NAME].[br]
## This way, the settings will be saved through any projects you have this plugin on.[br]
## [br]For a full tutorial, please visit the [url=https://github.com/Herbherth/GDScript-Quality-of-Life]github page[/url][br]
## If you like it, and wish to [url=https://herbherth.itch.io/gdscript-quality-of-life-plugin]buy me a piece of cake[/url]
## (I don't drink coffee), it would be greatly appreciated, thank you!
## @tutorial(GitHub): https://github.com/Herbherth/GDScript-Quality-of-Life
## @tutorial(Buy me a piece of cake - Donate): https://herbherth.itch.io/gdscript-quality-of-life-plugin

#region Variables
## [br][constant TYPES] from [enum Variant.Type]
## [br]Last version updated: [code]4.3.beta3[/code][br]
const TYPES: Array[String] = [
	"bool",
	"int",
	"float",
	"String",
	"Rect2",
	"Rect2i",
	"Vector2",
	"Vector2i",
	"Vector3",
	"Vector3i",
	"Vector4",
	"Vector4i",
	"Transform2D",
	"Transform3D",
	"Plane",
	"Quaternion",
	"AABB",
	"Basis",
	"Projection",
	"Color",
	"StringName",
	"NodePath",
	"RID",
	"Object",
	"Callable",
	"Signal",
	"Dictionary",
	"Array",
	"PackedByteArray",
	"PackedInt32Array",
	"PackedInt64Array",
	"PackedFloat32Array",
	"PackedFloat64Array",
	"PackedStringArray",
	"PackedVector2Array",
	"PackedVector3Array",
	"PackedColorArray",
	"PackedVector4Array",
	]

## [br]List of keywords to auto dedent (remove tab) on next line. [br]
const DEDENT_KEYWORDS: Array[String] = [
	"return",
	"break",
	"continue"
]

## [br]The scene called when [constant create_method_shortcut] is pressed.
## [br]It should not be changed.[br]
const CREATE_METHOD_POPUP: PackedScene = preload("res://addons/ScriptEditorQoL/create_method_popup.tscn")

## The name of the file that will store all settings from this plugin.
const SAVE_FILE_NAME: String = "GDSQoL_Settings.cfg"

## [br]Shortcut to auto create a method from selection.
## [br]The created method will be placed at the bottom of the code.
## [br]The shortcut can be changed at [code]Editor -> Editor Settings -> GDScript QoL[/code]
## [br]Default value: [kbd]ctrl + M[/kbd][br]
var create_method_shortcut: InputEventKey

## [br]Shortcut to update the line that the caret is current on, without pressing ENTER.
## [br]The shortcut can be changed at [code]Editor -> Editor Settings -> GDScript QoL[/code]
## [br]Default value: [kbd]ctrl + U[/kbd][br]
var update_line_shortcut: InputEventKey

## Change the [member settings] at [code]Editor -> Editor Settings -> GDScript QoL[/code]
## [br][br][param Function Variable Name]: The name of the variable that will be auto created when creating a method with return type.
## [br]Default value: [code]private_var[/code]
## [br][br][param Call Deferred Keyword]: The keyword used at the end of a line to change the called method to call_deferred.
## [br]Default value: [code]cd[/code]
## [br][br][param Set Deferred Keyword]: The keyword used at the end of a line to change the set variable to set_deferred.
## [br]Default value: [code]sd[/code]
## [br][br][param Auto Dedent After Return]: If it should auto dedent (remove one tab) after the keywords from [constant DEDENT_KEYWORDS].
## [br]Default value: [code]true[/code]
## [br][br][param Auto Remove Indent on Delete Line]: If it should remove the indentation from middle of line when a delete action joins two lines.
## [br]Default value: [code]true[/code]
## [br][br][param Create Method Shortcut]: The shortcut to create method from selection. The method created will be placed at the end of the code.
## [br]Default value: [kbd]ctrl + M[/kbd]
## [br][br][param Update Line Shortcut]: The shortcut to update the current line without pressing ENTER.
## [br]Default value: [kbd]ctrl + U[/kbd]
## [br][br][param Change To]: A dictionary of [b]STRING[/b] keys that when they are found as a line text, will auto change to respective values as String.
## [br]Default value: [code] "await f": "await get_tree().process_frame"[/code]
## [br]For now, it only accepts single line changes. To use multiline changes,
## I recommend give a look at [url=https://github.com/rainlizard/GDScriptMacros]GDScriptMacros[/url]  -  Not mine, btw[br]
var settings: Dictionary = {
	"gdscript_qol/function_variable_name": "private_var",
	"gdscript_qol/call_deferred_keyword": "cd",
	"gdscript_qol/set_deferred_keyword": "sd",
	"gdscript_qol/auto_dedent_after_return": true,
	"gdscript_qol/auto_remove_indent_on_delete_line": true,
	"gdscript_qol/create_method_shortcut": input_create_method(),
	"gdscript_qol/update_line_shortcut": input_update_line(),
	"gdscript_qol/change_to": {"await f": "await get_tree().process_frame"},
	}

## This is the current window code that is being edited.[br]
## It is updated every time you change the focused tab you are working on.
var current_code: CodeEdit
var current_script: Script ## The script that is currently being edited.
var editor_setting: EditorSettings ## Used to access the settings at [code]Editor -> Editor Settings -> GDScript QoL[/code]
var last_line: LastLineChanged ## All the last line info are stored at a custom class [GDScriptQualityOfLife.LastLineChanged]
var is_shortcut_pressed: bool = false ## If a shortcut is pressed, this bool is triggered until it finishes it's job, or else things might break with [method check_paste] logic.
var updated_by_code: bool = false ## If the code was changed by code and not by user, this will return [code]true[/code] and avoid the code to continue running.
#endregion


#region Setup
func _enter_tree() -> void:
	last_line = LastLineChanged.new()
	set_editor_settings()
	# It looks like a different script calls a different CodeEdit, so we need to recall it every time you change the script 
	EditorInterface.get_script_editor().editor_script_changed.connect(get_editor_code_edit)


func _exit_tree() -> void:
	remove_editor_settings()
	#If there is any code stored, free the signal
	if current_code:
		current_code.lines_edited_from.disconnect(self.changed_line)
		current_code = null


## Creates and return the default [InputEventKey] that will be used for [member create_method_shortcut][br]
## The default value is [kbd]Ctrl + M[/kbd] and can be changed at [code]Editor -> Editor Settings -> GDScript QoL[/code]
func input_create_method() -> InputEventKey:
	var cm: InputEventKey = InputEventKey.new()
	cm.keycode = KEY_M
	cm.ctrl_pressed = true
	return cm


## Creates and return the default [InputEventKey] that will be used for [member update_line_shortcut][br]
## The default value is [kbd]Ctrl + U[/kbd] and can be changed at [code]Editor -> Editor Settings -> GDScript QoL[/code]
func input_update_line() -> InputEventKey:
	var ul: InputEventKey = InputEventKey.new()
	ul.keycode = KEY_U
	ul.ctrl_pressed = true
	return ul


## Set all keys and values from [member settings] to [code]Editor -> Editor Settings -> GDScript QoL[/code]
## [br]This is done once, on startup or addon activation.[br]
## This also sets all settings values to what is saved in the file [constant SAVE_FILE_NAME]
## at path returned by [method EditorPaths.get_config_dir]
func set_editor_settings() -> void:
	var config = ConfigFile.new() # To load the settings
	var path: String = EditorInterface.get_editor_paths().get_config_dir() # Godot settings path
	path = "%s/%s" % [path, SAVE_FILE_NAME]
	var err: Error = config.load(path) # Try to load, if any
	
	editor_setting = EditorInterface.get_editor_settings()
	for s in settings.keys():
		var value
		if err == OK: # if there is save file, return the values
			value = config.get_value("setting", s, settings[s])
		else:
			value = settings[s] # if there isn't, use default values
		editor_setting.set_setting(s, value)
		editor_setting.set_initial_value(s, settings[s], false)
	
	create_method_shortcut = editor_setting.get_setting("gdscript_qol/create_method_shortcut")
	update_line_shortcut = editor_setting.get_setting("gdscript_qol/update_line_shortcut")


## Remove all keys from [member settings] at [code]Editor -> Editor Settings -> GDScript QoL[/code]
## [br]This is done once, on exit or addon deactivation.[br]
## This also saves all settings values to the file [constant SAVE_FILE_NAME]
## at path returned by [method EditorPaths.get_config_dir]
func remove_editor_settings() -> void:
	var config = ConfigFile.new() # To save the settings
	
	for s in settings.keys():
		var value = editor_setting.get_setting(s) # Get setting
		config.set_value("setting", s, value) # Prepare to save
		editor_setting.erase(s) # Remove setting
	
	var path: String = EditorInterface.get_editor_paths().get_config_dir()
	path = "%s/%s" % [path, SAVE_FILE_NAME]
	config.save(path) # Save it


## It gets the [CodeEdit] returned by [method ScriptEditorBase.get_base_editor], saves it to
## [member current_code], and connects [signal Control.focus_entered] and
## [signal Control.focus_exited] to know when the user is editing the script.[br]
## [br]It looks like each [Script] uses a different [CodeEdit], so it must be recalled every time
## the user changes the script with [signal ScriptEditor.editor_script_changed]. This signal
## returns a [Script] as parameter. We don't actually use it for nothing, but it
## needs to be passed as parameter.[br]
## [br]It also saves the current script that is being edited in [member current_script].
func get_editor_code_edit(_script: Script = null) -> void:
	if current_code: # If there is already a CodeEdit, disconnect the signals and get the new one
		if current_code.lines_edited_from.is_connected(changed_line):
			on_code_edit_exit()
		current_code.focus_entered.disconnect(on_code_edit_focus)
		current_code.focus_exited.disconnect(on_code_edit_exit)
	current_code = EditorInterface.get_script_editor().get_current_editor().get_base_editor()
	current_code.focus_entered.connect(on_code_edit_focus)
	current_code.focus_exited.connect(on_code_edit_exit)
	on_code_edit_focus()


## Called when user focus on code editor window.
func on_code_edit_focus() -> void:
	if current_script != null: return
	set_deferred("updated_by_code", false) # When editor is focused back, listen to it again
	current_code.lines_edited_from.connect(self.changed_line)
	current_script = EditorInterface.get_script_editor().get_current_script() # Get current script


## Called when user is not focused on code editor window.
func on_code_edit_exit() -> void:
	updated_by_code = true
	if current_code.lines_edited_from.is_connected(changed_line):
		current_code.lines_edited_from.disconnect(self.changed_line)
	current_script = null


func _notification(what):
	# When the ScriptEditor is floating, loses the focus when focusing the main engine
	if what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		if current_script: on_code_edit_exit()


## Called when [member current_code] emit [signal TextEdit.lines_edited_from]
## [br]If line is added or removed, proceed to code checks.
func changed_line(_from_line: int, _to_line: int) -> void:
	if updated_by_code: # If new line was added by this same code, skip checkings
		set_deferred("updated_by_code",  false)
		return
	
	# It only does the logic if new line is inserted (ENTER pressed).
	if _from_line < _to_line:
		current_code.begin_complex_operation() # Treat everything as a single operation
		check_line(_from_line, _to_line)
		current_code.end_complex_operation.call_deferred()
		return
	
	# If deleted line
	if _to_line < _from_line and deleted_line_action_pressed():
		remove_indent_on_delete.call_deferred(_to_line, _from_line)
#endregion


#region Checks
func _shortcut_input(event: InputEvent) -> void:
	if not current_script: return # If there is no current_script, no shortcut should be called
	# Only proceed if event is just pressed (not holding) and it is in a valid current code.
	if not event.is_pressed() or event.is_echo() or not current_code: return
	if event.is_match(create_method_shortcut):
		shortcut_detected(create_method)
		return
	
	if event.is_match(update_line_shortcut):
		shortcut_detected(update_line)
		return


## This is the main method of this addon.[br]
## It will check the last line modified to see if it needs any adjustments.[br]
## Once one adjustment is done, the code will stop running (it will not adjust two things at once).[br]
## If the last line modified ended with [code]:[/code] it will be considered a complete line that the user doesn't want to change.
func check_line(line: int, new_line: int) -> void:
	# Store all line info (line number, text, indentation, first word)
	last_line.set_line(line, new_line, current_code)
	
	if check_paste(): return
	
	# If there is nothing in the line, or it is a comment, return
	if last_line.text.is_empty() or last_line.text.begins_with("#"): return
	
	if check_change_line_to(): return # Check if is in customizable user dictionary
	
	if last_line.text.strip_edges().ends_with(":"): return # Line is complete
	
	if check_first_word_endings(): return # Check if it matchs words ending with ++, --, !, ?, DEDENT_KEYWORDS or else/elif
	
	if check_call_method_if_not_null(): return # Check for class?.method()
	
	if check_call_def_set_def_keyword(): return # Check for call_deferred and set_deferred keyword at end
	
	# If there is a parentheses attached to first word, remove it
	var first_word_without_p = last_line.first_word.substr(0,last_line.first_word.find("("))
	match(first_word_without_p):
		"func":
			check_functions()
			return
		"await":
			add_await_timer()
			return
		"match":
			check_match()
			return
	
	check_var() # If every check failed, check for var type


## Checks if a paste action was done to auto correct its intend level if needed
func check_paste() -> bool:
	# If ENTER was pressed or a block of text was pasted through shortcut, return
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER) or is_shortcut_pressed: return false
	# Check if there is multiple lines added (it means it was a paste action)
	# or if the new line added is not empty (also a paste)
	# Pasting in the same line will keep indentation
	if Input.is_action_pressed("ui_paste") or \
	last_line.new_line - last_line.line != 1 or \
	not current_code.get_line(last_line.line+1).strip_edges().is_empty():
		indent_paste_block()
		return true
	return false


## Check if text is what user customized at [code]Editor -> Editor Settings -> GDScript QoL -> Change To[/code][br]
## It should be a String key and a String value.
## [br]For now, it only accepts single line changes. To use multiline changes, I recommend give a look at
## [url=https://github.com/rainlizard/GDScriptMacros]GDScriptMacros[/url]  -  Not mine, btw
func check_change_line_to() -> bool:
	var change_to: Dictionary = editor_setting.get_setting("gdscript_qol/change_to")
	if not change_to.keys().has(last_line.text):
		return false
	
	var new_line: String = last_line.indent + str(change_to[last_line.text])
	current_code.set_line.call_deferred(last_line.line, new_line)
	return true


## Check for specific keys at the end of first word:[br]
## [code]MY_VAR++[/code] - Switch to [code]MY_VAR += 1[/code][br]
## It also works if you add a number at the end:[br]
## [code]MY_VAR++ 2[/code] - Switch to [code]MY_VAR += 2[/code][br]
## [br][code]MY_VAR--[/code] - Switch to [code]MY_VAR -= 1[/code][br]
## It also works if you add a number at the end:[br]
## [code]MY_VAR-- 2[/code] - Switch to [code]MY_VAR -= 2[/code][br]
## [br]If it is [code]if[/code] and forgot to add [code]:[/code] at the end, add it.[br]
## [br]If it is [code]else[/code] or [code]elif[/code] will auto retreat to if statement indent level and add [code]:[/code] at end.[br]
## [br]If it is any [constant DEDENT_KEYWORDS], will remove one tab from next line.[br]
## [br][code]MY_BOOLEAN![/code] - Switch to [code]MY_BOOLEAN != MY_BOOLEAN[/code][br]
## [br][code]MY_VAR?[/code] - Switch to [code]if MY_VAR:[/code]
func check_first_word_endings() -> bool:
	if last_line.first_word.ends_with("++"):
		change_double_sign("+")
		return true
	if last_line.first_word.ends_with("--"):
		change_double_sign("-")
		return true
	
	if finish_if_statement(): return true
	
	if auto_retreat_else_or_elif(): return true
	
	if dedent_next_line(): return true
	
	if not last_line.first_word == last_line.text: # From here, the line must be only one word
		return false
	
	if last_line.first_word.ends_with("!"):
		invert_bool()
		return true
	if last_line.first_word.ends_with("?"):
		check_null()
		return true
	return false


## Replace [code]CLASS_VAR?.METHOD()[/code] for [code]if CLASS_VAR: CLASS_VAR.METHOD()[/code]
func check_call_method_if_not_null() -> bool:
	if not "?." in last_line.first_word:
		return false
	
	var idx = last_line.first_word.find("?.") # Get the position of "?."
	var class_called: String = last_line.first_word.substr(0, idx) # The class name
	var method_called: String = last_line.text.substr(idx+1) # The method name
	var new_line = last_line.indent + "if %s: %s%s" % [class_called, class_called, method_called]
	current_code.set_line.call_deferred(last_line.line, new_line)
	return true


## It checks if the line ends with call_deferred or set_deferred keywords set at 
## [code]Editor -> Editor Settings -> GDScript QoL[/code]
func check_call_def_set_def_keyword() -> bool:
	# Get keywords
	var call_def_key := editor_setting.get_setting("gdscript_qol/call_deferred_keyword")
	var set_def_key := editor_setting.get_setting("gdscript_qol/set_deferred_keyword")
	
	var words: PackedStringArray = get_words(last_line.text)[0] # All words from first line
	if not words: return false # Nothing in the line
	
	match(words[-1]): # Check last word
		call_def_key:
			return change_call_def(words)
		set_def_key:
			return change_set_def(words)
	return false


## Auto complete [code]func METHOD_NAME[/code] to:
##[codeblock]
##func METHOD_NAME() -> void:
##    pass
##[/codeblock]
## It can also receive types and parameters, replacing [code]func METHOD_NAME(String MY_PARAM) String[/code] to:
##[codeblock]
##func METHOD_NAME(MY_PARAM: String) -> String:
##    var private_var: String
##    return private_var
##[/codeblock]
## The name of the [param private_var] can be changed at [code]Editor -> Editor Settings -> GDScript QoL[/code]
func check_functions() -> void:
	var words := get_words(last_line.text)[0] # Work only with the first phrase (no multi func declaration supported)
	
	var add_braces: String = ""
	if not words[1].contains("("): # words[0] is always "func"
		add_braces = "()"
	elif not words[1].contains("()"): # If it is not closed, it has parameters
		words[1] = adjust_func_parameter(words[1])
	
	var add_arrow = " -> "
	if words.has("->"): words.remove_at(words.find("->")) # Easier to remove and add again the arrow
	
	var func_type = "void" # If nothing, return_type will be void
	if is_in_type(words[-1]) or words[-1] == "void":
		func_type = words[-1]
		words.remove_at(words.size()-1) # If has return_type, remove it from list
	
	var new_line: String = " ".join(words)
	new_line = last_line.indent + new_line + add_braces + add_arrow + func_type + ":"
	current_code.set_line.call_deferred(last_line.line, new_line)
	
	add_func_return(func_type) # Add return line or pass if void


## Change [code]await 1[/code] for [code]await get_tree().create_timer(1).timeout[/code][br]
## Any float number can be used instead of 1.
func add_await_timer() -> void:
	var words := last_line.text.split(" ")
	if words.size() != 2 or not words[1].is_valid_float(): return # Just continue if it is "await + number"
	
	var new_line = last_line.indent + "await get_tree().create_timer(%s).timeout" % words[1]
	current_code.set_line.call_deferred(last_line.line, new_line)


## Check for the keyword [code]match[/code].[br]
## If there is a valid enum to list, it lists all keys automatically.[br]
## You must save between the enum creation and the match statement for the enum be recognizable.[br][br]
## Although you can use enums from extended classes, trying to use a built-in property of type from
## another enum will fail.[br]
## This means that you [b]CAN[/b] create a property from [enum Node.ProcessMode] and it will work
## as expected, but trying to use directly [member Node.process_mode] [b]WON'T[/b] auto complete.[br]
## This is a problem only for built-in classes. If you extended from another custom class, using
## a property enum from this will work fine.[br]
## One possible workaround is to create a method and pass the enum as parameter. This should
## autocomplete normally.[br][br] 
## [b]ATTENTION:[/b][br]Enums declared in inner classes, when you use [code]class[/code]
## keyword inside another class, are not supported for autocompletion. 
func check_match() -> void:
	var words := last_line.text.split(" ")
	var item_matched: String # The name that goes inside ()
	
	if "(" in words[0]: # If there is only one word (the name is inside)
		var begin: int = words[0].find("(")+1
		var end: int = words[0].rfind(")")
		var lenght: int = end - begin
		item_matched = words[0].substr(begin, lenght)
	elif words[1]: # If there is two words, the name is the second word
		item_matched = words[1]
	
	if item_matched.is_empty(): return # No name found = return
	
	var new_line: String = last_line.indent + "match(%s):" % item_matched # new match line
	var match_all_line: String = last_line.indent + "\t_:" # Last item (match rest)
	var pass_line: String = last_line.indent + "\t\tpass" # pass line
	current_code.set_line.call_deferred(last_line.line, new_line) # Set new match line
	
	var extra_lines: int = add_enum_list(item_matched, pass_line) # Autocomplete with enum list if any and return how many lines it was
	
	insert_line_at(last_line.line+extra_lines+1, match_all_line) # Last lines
	current_code.set_line.call_deferred(last_line.line+extra_lines+2, pass_line)
	set_caret(last_line.line+extra_lines+2) # Set caret at end


## Check if line starts with type instead of [code]var[/code], and/or if it is a multiline declarion.[br]
## In other words, it will replace this:
##[codeblock]
##int my_int = 0, my_second_int = 2
##[/codeblock]
## To this:
##[codeblock]
##var my_int: int = 0
##var my_second_int: int = 2
##[/codeblock]
## It also works if you don't declare a type, but use [code]var[/code] to declare multiline variables:
##[codeblock]
##var my_int = 0, my_bool = true
##[/codeblock]
## To:
##[codeblock]
##var my_int = 0
##var my_bool = true
##[/codeblock]
func check_var() -> void:
	var is_var: bool = false # Boolean to check if the line is even a var declaration
	var prefix_indent: String = last_line.indent # Add the indent used
	var words := get_words(last_line.text) # Make the line an array to make it easier to work
	var type: String = ""
	
	if last_line.first_word.begins_with("@export") or last_line.first_word == "export": #Checks if it is @export
		is_var = true
		last_line.first_word = words[0][0] # Some export types has parentheses and spaces. This will keep everything inside parenthesis together with first word
		if last_line.first_word == "export":
			last_line.first_word = "@export"
		prefix_indent += "%s " % last_line.first_word
		words[0].remove_at(0) # Remove export from array
	
	if words[0].is_empty(): return # Nothing else on the line
	
	if words[0][0] == "var": # If first word is "var"
		is_var = true
		words[0].remove_at(0) # Remove it from list
	
	if is_in_type(words[0][0]): # If first word is a type or build-in class
		is_var = true
		type = ": %s" % words[0][0] # Get type and remove it from array
		words[0].remove_at(0)
	
	if not is_var: return
	add_multiline_vars(prefix_indent, type, words) # Handle multiline vars
#endregion


#region Logic
## Change [code]++[/code] and [code]--[/code] into [code]+=[/code] and [code]-=[/code].[br]
## You can add custom float values after the double sign.
func change_double_sign(sign: String):
	var double_sign: String = sign.repeat(2)
	var replace: String = sign + "="
	
	var words := last_line.text.split(" ")
	var value_added: String
	if words.size() == 1: # if there is no value, will add 1
		value_added = " 1"
	elif words.size() == 2 and words[1].is_valid_float(): # there is a value, add it
		value_added = " " + words[1]
	else: return
	
	var new_line: String = last_line.indent + last_line.first_word.trim_suffix(double_sign) + " " + replace + value_added
	current_code.set_line.call_deferred(last_line.line, new_line)


## Change [code]BOOLEAN_NAME![/code] to [code]BOOLEAN_NAME = !BOOLEAN_NAME[/code]
func invert_bool() -> void:
	var boolean_name: String = last_line.first_word.trim_suffix("!")
	var new_line: String = last_line.indent + boolean_name + " = !" + boolean_name
	current_code.set_line.call_deferred(last_line.line, new_line)


## Change [code]CLASS?[/code] to [code]if CLASS:[/code]
func check_null() -> void:
	var new_line: String = last_line.indent + "if " + last_line.first_word.trim_suffix("?") + ":"
	current_code.set_line.call_deferred(last_line.line, new_line)
	add_line_if_shortcut(last_line.line+1, last_line.indent + "\t")
	set_caret(last_line.line+1)


## If the line is changed through [kbd]ENTER[/kbd], the line that were just created will be set.[br]
## If it was a shortcut input, a new line will be inserted.
func add_line_if_shortcut(line: int, text: String) -> void:
	if is_shortcut_pressed:
		insert_line_at(line, text)
		return
	current_code.set_line.call_deferred(line, text)


## Add all lines from variable declaration, spliting on commas
func add_multiline_vars(prefix: String, type: String, words: Array[PackedStringArray]) -> void:
	var new_line: String
	for phrases in words.size():
		var variable_name: String = words[phrases][0]
		words[phrases].remove_at(0)
		new_line = prefix + "var %s%s %s" % [variable_name, type, " ".join(words[phrases])]
		if phrases == 0: # First line modifies original, the rest is added bellow
			current_code.set_line.call_deferred(last_line.line, new_line)
			continue
		insert_line_at( last_line.line+phrases, new_line)
	
	set_caret.call_deferred(last_line.line+words.size()) # BUG


## Set caret at the end of given line (end is char 1000, hoping that no one will write a line this huge)
func set_caret(line: int) -> void:
	current_code.set_caret_line.call_deferred(line)
	current_code.set_caret_column.call_deferred(1000)


## Checks if [param type] is a valid class name or variant type.[br]
## It will check:[br]
## - Custom classes from [method ProjectSettings.get_global_class_list][br]
## - Custom ENUMS from [method Script.get_script_constant_map][br]
## - Godot built in ENUMS from [method ClassDB.class_get_enum_list][br]
## - Variant types from [constant TYPES][br]
## - Godot built in classes from [method @GDScript.type_exists]
func is_in_type(type: String) -> bool:
	for c in ProjectSettings.get_global_class_list(): # Get custom classes (from class_name)
		if type == c.class:
			return true
	
	if type.begins_with("Array[") and type.ends_with("]"): # Check if it is a typed array
		var subtype: String = type.trim_prefix("Array[").trim_suffix("]")
		return is_in_type(subtype) # Check if type from array is also valid
	
	# Check for enum types
	if type in current_script.get_script_constant_map(): return true
	if type in ClassDB.class_get_enum_list(current_script.get_instance_base_type()): return true
	
	return TYPES.has(type) or type_exists(type)


## Return an array of phrases (split by commas) where each array has a
## PackedStringArray with the words of the text split by spaces,
## keeping everything inside [code]""[/code], [code]''[/code], [code]()[/code], [code][][/code], [code]{}[/code] together
func get_words(text: String) -> Array[PackedStringArray]:
	var temp_text: String = text
	var inside_groups: Array[String] = get_inside_groups(temp_text) # Get what is inside "", '', (), [] or {}
	
	# Replace groups for a non spaced string to work with
	# Can't use replace, or it will replace all occurrences and can break another group
	for strings in inside_groups.size():
		var idx: int = temp_text.find(inside_groups[strings])
		var left_text: String = temp_text.left(idx)
		var right_text: String = temp_text.substr(idx + inside_groups[strings].length())
		temp_text = "%s=GDS_QOL_inside_group_removed_%s=%s" % [left_text, str(strings), right_text]
	
	var phrases := temp_text.split(",", false) # Split after commas
	var words: Array[PackedStringArray]
	
	for p in phrases.size():
		if phrases[p].strip_edges().is_empty(): continue # Remove white space and skip if it was only it
		words.append(phrases[p].split(" ", false)) # Split each word
	
	var idx = 0 # Now that we have divided into phrases and words, time to replace back the grouped strings
	for p in words.size(): # Iterate through phrases
		for w in words[p].size(): # Words
			while(words[p][w].contains("=GDS_QOL_inside_group_removed_%s=" % str(idx))):
				words[p][w] = words[p][w].replace("=GDS_QOL_inside_group_removed_%s=" % str(idx), inside_groups[idx])
				idx += 1
	
	return words


## Get the text that is inside [code]""[/code], [code]''[/code], [code]()[/code], [code][][/code], [code]{}[/code]
func get_inside_groups(text: String) -> Array[String]:
	var grouped_index: Array[int] = get_grouped_indexes(text) # The index of where a group starts and ends
	var inside_groups: Array[String]
	
	for i in range(0, grouped_index.size(), 2): # Iterate in steps of 2
		var begin: int = grouped_index[i] # First number is the beginnig index
		var lenght: int = grouped_index[i+1] - grouped_index[i] + 1 # Second is the ending index
		var sub_string = text.substr(begin, lenght)
		inside_groups.append(sub_string)
	
	return inside_groups


## Get the indexes of where in the line [code]""[/code], [code]''[/code],
## [code]()[/code], [code][][/code], [code]{}[/code] starts and ends
func get_grouped_indexes(text: String) -> Array[int]:
	var grouped_index: Array[int] # It will always be added in pairs
	var checking_char_opening: String = "\"\'([{"
	var checking_char_closing: String = "\"\')]}"
	var closing_idx: int
	var skip: int = 0
	var indent: int = last_line.indent.count("\t")
	
	for c in text.length(): # Check every char of text
		if current_code.is_in_comment(last_line.line, c+indent) != -1: # If it is in comment, will return other number
			grouped_index.append(c)
			grouped_index.append(text.length()-1)
			break #No need to check comments, add the comment as a big group
		if text[c-1] == "\\" and text[c-2] != "\\": continue # If there is a \ before, it is not starting nor finishing a group
		
		# If letter is inside string, will return an int bigger than -1
		var in_string: bool = current_code.is_in_string(last_line.line, c+indent) != -1
		
		if grouped_index.size() % 2 == 0: # If it's even, it's an openning search
			if checking_char_opening.contains(text[c]):
				grouped_index.append(c)
				closing_idx = checking_char_opening.find(text[c]) # Search only for the closing match
			continue # Only loop next on closing search
	
		# If it is not searching for end of string...
		if checking_char_closing[closing_idx] not in "\'\"":
			if in_string: # ...and it's in a string, ignore
				continue
			if checking_char_opening[closing_idx] == text[c]: # ...and found another opening, skip next closing
				skip += 1
		
		if checking_char_closing[closing_idx] == text[c]: # Found the closing char
			if skip > 0: # If there is nested openings, search next closing char
				skip -= 1
				continue
			grouped_index.append(c)
	
	if grouped_index.size() % 2 == 1: # If it is a odd result, some openning has no closing. Remove it
		grouped_index.resize(grouped_index.size() - 1)
	
	return grouped_index


## It will adjust parameters from methods, such as:[br]
## [code](String my_string, int my_int = 1)[/code] will become [code](my_string: String, my_int: int = 1)[/code][br]
## It will not change the order of parameters in case you type an optional parameter before one that is not.
func adjust_func_parameter(param: String) -> String:
	var begin_substr: int = param.find("(")+1 # Find the first "("
	var end_substr: int = param.rfind(")") # Find the last ")"
	var inside_p: String = param.substr(begin_substr, end_substr - begin_substr)
	var parameters := get_words(inside_p)
	var new_parameters: PackedStringArray
	
	for p in parameters: # For every parameter
		if is_in_type(p[0]) and p.size() > 1: # If it has declared type before name
			p[0] = "%s: %s" % [p[1], p[0]] # Change first value to actual expression (name: type)
			p.remove_at(1)
		new_parameters.append(" ".join(p)) # If there is anything left, add it and save new parameter
	
	var final_p = param.left(begin_substr) + ", ".join(new_parameters) + param.substr(end_substr)
	return final_p


## Add return for methods if any, or [code]pass[/code] if none.[br]
## The standard way of add return is:
##[codeblock]
##    var private_var: RETURN_VAR_TYPE
##    return private_var
##[/codeblock]
## Where [param RETURN_VAR_TYPE] is the return type of method (String, int, etc.)
## and [param private_var] is the name set by you at [code]Editor -> Editor Settings -> GDScript QoL[/code][br]
func add_func_return(func_type: String, line: int = last_line.line) -> void:
	var add_return_line: String = last_line.indent + "\tpass" # Standard line if void
	if func_type != "void":
		var variable_name: String = editor_setting.get_setting("gdscript_qol/function_variable_name")
		add_return_line = last_line.indent + "\tvar %s: %s" %[variable_name, func_type]
		insert_line_at(line+1, add_return_line)
		add_line_if_shortcut(line+2, last_line.indent + "\treturn " + variable_name)
	else:
		add_line_if_shortcut(line+1,add_return_line)
	current_code.set_caret_column.call_deferred(1000)


## Add [param item_matched] enum keys on [code]match[/code] if any.[br]
## Return how many extra lines were inserted in this process.[br][br]
## As said on [method check_match]:[br]
## Although you can use enums from extended classes, trying to use a built-in property of type from
## another enum will fail.[br]
## This means that you [b]CAN[/b] create a property from [enum Node.ProcessMode] and it will work
## as expected, but trying to use directly [member Node.process_mode] [b]WON'T[/b] auto complete.[br]
## This is a problem only for built-in classes. If you extended from another custom class, using
## a property enum from this will work fine.[br]
## One possible workaround is to create a method and pass the enum as parameter. This should
## autocomplete normally.[br][br] 
func add_enum_list(item_matched: String, pass_line: String) -> int:
	var extra_lines: int = 0
	var type: String = is_var_enum_in_method(item_matched) # Check if type is declared inside a method or passed as parameter
	
	if not type: # If there is no type in method, get the type from script property list
		var var_list: Array[Dictionary] = current_script.get_script_property_list()
		var var_name = var_list.filter(func(i): return i.name == item_matched).pop_back()
		if not var_name: return 0 # The variable does not exist or it is not an enum
		type = var_name.class_name
	
	var const_name: String = type.substr(type.rfind(".")+1) # Get the type name, usually comes as CLASS_NAME.CONST_NAME
	var class_n: String = type.trim_suffix("."+const_name) # Get the class name
	
	# Get the path of where enum dict is stored
	var path: String = get_path_from_class_name(class_n)
	
	# If class_n is GDQOLdict, it is a custom name that indicates the variable is declared inside method
	# If resource_path and path are the same, the enum is within the script constant map
	# Get enum from internal script constant map
	if class_n == "GDQOLdict" or current_script.resource_path == path:
		var private_const_list: Dictionary = current_script.get_script_constant_map()
		return insert_enum_dicts(private_const_list[const_name], const_name, pass_line)
	
	if not path: # No path found in custom classes
		return add_enum_const_from_classdb(const_name, pass_line) # Try to find enum in Godot default classes
	
	# Finally get the dict enum from class
	var class_temp = load(path)
	var const_list = class_temp.get(const_name)
	
	if typeof(const_list) != TYPE_DICTIONARY: return 0 # Enums are dict, if it is not a dict, return
	
	# If the code extends the class that has the enum, no need to change to CLASS.ENUM
	if not current_code.text.contains("extends %s" % class_n):
		const_name = type
	
	return insert_enum_dicts(const_list, const_name, pass_line)


## Insert match([param const_name]) enum list from [method ClassDB.class_get_enum_constants].[br]
## Return how many extra lines were inserted in this process.[br][br]
## As said on [method check_match]:[br]
## Although you can use enums from extended classes, trying to use a built-in property of type from
## another enum will fail.[br]
## This means that you [b]CAN[/b] create a property from [enum Node.ProcessMode] and it will work
## as expected, but trying to use directly [member Node.process_mode] [b]WON'T[/b] auto complete.[br]
## This is a problem only for built-in classes. If you extended from another custom class, using
## a property enum from this will work fine.[br]
## One possible workaround is to create a method and pass the enum as parameter. This should
## autocomplete normally.[br][br] 
func add_enum_const_from_classdb(const_name: String, pass_line: String) -> int:
	var parent_class: StringName = current_script.get_instance_base_type() # Get the class this node is extended from
	var const_db: PackedStringArray = ClassDB.class_get_enum_constants(parent_class, const_name)
	if const_db.is_empty(): return 0 # Nothing found
	
	return insert_enum_keys(const_db, pass_line)


## Get [member Resource.resource_path] from [code]class_name[/code] string.[br]
## It only searchs in [method ProjectSettings.get_global_class_list]
## that contains only custom classes.
func get_path_from_class_name(class_n: String) -> String:
	if class_n.ends_with(".gd"): # If there is no class_name, Godot already returns its path
		return class_n
	
	var classes: Array[Dictionary] = ProjectSettings.get_global_class_list()
	var c = classes.filter(func(i): return i.class == class_n).pop_back()
	if not c: return ""
	
	return c.path


## Insert [PackedStringArray] [param lines] with [param pass_line] under each line.[br]
## Return the number of lines inserted.
func insert_enum_keys(lines: PackedStringArray,  pass_line: String) -> int:
	var extra_lines: int = 0
	for line in lines:
		var item_name: String = last_line.indent + "\t%s:" % [line]
		insert_line_at( last_line.line+extra_lines+1, item_name)
		insert_line_at( last_line.line+extra_lines+2, pass_line)
		extra_lines += 2
	return extra_lines


## Insert [Dictionary] keys from [param const_list] with [param pass_line] under each line.[br]
## Return the number of lines inserted.
func insert_enum_dicts(const_list: Dictionary,  const_name: String, pass_line: String) -> int:
	var extra_lines: int = 0
	for i in const_list.keys():
		var item_name: String = last_line.indent + "\t%s.%s:" % [const_name, i]
		insert_line_at( last_line.line+extra_lines+1, item_name)
		insert_line_at( last_line.line+extra_lines+2, pass_line)
		extra_lines += 2
	return extra_lines


## Check if enum is declared inside method or as its parameter.[br]
## Return the enum name as [code]CLASS_NAME.ENUM[/code][br]
## If the enum derived from same class, a special keyword [code]GDQOLdict.[/code] may be returned as prefix.
func is_var_enum_in_method(variant_name: String) -> String:
	if last_line.indent == "": return "" # If there is no indentation, it is not inside function
	
	var func_name: String = ""
	for i in range(last_line.line, 0, -1): # Check lines above until reach "func" keyword
		var text: String = current_code.get_line(i).dedent()
		if text.begins_with("func "): # Found function name, break the loop
			func_name = text.substr(text.find(" ")+1, text.find("(") - text.find(" ")-1)
			break
		
		# Found var name before find keyword "func", therefore, it is declared inside method
		if text.begins_with("var %s " % variant_name) or text.begins_with("var %s:" % variant_name):
			if ":" not in text: return "" # no type declared, impossible to know if it is enum or not
			
			var begin: int = text.find(":")+1
			var end: int = text.find("=")
			var lenght: int = end - begin if end > 0 else -1
			var type: String = text.substr(begin, lenght).strip_edges()
			if not type: # inferred types (aka ":=" symbol) are also impossible to know if it is enum or not
				return ""
			if "." in type: # type comes from another class
				return type
			return "GDQOLdict."+type # Enum is from the class. Retun with custom keyword to know it later
	
	if func_name.is_empty(): return "" # Somehow, iterate all the code without finding "func"
	
	var methods = current_script.get_script_method_list() # Get script method list
	var method_dic = methods.filter(func(i): return i.name == func_name).pop_back() # Get the func found
	if not method_dic: return ""
	
	var arg_name = method_dic.args.filter(func(i): return i.name == variant_name).pop_back() # Check if variable is declared in parameters
	if not arg_name: return ""
	return arg_name.class_name


## Adjust the indentation of multiple lines from block of code pasted.[br]
## It will always try to keep the indetation of the line above.
func indent_paste_block() -> void:
	var lines_pasted: int = last_line.new_line - last_line.line # How many lines were pasted
	var indent_level: int = current_code.get_indent_level(last_line.line-1) / current_code.indent_size
	# Adjust indent level based on line before ( : adds 1, DEDENT_KEYWORDS reduces 1)
	indent_level += indent_difference_from_line_above(last_line.line-1)
	
	adjust_multiple_lines_indent(last_line.line, lines_pasted, indent_level)


## Correct the indentation from [param first_line], for [param total_lines], keeping in mind the first
## indentation should be [param first_indent]
func adjust_multiple_lines_indent(first_line: int,  total_lines: int,  first_indent: int) -> void:
	var new_text: String = "\t".repeat(first_indent) + current_code.get_line(first_line).dedent()
	current_code.set_line.call_deferred(first_line, new_text)
	
	if total_lines < 1: return # If there is only 1 line, then it is done.
	
	# Adjust indent level based on line before ( : adds 1, DEDENT_KEYWORDS reduces 1)
	first_indent += indent_difference_from_line_above(first_line)
	var line_indent_level: int = current_code.get_indent_level(first_line+1) / current_code.indent_size
	var difference_indents: int = line_indent_level - first_indent
	if difference_indents == 0: return # If the indentation is what it's supposed to be, keep it
	
	# If not, let's correct each line
	for l in total_lines:
		new_text = current_code.get_line(first_line + l + 1) # It starts at second line
		
		if difference_indents > 0: # If it should have less indentation than it has
			new_text = new_text.trim_prefix("\t".repeat(difference_indents))
		else: # If it should have more
			new_text = "\t".repeat(-difference_indents) + new_text
		
		current_code.set_line.call_deferred(first_line + l + 1, new_text)


## If a text ends with any [member CodeEdit.indent_automatic_prefixes], it will return [code]1[/code].[br]
## If it starts with any [constant DEDENT_KEYWORDS], it will return [code]-1[/code].[br]
## If neither, it will return [code]0[/code].
func indent_difference_from_line_above(line: int) -> int:
	var uncommented_text: String = get_uncommented_string(line)
	uncommented_text = uncommented_text.strip_edges() # Making sure the last char is not " "
	if uncommented_text.is_empty(): return 0 # To avoid errors with indexes, make sure the line is not empty
	if uncommented_text[-1] in current_code.indent_automatic_prefixes: return 1
	if uncommented_text.get_slice(" ", 0) in DEDENT_KEYWORDS: return -1
	return 0


## Return the [param line] from [TextEdit] but without comments if any.
func get_uncommented_string(line: int) -> String:
	var text: String = current_code.get_line(line)
	if not "#" in text: return text # Yay, there's nothing to do
	
	var uncommented_text: String = text
	var comment_index: int = 0
	var has_comment: bool = false
	for c in text.count("#"):
		comment_index = text.find("#", comment_index+1) # Find "#" indexes
		if (current_code as CodeEdit).is_in_comment(line, comment_index+1) != -1: # Make sure it is in fact a comment, e not inside a string
			has_comment = true # found it, save comment_index var
			break
	
	if has_comment:
		uncommented_text = text.substr(0, comment_index)
	return uncommented_text


## Remove one indent (tab) from next line if the first word is in [constant DEDENT_KEYWORDS][br]
## This option can be disabled at [code]Editor -> Editor Settings -> GDScript QoL[/code]
func dedent_next_line() -> bool:
	# You can disable this option from options if you want to.
	if not editor_setting.get_setting("gdscript_qol/auto_dedent_after_return"): return false
	if last_line.first_word not in DEDENT_KEYWORDS: return false
	
	var next_line_text = current_code.get_line(last_line.new_line)
	if not next_line_text.strip_edges().is_empty(): return false # The line is not empty, keep it
	
	next_line_text = last_line.indent.trim_suffix("\t") # Remove one indent
	current_code.set_line.call_deferred(last_line.new_line, next_line_text)
	return true


## Return [code]true[/code] if [kbd]DELETE[/kbd] or [kbd]BACKSPACE[/kbd] were pressed.[br]
## This uses Godot standart actions [code]"ui_text_delete"[/code] and [code]"ui_text_backspace"[/code].
func deleted_line_action_pressed() -> bool:
	return Input.is_action_just_pressed("ui_text_delete") or\
		Input.is_action_just_pressed("ui_text_backspace")


## If a shortcut input is detect, it is consumed (the input will not propagate to other listeners)
## and the callable [param method_called] is called.
func shortcut_detected(method_called: Callable) -> void:
	is_shortcut_pressed = true
	method_called.call()
	current_code.get_viewport().set_input_as_handled() # This consumes the shortcut to not propagate
	set_deferred("is_shortcut_pressed",  false)


## Called when user perfoms [member create_method_shortcut].[br]
## It calls [constant CREATE_METHOD_POPUP] to create a method from text selected.[br]
## If the text selected is only a word, this word is used to name the new method
## without calling the popup window.[br]
## If no text is selected, the word under caret is used as described above.[br]
## If no word under caret is found, it returns.
func create_method() -> void:
	var text: String = current_code.get_selected_text()
	if not text:
		text = current_code.get_word_under_caret()
		current_code.select_word_under_caret()
		if not text: return
		created_method(text, "", "void", "") # Create method named after the word under caret
		return
	if text.count(" ") == 0 and text.count(".") == 0 and text.count("\n") == 0: # Only single word selected
		created_method(text, "", "void", "") # Create method named after single word selected
		return
	
	var popup: Node = CREATE_METHOD_POPUP.instantiate()
	popup.text = text # This will be passed with popup signal
	popup.created_method.connect(created_method)
	current_code.add_child(popup)


## Create a method (from selection) on the bottom of code.[br]
## The selected text is replaced by method call.
func created_method(method_name: String,  param: String,  return_type: String, text: String) -> void:
	var selection_line: int = current_code.get_selection_from_line() # Remember where text is
	var last_clipboard_text: String = DisplayServer.clipboard_get() # Remember what user has in clipboard
	DisplayServer.clipboard_set("%s(%s)" % [method_name, param]) # Overwrite clipboard to call the created method
	current_code.paste() # Paste method callable where text is selected
	DisplayServer.clipboard_set(last_clipboard_text) # Return the previous clipboard content
	
	var last_line_index: int = current_code.get_line_count() - 1 # Get code bottom
	var last_line_text: String = current_code.get_line(last_line_index)
	if not last_line_text.dedent().is_empty(): # If the last line is not empty, make it empty
		insert_line_at(last_line_index, last_line_text) # The created line is placed above last line, so we must replace both
		last_line_index += 1
		current_code.set_line.call_deferred(last_line_index, "")
	
	var method_line: String = "\nfunc %s(%s) -> %s:" % [method_name, param, return_type]
	insert_line_at(last_line_index, method_line)
	if text:
		var line_count: int = text.count("\n") # How many lines the selected text has
		insert_line_at(last_line_index+2, text)
		adjust_multiple_lines_indent.call_deferred(last_line_index+2, line_count, 1)
		if return_type != "void": # Add return
			last_line.indent = "" # The return type adds one indentation by itself
			add_func_return(return_type, last_line_index+2+line_count)
	else: # If there is no text, just add "pass"
		insert_line_at(last_line_index+2, "\tpass")


## Updates the current caret line without pressing [kbd]ENTER[/kbd], that is, when [member update_line_shortcut] is perfomed.
func update_line() -> void:
	var current_line: int = current_code.get_caret_line()
	check_line(current_line, current_line) # Does all the checks
	set_caret.call_deferred(current_line) # Keep caret at same line


## Put an [code]:[/code] at the end of unfinished [code]if[/code] statements.[br]
## It will not work if there is a comment afte [code]if[/code] statement
func finish_if_statement() -> bool:
	if last_line.first_word != "if": return false
	
	var has_open_p: bool = false
	for c in last_line.text.length(): # Search for ":" that is not in string or comment
		var char_number: int = c + last_line.indent.count("\t")
		if current_code.is_in_string(last_line.line, char_number) != -1: continue
		if current_code.is_in_comment(last_line.line, char_number) != -1: return false # If there is a comment, just ignore
		if last_line.text[c] in "()": has_open_p = !has_open_p # check for open parenthesis (multiline if)
		if last_line.text[c] == ":": return false # If there is any, return
	
	# Check if it is a multiline if
	if last_line.text.strip_edges(false,true).ends_with("\\") or has_open_p:
		return false
	
	var new_line = last_line.indent + last_line.text + ":" # Add :
	current_code.set_line.call_deferred(last_line.line, new_line)
	new_line = "\t" + current_code.get_line(last_line.line+1) # Add indentation under IF
	current_code.set_line.call_deferred(last_line.line+1, new_line)
	set_caret(last_line.new_line)
	return true


## When [code]else[/code] or [code]elif[/code] is typed, auto retreat to last [code]if[/code] statement indentation.
func auto_retreat_else_or_elif() -> bool:
	if last_line.first_word not in ["else", "elif"]: return false
	var correct_indent_level: int = get_if_indent_level() # Find next if statement and return its indent
	
	var new_line: String = "\t".repeat(correct_indent_level) + last_line.text.strip_edges(false, true) + ":"
	current_code.set_line.call_deferred(last_line.line, new_line) # correct the else line
	
	var next_line_indent: int = current_code.get_indent_level(last_line.line + 1) / current_code.indent_size
	if next_line_indent != correct_indent_level + 1: # with the line under else is in wrong indentation, correct
		next_line_indent = correct_indent_level + 1
		var next_text = current_code.get_line(last_line.line + 1)
		next_text = "\t".repeat(next_line_indent) + next_text.strip_edges()
		current_code.set_line.call_deferred(last_line.line + 1, next_text)
		set_caret(last_line.new_line)
	return true


## Get the [code]if[/code] the line is inside and return its indent level.
func get_if_indent_level() -> int:
	var current_indent: int = last_line.indent.count("\t")
	var indent_line_over: int = current_code.get_indent_level(last_line.line-1) / current_code.indent_size
	
	for i in range(last_line.line, 0, -1): # Search for the if that has less indent
		var indent_level: int = current_code.get_indent_level(i) / current_code.indent_size
		if indent_level >= current_indent: continue # The indent is bigger than line
		
		var text: String = current_code.get_line(i)
		var clean_text: String = text.strip_edges()
		if clean_text.begins_with("func"): break # no IF found inside method, no need to keep searching
		if clean_text.begins_with("if"): return indent_level
	return current_indent # Nothing found, keep indentation


## If special keyword set at [code]Editor -> Editor Settings -> GDScript QoL[/code]
## is found at end of line, try to change the line to call_deferred.[br]
## The default keyword is [code]cd[/code].[br]
## [br][b]Example:[/b][br]
## [code]this.method(param) cd[/code][br] is changed to[br] [code]this.method.call_deferred(param)[/code]
func change_call_def(words: PackedStringArray) -> bool:
	words.remove_at(words.size()-1) # Remove keyword
	var parenthesis_index: Array[int] = get_grouped_indexes(words[-1]) # Get parenthesis from method
	if parenthesis_index.is_empty(): return false # No parenthesis found
	var begin: int = parenthesis_index[-2] + 1
	var end: int = parenthesis_index[-1]
	
	var params: String = words[-1].substr(begin, end - begin)
	var func_name: String = words[-1].substr(0, begin-1)
	words[-1] = "%s.call_deferred(%s)" % [func_name, params]
	var new_line = last_line.indent + " ".join(words)
	current_code.set_line.call_deferred(last_line.line, new_line)
	return true


## If special keyword set at [code]Editor -> Editor Settings -> GDScript QoL[/code]
## is found at end of line, try to change the line to set_deferred.[br]
## The default keyword is [code]sd[/code].[br]
## [br][b]Example:[/b][br]
## [code]my_var = true sd[/code][br] is changed to[br] [code]set_deferred("my_var",  true)[/code]
func change_set_def(words: PackedStringArray) -> bool:
	words.remove_at(words.size()-1) # Remove keyword
	if words.size() <= 1 or words[1] != "=": return false # If there is no "=" sign, it is not a variable set
	var value: String
	for w in words.size(): # Get everything after = sign
		if w <= 1: continue
		value += " %s" % words[w]
	
	if value.is_empty(): # Nothing after = sign
		return false
	
	var class_n: String = ""
	var var_name: String = words[0]
	var var_index: int = var_name.rfind(".") # Find if name before = sign has class declared together
	if var_index > 0:
		class_n = var_name.substr(0, var_index) + "."
		var_name = var_name.substr(var_index + 1)
	
	var new_line = last_line.indent + "%sset_deferred(\"%s\",%s)" % [class_n, var_name, value]
	current_code.set_line.call_deferred(last_line.line, new_line)
	return true


## On delete line, delete all indents that are in the middle of text.[br]
## This option can be deactivated at [code]Editor -> Editor Settings -> GDScript QoL[/code]
func remove_indent_on_delete(_to_line: int, _from_line: int) -> void:
	if not editor_setting.get_setting("gdscript_qol/auto_remove_indent_on_delete_line"):
		return # it can be deactivated
	last_line.set_line(_to_line, _from_line, current_code) # Set line info
	
	# If caret is before text, there will be indentation only until it, erasing everything after.
	var caret_pos: int = current_code.get_caret_column()
	if last_line.indent.count("\t") >= caret_pos:
		last_line.indent = "\t".repeat(caret_pos)
	
	# last_line.text should not have \t (indentation) at beginning. 
	# If it has any, it is in the middle of the line and should be removed.
	var new_line = last_line.indent + last_line.text.replace("\t", "")
	current_code.set_line.call_deferred(last_line.line, new_line) 


## Calls [method TextEdit.insert_line_at] and signals the code that the new line
## was not added by user.
func insert_line_at(line: int, text: String) -> void:
	current_code.insert_line_at.call_deferred(line, text)
	updated_by_code = true
#endregion


## Custom class to store most frequently used line info.
class LastLineChanged:
	var first_word: String = "" ## The group of letters until find space " " from text line.
	var text: String = "" ## The whole text without indent (tabs) from beginning.
	var line: int = 0 ## The number index of the last line edited from.
	var new_line: int = 0 ## The number index of the new line edited to.
	var indent: String = "" ## The indent from line returned as text [code]\t[/code].
	
	## Set all variables from class to be easy grabbable.
	func set_line(line_edited: int, line_added: int, current_code: CodeEdit) -> void:
		line = line_edited
		new_line = line_added
		text = current_code.get_line(line).dedent()
		first_word = text.get_slice(" ", 0)
		indent = ""
		var indent_size: int = current_code.indent_size
		var indent_quant: int = current_code.get_indent_level(line)
		indent += "\t".repeat(indent_quant/indent_size)
