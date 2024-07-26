![GDScript Quality of Life logo. It is the external shape of godot logo with a heart hole inside. Inside the heard, you can read the letters GDS.](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/icon128.png)
# GDScript-Quality-of-Life
Bring some quality of life features for GDScript inside godot code editor.

This plugin should work for Godot 4 and higher.

If you really like it and feel like [buying me a piece of cake](https://herbherth.itch.io/gdscript-quality-of-life-plugin) for my efforts, it would be greatly appreciated, thank you!

## Installation:
- Soon you will be able to install via [Godot Asset Store](https://godotengine.org/asset-library/asset).
- Download and unzip the plugin at `res://`, in the end your project should have this path: `res://addons/ScriptEditorQoL`.
- Make sure to enable the plugin at `Project -> Project Settings -> Plugins`
- As simple as that, have fun with your new quality of life GDScript.

## Tutorial:
The line is updated as soon as you press `Enter` to change the line.

Alternatively, you can press the shortcut to update the line without adding a new one. The default shortcut is `Ctrl + U`, but it can be changed at the [plugin settings](#plugin-settings).

> [!NOTE]
>If you end your line with a colon `:`, this line will be considered completed and not be updated.

> [!NOTE]
>This code will change only one thing at a time. It will not do multiple operations at once.

-------------------------------------------

- ### Easy typed variables
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
Use the keyword `cd` at the end of a method call, to change it to deferred. (The keyword can be changed at the [plugin settings](#plugin-settings))

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/cd.gif)

It can also take parameters

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/cdparam.gif)

---------------------------------------
- ### Easy set a variable deferred
Use the keyword `sd` at the end of variable being set, to change it to deferred. (The keyword can be changed at the [plugin settings](#plugin-settings))

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/sd.gif)

--------------------------------------
- ### Await 1 second? Just use `await 1`
Instead of writing `await get_tree().create_timer(1).timeout`, just use `await 1`. Any float can go instead of 1.

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/await_time.gif)

----------------------------------------
- ### Replace any keyword for any line you want to
In the [plugin settings](#plugin-settings), at `Change To` option, you can add any keyword you'd like to replace for any line.

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

Just give it a enter and the indentation will automatic be removed by 1. If you are too used to give enter + backspace already, you can disable it at [plugin settings](#plugin-settings).

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/dedent.gif)

--------------------------------------
- ### Remove indentation from middle of line on delete
When pressing delete at the end of a line, automatically remove the indentation that stays in the middle of the line.

This feature can be disabled at [plugin settings](#plugin-settings).

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/removeindentondelete.gif)
  
---------------------------------------
- ### Auto add `:` at the end of `if`, `else` and `elif`, and adjust the indentation
Have you ever forgotten to finish your `if` with `:` just to receive an error in your face? (Or is it only me?)

Now it will always be completed to you.

>[!NOTE]
>It will not complete if your `if` has multiple lines, like being broken by `\` or inside `()`

Also, when you write an open `else` or `elif` (withou `:`), it will search on the lines above for an `if` and auto correct its indentation.

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/if_ending.gif)

----------------------------------------
- ### Easy populate `match` with enum key items
If you use the `match` keyword with a enum, don't worry about populate everysingle enum key into it.
The plugin will automatically populate it for you and even add an else case `_:` at the end.
You can write `match ENUM_VAR` or `match(ENUM_VAR)`.

>[!IMPORTANT]
>You must have successfully saved the code where the enum keys exists at least once before trying to use the `match`.
>
>If you do not save, the keys will NOT be autopopulated!

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/enum.gif)

You can even use enum keys from a parent script.

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/enum_fromparent.gif)

>[!WARNING]
>You can also use a property variable from a parent script if this parent is a custom code written in GDScript, but unfortunately, trying to use a property variable from built-in classes will not auto populate the match.
>
>This means that you can, as showed in gif, use [Node.ProcessMode](https://docs.godotengine.org/en/stable/classes/class_node.html#enum-node-processmode) to create your variable, but trying to use directly [Node.process_mode](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-property-process-mode) will not be autopopulated.
>
>One workaround for it is to pass the enum as parameter of a method, as shown in first gif. This way, the plugin will know from where to take the enum keys to populate the `match`.

-----------------------------------------
- ### Easy create typed methods
Instead of writing `func my_func() -> void:`, just use `func my_func`.

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/func.gif)

You can also, optionally, use parameters and a return type using `func my_func(parameters) type`.

You can also write parameters like [you write typed variables](#easy-typed-variables) and it will be automatically be adjusted for you.

But it will NOT change the order of items, so be sure to keep your optinal parameters at the end.

The name of the created variable can be adjusted at [plugin settings](#plugin-settings).

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/func_typed.gif)

----------------------------------------
- ### Create method from selection
Use the shortcut `Ctrl + M` to create a method from selected text. You can change the shortcut at [plugin settings](#plugin-settings).

You can optionally choose the method name, parameters and return type.

You can navigate through the popup window just with `Tab` to change focused item, `Enter` to create the method, and `Esc` to cancel.

The new created method will be placed at the very bottom of your code, and where the selected text was, it will be placed the method call.

Usually, when you save a code, godot automatically makes sure there is one empty line at the bottom, but if for any reason there isn't, keep in mind that the last line can be messed up with the new method (normally it should not be a problem).

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/createmethod.gif)

-----------------------------------------
- ### Create method from word
If you use the shortcut `Ctrl + M` and there is no selected text, the word under caret will be selected and a method will be automatically created with this word as method name.

If the caret is at the end of a word, it will first select the whole word, and the shortcut need to be pressed again to create the method.

The word will become a method call with `()` at the end, in some cases you might want to delete it (as shown in gif bellow).

You can change the shortcut at [plugin settings](#plugin-settings).

![](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/createmethodfromword.gif)

## Plugin settings:
You can change the settings at `Editor -> Editor Settings -> GDScript QoL`

![editor settings window](https://raw.githubusercontent.com/Herbherth/GDScript-Quality-of-Life/main/images/Editor%20Settings.png)

The plugin settings are saved in the folder returned by [EditorPaths.get_config_dir](https://docs.godotengine.org/en/stable/classes/class_editorpaths.html#class-editorpaths-method-get-config-dir) in a different file that will be used to keep your settings among your projects, so you don't have to set them again if you change project.

- ### Function Variable Name
The name of the variable that will be auto created when creating a method with return type. 

>Default value: `private_var`

- ### Call Deferred Keyword
The keyword used at the end of a line to change the called method to call_deferred. 

>Default value: `cd`

- ### Set Deferred Keyword
The keyword used at the end of a line to change the set variable to set_deferred. 

>Default value: `sd`

- ### Auto Dedent After Return
If it should auto dedent (remove one tab) after the keywords `return`, `break` and `continue`. 

>Default value: `true` 

- ### Auto Remove Indent on Delete Line
If it should remove the indentation from middle of line when a delete action joins two lines. 

>Default value: `true`

- ### Create Method Shortcut
The shortcut to create method from selection. The method created will be placed at the end of the code. 

>Default value: `ctrl + M`

- ### Update Line Shortcut
The shortcut to update the current line without pressing ENTER. 

>Default value: `ctrl + U`

- ### Change To
A dictionary of keys that when they are found as a line text, will auto change to respective values as String.

The keys must be from type [b]String[/b], or it will not be found.

>Default value:  `"await f": "await get_tree().process_frame"`

For now, it only accepts single line changes. To use multiline changes, I recommend give a look at [GDScriptMacros](https://github.com/rainlizard/GDScriptMacros)  -  Not mine, btw
