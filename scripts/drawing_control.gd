extends HBoxContainer

signal random_button_pressed
signal clear_button_pressed

func _on_random_button_pressed() -> void:
	random_button_pressed.emit()


func _on_clear_button_pressed() -> void:
	clear_button_pressed.emit()


func _on_start_button_pressed() -> void:
	visible = false


func _on_stop_button_pressed() -> void:
	visible = true
