class_name GridProperties
extends Node

## Signal invoked when any of the grid properties has been changed
signal properties_changed;

## Size of a single grid cell
@export var cell_size: float = 0.0:
	set(value):
		cell_size = value
		properties_changed.emit()
## Dimensions of the grid (number of rows and columns)
@export var dimensions: Vector2i:
	set(value):
		dimensions = value
		properties_changed.emit()
## Line color
@export var line_color: Color:
	set(value):
		line_color = value
		properties_changed.emit()
## Color assigned to a cell that is alive
@export var cell_alive_color: Color:
	set(value):
		cell_alive_color = value
		properties_changed.emit()