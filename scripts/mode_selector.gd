extends HBoxContainer

## Signal emitted when the movement mode is selected
signal movement_mode_selected
## Signal emitted when the drawing mode is selected
signal drawing_mode_selected
## Signal emitted when the removing mode is selected
signal removing_mode_selected

func _on_movement_button_pressed() -> void:
	movement_mode_selected.emit()


func _on_drawing_button_pressed() -> void:
	drawing_mode_selected.emit()


func _on_removing_button_pressed() -> void:
	removing_mode_selected.emit()


func _on_start_button_pressed() -> void:
	visible = false


func _on_stop_button_pressed() -> void:
	visible = true
