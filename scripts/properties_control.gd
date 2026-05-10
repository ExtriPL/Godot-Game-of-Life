extends VBoxContainer

## Signal emitted when the size of the grid is changed
signal grid_dimensions_changed(value: Vector2i)

var _current_grid_size: Vector2i


func _ready() -> void:
	var grid_width: int  = ($GridWidth/SpinBox as SpinBox).value as int
	var grid_height: int  = ($GridHeight/SpinBox as SpinBox).value as int
	
	_current_grid_size = Vector2i(grid_width, grid_height)
	grid_dimensions_changed.emit(_current_grid_size)


func _on_grid_width_changed(value: int) -> void:
	_current_grid_size.x = value
	grid_dimensions_changed.emit(_current_grid_size)


func _on_grid_height_changed(value: int) -> void:
	_current_grid_size.y = value
	grid_dimensions_changed.emit(_current_grid_size)


func _on_start_button_pressed() -> void:
	visible = false

func _on_stop_button_pressed() -> void:
	visible = true
