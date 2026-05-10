class_name GridProperties
extends Node

## Signal invoked when any of the grid properties has been changed
signal properties_changed;

## Size of a single grid cell
@export var cell_size: float = 0.0:
	set(value):
		cell_size = value
		_update_auto_properties()
		properties_changed.emit()
## Dimensions of the grid (number of rows and columns)
@export var dimensions: Vector2i:
	set(value):
		dimensions = value
		_update_auto_properties()
		properties_changed.emit()
## Line color
@export var line_color: Color:
	set(value):
		line_color = value
		_update_auto_properties()
		properties_changed.emit()
## Color assigned to a cell that is alive
@export var cell_alive_color: Color:
	set(value):
		cell_alive_color = value
		_update_auto_properties()
		properties_changed.emit()
		
## Position of the (0, 0) grid point in the world coordinates
var _world_zero_position: Vector2


## Converts [param grid_position] from the grid to the world space
func grid_to_world_position(grid_position: Vector2i) -> Vector2:
	return _world_zero_position + grid_position * cell_size
	
	
## Converts the [param world_position] into the closes grid position.
## returns: Grid-space position with unconstrained parameters
func world_to_grid_position(world_position: Vector2) -> Vector2i:
	var relative_position: Vector2 = world_position - _world_zero_position
	var grid_x: int = floori(relative_position.x / cell_size)
	var grid_y: int = floori(relative_position.y / cell_size)

	return Vector2i(grid_x, grid_y)
	
	
## Snaps the provided [param world_position] to the closes grid position
## returns: Closest grid position in the world space
func snap_to_grid(world_position: Vector2) -> Vector2:
	return grid_to_world_position(world_to_grid_position(world_position))
		
		
func _selected_grid_dimensions_changed(value: Vector2i) -> void:
	dimensions = value
	
	
## Updates values of the auto properties
func _update_auto_properties() -> void:
	_world_zero_position = -dimensions * cell_size / 2.0