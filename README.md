![GDScript Quality of Life logo. It is the external shape of godot logo with a heart hole inside. Inside the heard, you can read the letters GDS.](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/icon128.png)
# GDScript-Quality-of-Life
Bring some quality of life features for GDScript inside godot code editor.

If you really like it and feel like [buying me a piece of cake](https://herbherth.itch.io/gdscript-quality-of-life-plugin) for my efforts, it would be greatly appreciated, thank you!


## Installation:
- Soon you will be able to install via [Godot Asset Store](https://godotengine.org/asset-library/asset).
- Download and unzip the plugin at `res://`, in the end your project should have this path: `res://addons/ScriptEditorQoL`.
- Make sure to enable the plugin at `Project -> Project Settings -> Plugins`
- As simple as that, have fun with your new quality of life GDScript.

## Tutorial:
- Type var_name = value to var var_name: Type = value
- var_number++ to var_number += 1 (also works with --)
- var_number++ 2 to var_number += 2 (also works with -- and any float)
- var_bool! to var_bool = !var_bool
- class? to if class:
- class?method() to if class: class.method()
- method() cd to method.call_deferred()
- my_var = value sd to set_deferred("my_var", value)
- await 1 to await get_tree().create_timer(1).timeout (any float is valid)
- Declare multiple variables in the same line
- Auto correct indentation from pasted blocks to match the line above
- Auto replace set keywords to any line set by you at Editor -> Editor Settings -> GDScript QoL -> Change To
- Auto remove one indentation after return, break and continue
- Auto add : at the end of if statements if they are not closed
- Auto find if above to match indentation when write else or elif
- Auto complete match with enum list if any
- Auto complete methods if write func method_name
- Optionally you can write the method return type and/or parameters, like func name(param) Type
- Auto create method from selection when shortcut is pressed (default is Ctrl + M)
- Update the line when Enter is pressed, or the shortcut (default is Ctrl + U)

## Settings:
Change the settings at Editor -> Editor Settings -> GDScript QoL 

function variable name: The name of the variable that will be auto created when creating a method with return type. 
Default value: private_var 

call deferred keyword: The keyword used at the end of a line to change the called method to call_deferred. 
Default value: cd 

set deferred keyword: The keyword used at the end of a line to change the set variable to set_deferred. 
Default value: sd 

auto dedent after return: If it should auto dedent (remove one tab) after the keywords from DEDENT_KEYWORDS. 
Default value: true 

create method shortcut: The shortcut to create method from selection. The method created will be placed at the end of the code. 
Default value: ctrl + M 

update line shortcut: The shortcut to update the current line without pressing ENTER. 
Default value: ctrl + U 

change to: A dictionary of STRING keys that when they are found as a line text, will auto change to respective values as String. 
Default value:  "await f": "await get_tree().process_frame" 
For now, it only accepts single line changes. To use multiline changes, I recommend give a look at GDScriptMacros  -  Not mine, btw
