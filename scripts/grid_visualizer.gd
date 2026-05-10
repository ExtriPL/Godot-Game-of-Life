class_name GridVisualizer
extends Node2D

## Properties of a grid that will be visualized
@export var properties: GridProperties

## Size of a single cell in the form of a vector
var _grid_cell_size: Vector2
## Instance that holds the state of the world
var _state_holder: WorldStateHolder


func _draw() -> void:
	# Suppose world's (0, 0) point is in the middle of the grid
	var dimensions: Vector2i = properties.dimensions
	
	# Draw alive cells
	var cell_color: Color = properties.cell_alive_color
	
	for y in range(0, dimensions.y):
		for x in range(0, dimensions.x):
			if not _state_holder.get_state_at(x, y):
				continue
				
			# Cell is alive. We need to draw it
			var cell_position: Vector2 = properties.grid_to_world_position(Vector2i(x, y))
			var rect: Rect2 = Rect2(cell_position, _grid_cell_size)
			draw_rect(rect, cell_color, true)
	
	# Draw grid lines
	var line_color: Color = properties.line_color
	
	# Draw vertical lines
	for x in range(0, dimensions.x + 1):
		var start_pos: Vector2 = properties.grid_to_world_position(Vector2i(x, 0))
		var end_pos: Vector2 = properties.grid_to_world_position(Vector2i(x, dimensions.y))
		draw_line(start_pos, end_pos, line_color)
		
	# Draw horizontal lines
	for y in range(0, dimensions.y + 1):
		var start_pos: Vector2 = properties.grid_to_world_position(Vector2i(0, y))
		var end_pos: Vector2 = properties.grid_to_world_position(Vector2i(dimensions.x, y))
		draw_line(start_pos, end_pos, line_color)
		
		
func change_state_holder(value: WorldStateHolder) -> void:
	if _state_holder != null:
		_state_holder.world_state_changed.disconnect(redraw)
		
	_state_holder = value
	_state_holder.world_state_changed.connect(redraw)
	redraw()
	
		
## Redraws the grid based on the newest properties
func redraw() -> void:
	_grid_cell_size = Vector2(properties.cell_size, properties.cell_size)
	queue_redraw()
	