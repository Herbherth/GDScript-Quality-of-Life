@tool
extends PopupPanel

signal created_method(method_name: String, param: String, type: String, text: String)
@onready var method_name: LineEdit = $Vertical_align/func_name/method_name
@onready var param: LineEdit = $Vertical_align/func_name/param
@onready var return_type: LineEdit = $Vertical_align/func_name/return_type
var text: String = ""

func _ready() -> void:
	method_name.grab_focus()


func _on_create_pressed() -> void:
	var method_n = method_name.text if not method_name.text.is_empty() else "unnamed_method"
	var param_n = param.text
	var type = return_type.text if not return_type.text.is_empty() else "void"
	created_method.emit(method_n, param_n, type, text)
	queue_free()


func _on_cancel_pressed() -> void:
	queue_free()


func _on_text_submitted(_new_text: String) -> void:
	_on_create_pressed()
