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
The line is updated as soon as you press `Enter` to change the line.

Alternatively, you can press the shortcut to update the line without adding a new one. The default shortcut is `Ctrl + U`, but it can be changed at the plugin settings.

> [!NOTE]
>If you end your line with a colon `:`, this line will be considered completed and not be updated.

> [!NOTE]
>This code will change only one thing at a time. It will not do multiple operations at once.

-------------------------------------------
- ### Write typed variables easier
Instead of writing `var var_name: Type = value`, just use `Type var_name = value`

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/typed_var.gif)

You can also declare multiple variables in the same line, they will be split by commas `,` and there is no need to give every variable a value

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/multiline_typed_var.gif)

You can even declare multiple variables using the `var` keyword to split different types at once

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/multiline_var.gif)

-----------------------------------------
- ### Use double signs `++` or `--`
Do fast calculations using `++` or `--`, it even accepts any float number after to use as calculation.

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/doublesigns.gif)

-----------------------------------------
- ### Invert booleans value with `!`
Instead of writing `boolean = !boolean`, just use `boolean!`

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/invertbool.gif)

-----------------------------------------
- ### Check for null with `?`
Just type an interrogation mark `?` to change it for an `if`

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/checknull.gif)

-----------------------------------------
- ### Check for null before call a method
Instead of writing `if class: class.method()`, just use `class?method()`

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/checknullmethod.gif)

----------------------------------------
- ### Easy call a method deferred
Use the keyword `cd` at the end of a method call, to change it to deferred. (The keyword can be changed at the plugin settings)

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/cd.gif)

It can also take parameters

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/cdparam.gif)

---------------------------------------
- ### Easy set a variable deferred
Use the keyword `sd` at the end of variable being set, to change it to deferred. (The keyword can be changed at the plugin settings)

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/sd.gif)

--------------------------------------
- ### Await 1 second? Just use `await 1`
Instead of writing `await get_tree().create_timer(1).timeout`, just use `await 1`. Any float can go instead of 1.

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/await_time.gif)

----------------------------------------
- ### Replace any keyword for any line you want to
In the plugin settings, at `Change To` option, you can add any keyword you'd like to replace for any line.

The default line that is there is:

`await f` change to `await get_tree().process_frame`

>[!IMPORTANT]
>It must be a string key and will change the value for a string.
>
>It also only changes one line. To change multiple lines, I recommend give a look at [GDScriptMacros](https://github.com/rainlizard/GDScriptMacros)

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/await_f.gif)

---------------------------------------
- ### Auto correct indentation when pasting blocks of code
If you copied a block of code, the copied indentation is preserved when pasting, and it can be annoying if you are pasting somewhere that the indentation is different.

With this plugin, you don't need to worry about it anymore. It will always try to keep the indentation based on the line above.
>[!WARNING]
>Because of that, if you try to paste a method under a line that has some indentation, the method will be pasted with one indentation.
>
>In this cases, always be sure to have at least one empty unindented line above the line you are pasting.
>
>I could indentify if it has the `func` keyword, but sometimes, like inside a inner class, the methods do have one indentation.

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/paste.gif)

---------------------------------------
- ### Auto remove one indentation after `return`, `break` and `continue`
Usually, after those words, you don't want to write anything with the same indentation (because it won't be read anyways).

Just give it a enter and the indentation will automatic be removed by 1. If you are too used to give enter + backspace already, you can disable it at the plugin settings.

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/dedent.gif)

---------------------------------------
- ### Auto add `:` at the end of `if`, `else` and `elif`, and adjust the indentation
Have you ever forgotten to finish your `if` with `:` just to receive an error in your face? (Or is it only me?)

Now it will always be completed to you.

>[!NOTE]
>It will not complete if your `if` has multiple lines, like being broken by `\` or inside `()`

Also, when you write an open `else` or `elif` (withou `:`), it will search on the lines above for an `if` and auto correct its indentation.

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/if_ending.gif)

----------------------------------------
# README NOT YET FINISHED
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
