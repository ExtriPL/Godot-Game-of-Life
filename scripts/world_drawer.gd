extends WorldStateHolder

## Main world camera
@export var camera: Camera2D
## Color of the indicator when it is over an empty field on which drawing is possible
@export var drawing_color: Color
## Color of the indicator when it is over an occupied field on which removing is possible
@export var removing_color: Color
## Sprites that indicates where the drawing will occur
@onready var _drawing_indicator: Sprite2D = $DrawingPixel 

var drawing_enabled: bool = false

func _ready() -> void:
	super._ready()
	_drawing_indicator.self_modulate = properties.cell_alive_color
	_drawing_indicator.self_modulate.a = 0.5

func _process(_delta: float) -> void:
	# Make sure that the drawing is enabled
	if not drawing_enabled:
		return
	
	# Update the indicator
	var grid_position: Vector2i = _move_indicator_to_mouse()
	_update_indicator_color(grid_position)
	
	if not Input.is_action_just_pressed("world_drawing"):
		return
	
	# Correct action was pressed. We can change the state at the given position
	var current_state: bool = get_state_at(grid_position.x, grid_position.y)
	set_state_at(grid_position.x, grid_position.y, not current_state)
	world_state_changed.emit()
	

## Method that converts [param screen_position] from the screen to the world space.
## returns: Position in the world space
func _screen_to_world_position(screen_position: Vector2) -> Vector2:
	# Position of the (0, 0) point on the screen relative to the screen's center position
	var screen_zero_position: Vector2 = -camera.get_viewport_rect().size / 2.0
	# Screen center position in the world coordinates
	var center_position: Vector2 = camera.get_screen_center_position()
	
	return center_position + screen_zero_position + screen_position
	
	
## Moves the drawing indicator to the grid position indicated by the mouse cursor
## returns: Grid position indicated by the cursor
func _move_indicator_to_mouse() -> Vector2i:
	var mouse_position: Vector2 = camera.get_viewport().get_mouse_position()
	var world_position: Vector2 = _screen_to_world_position(mouse_position)
	var grid_position: Vector2i = properties.world_to_grid_position(world_position)
	
	_drawing_indicator.position = properties.grid_to_world_position(grid_position)
	return grid_position
	
	
func _update_indicator_color(grid_position: Vector2i) -> void:
	var state_at_grid: bool = get_state_at(grid_position. x, grid_position.y)
	_drawing_indicator.self_modulate = removing_color if state_at_grid else drawing_color


func _on_grid_clickable_area_mouse_entered() -> void:
	drawing_enabled = true
	_drawing_indicator.visible = true


func _on_grid_clickable_area_mouse_exited() -> void:
	drawing_enabled = false
	_drawing_indicator.visible = false
