extends Node2D

@onready var properties: GridProperties = $"../Properties"
@onready var world: WorldUpdater = $"../Updater"


func _draw() -> void:
	# Suppose world's (0, 0) point is in the middle of the grid
	var dimensions: Vector2 = (properties.dimensions as Vector2)
	var cell_size: float = properties.cell_size
	var cell_size2: Vector2 = Vector2(cell_size, cell_size)
	var start_offset: Vector2 = -dimensions / 2.0
	
	# Draw alive cells
	var cell_color: Color = properties.cell_alive_color
	
	for y in range(0, dimensions.y):
		for x in range(0, dimensions.x):
			if not world.get_state_at(x, y):
				continue
				
			# Cell is alive. We need to draw it
			var cell_position: Vector2 = (start_offset + Vector2(x, y)) * cell_size
			var rect: Rect2 = Rect2(cell_position, cell_size2)
			draw_rect(rect, cell_color, true)
	
	# Draw grid lines
	var line_color: Color = properties.line_color
	
	# Draw vertical lines
	for x in range(0, dimensions.x + 1):
		var start_pos: Vector2 = start_offset + Vector2(x, 0)
		var end_pos: Vector2 = start_offset + Vector2(x, properties.dimensions.y)
		draw_line(start_pos * cell_size, end_pos * cell_size, line_color)
		
	# Draw horizontal lines
	for y in range(0, dimensions.y + 1):
		var start_pos: Vector2 = start_offset + Vector2(0, y)
		var end_pos: Vector2 = start_offset + Vector2(properties.dimensions.x, y)
		draw_line(start_pos * cell_size, end_pos * cell_size, line_color)
		
## Redraws the grid based on the newest properties
func redraw() -> void:
	queue_redraw()
	
	