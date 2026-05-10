extends Camera2D

@export var properties: GridProperties

var _mouse_in_area: bool = false
var _dragging_mode: bool = false
## Anchor used to calculate dragging shift
var _dragging_anchor: Vector2 = Vector2.ZERO
## Position of the camera when the dragging process started
var _dragging_start_position: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	properties.properties_changed.connect(_update_allowed_area)
	_update_allowed_area()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not _mouse_in_area or not _dragging_mode or not Input.is_action_pressed("tool_use"):
		return
		
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var half_size: Vector2 = get_viewport_rect().size / 2.0
		
	if Input.is_action_just_pressed("tool_use"):
		_dragging_anchor = mouse_position
		_dragging_start_position = position
		
	var shift: Vector2 = mouse_position - _dragging_anchor
	
	var target_position: Vector2 = _dragging_start_position - shift
	var clamped_x: float = clampf(target_position.x, limit_left + half_size.x, limit_right - half_size.x)
	var clamped_y: float = clampf(target_position.y, limit_top + half_size.y, limit_bottom - half_size.y)
	
	position = Vector2(clamped_x, clamped_y)

func _update_allowed_area() -> void:
	var min_position: Vector2 = properties.grid_to_world_position(Vector2i.ZERO)
	var max_position: Vector2 = properties.grid_to_world_position(properties.dimensions)
	
	limit_left = min_position.x as int
	limit_right = max_position.x as int
	limit_bottom = max_position.y as int
	limit_top = min_position.y as int


func _on_grid_clickable_area_mouse_entered() -> void:
	_mouse_in_area = true


func _on_grid_clickable_area_mouse_exited() -> void:
	_mouse_in_area = false


func _enable_dragging() -> void:
	_dragging_mode = true
	
	
func _disable_dragging() -> void:
	_dragging_mode = false