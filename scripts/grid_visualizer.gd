extends Node2D

## Properties of a grid that will be visualized
@export var properties: GridProperties
## Class that holds the state of the world
@export var state_holder: WorldStateHolder

## Point at which (0, 0) grid point will be drawn
var _start_offset: Vector2
## Size of a single cell in the form of a vector
var _grid_cell_size: Vector2

func _ready() -> void:
	redraw()	


func _draw() -> void:
	# Suppose world's (0, 0) point is in the middle of the grid
	var dimensions: Vector2i = properties.dimensions
	
	# Draw alive cells
	var cell_color: Color = properties.cell_alive_color
	
	for y in range(0, dimensions.y):
		for x in range(0, dimensions.x):
			if not state_holder.get_state_at(x, y):
				continue
				
			# Cell is alive. We need to draw it
			var cell_position: Vector2 = _grid_to_world_position(x, y)
			var rect: Rect2 = Rect2(cell_position, _grid_cell_size)
			draw_rect(rect, cell_color, true)
	
	# Draw grid lines
	var line_color: Color = properties.line_color
	
	# Draw vertical lines
	for x in range(0, dimensions.x + 1):
		var start_pos: Vector2 = _grid_to_world_position(x, 0)
		var end_pos: Vector2 = _grid_to_world_position(x, dimensions.y)
		draw_line(start_pos, end_pos, line_color)
		
	# Draw horizontal lines
	for y in range(0, dimensions.y + 1):
		var start_pos: Vector2 = _grid_to_world_position(0, y)
		var end_pos: Vector2 = _grid_to_world_position(dimensions.x, y)
		draw_line(start_pos, end_pos, line_color)
	
		
## Redraws the grid based on the newest properties
func redraw() -> void:
	_start_offset = -properties.dimensions / 2.0 * properties.cell_size
	_grid_cell_size = Vector2(properties.cell_size, properties.cell_size)
	queue_redraw()
	
	
## Converts postion from grid to world coordinates
func _grid_to_world_position(x: int, y: int) -> Vector2:
	return _start_offset + Vector2(x, y) * properties.cell_size