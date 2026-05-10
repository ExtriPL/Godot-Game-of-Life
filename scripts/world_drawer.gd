extends WorldStateHolder

## Main world camera
@export var _camera: Camera2D
## Color of the indicator when it is over an empty field on which drawing is possible
@export var _drawing_color: Color
## Color of the indicator when it is over an occupied field on which removing is possible
@export var _removing_color: Color
## Sprites that indicates where the drawing will occur
@onready var _drawing_indicator: Sprite2D = $Indicator 

## Is drawing enabled at the movment?
var _active: bool = true
## Flag indicating if the drawing mode is active. If false, the removing mode is active
var _drawing_mode: bool = true
## Is mouse over the drawable area?
var _mouse_over_area: bool = false

func _ready() -> void:
	super._ready()
	_drawing_indicator.self_modulate = properties.cell_alive_color
	_drawing_indicator.self_modulate.a = 0.5

func _process(_delta: float) -> void:
	# Make sure that the drawing is enabled
	if not _mouse_over_area or not _active:
		_drawing_indicator.visible = false
		return
		
	_drawing_indicator.visible = true
	
	# Update the indicator
	var grid_position: Vector2i = _move_indicator_to_mouse()
	_perform_drawing(grid_position)
	
	
func _perform_drawing(grid_position: Vector2i) -> void:
	if not Input.is_action_pressed("world_drawing"):
		return
	
	# Correct action was pressed. We can change the state at the given position
	set_state_at(grid_position.x, grid_position.y, _drawing_mode)
	world_state_changed.emit()
	

## Method that converts [param screen_position] from the screen to the world space.
## returns: Position in the world space
func _screen_to_world_position(screen_position: Vector2) -> Vector2:
	# Position of the (0, 0) point on the screen relative to the screen's center position
	var screen_zero_position: Vector2 = -_camera.get_viewport_rect().size / 2.0
	# Screen center position in the world coordinates
	var center_position: Vector2 = _camera.get_screen_center_position()
	
	return center_position + screen_zero_position + screen_position
	
	
## Moves the drawing indicator to the grid position indicated by the mouse cursor
## returns: Grid position indicated by the cursor
func _move_indicator_to_mouse() -> Vector2i:
	var mouse_position: Vector2 = _camera.get_viewport().get_mouse_position()
	var world_position: Vector2 = _screen_to_world_position(mouse_position)
	var grid_position: Vector2i = properties.world_to_grid_position(world_position)
	
	_drawing_indicator.position = properties.grid_to_world_position(grid_position)
	return grid_position


func _on_grid_clickable_area_mouse_entered() -> void:
	_mouse_over_area = true


func _on_grid_clickable_area_mouse_exited() -> void:
	_mouse_over_area = false


func _on_drawing_mode_selected() -> void:
	_active = true
	_drawing_mode = true
	_drawing_indicator.self_modulate = _drawing_color


func _on_removing_mode_selected() -> void:
	_active = true
	_drawing_mode = false
	_drawing_indicator.self_modulate = _removing_color


func _on_movement_mode_selected() -> void:
	_active = false


func _on_stop_button_pressed() -> void:
	_active = true


func _on_start_button_pressed() -> void:
	_active = false


func _on_drawing_control_random_button_pressed() -> void:
	# Initialize with random values
	for i in range(_states.size()):
		_states[i] = false if randf() < 0.5 else true
		
	world_state_changed.emit()


func _on_drawing_control_clear_button_pressed() -> void:
	# Clear the grid
	_states.fill(false)
	world_state_changed.emit()
