class_name WorldUpdater
extends Node

## Signal emitted whenever the state of the world is updated
signal world_updated

@onready var properties: GridProperties = $"../Properties"

## Array that contains the internal state of the world cells
var _previous_states: Array[bool]
var _current_states: Array[bool]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cell_count: int = properties.dimensions.x * properties.dimensions.y
	_previous_states = []
	_previous_states.resize(cell_count)
	_previous_states.fill(false)
	_current_states = _previous_states.duplicate()
	
	set_state_at(30, 30, true)
	set_state_at(30, 31, true)
	set_state_at(29, 30, true)
	set_state_at(28, 30, true)
	set_state_at(27, 30, true)


func _update_world_state() -> void:
	# First move the world state to the previous state array and clear the current state
	_previous_states = _current_states.duplicate()
	_current_states.fill(false)
	
	## Go through all cells in the grid and update their state
	for y in range(0, properties.dimensions.y):
		for x in range(0, properties.dimensions.x):
			var alive: bool = _should_be_alive_at(x, y)
			set_state_at(x, y, alive)
			
	world_updated.emit()
	

## Checks if the cell is alive at the given grid position
## returns: True, if the cell is alive. False otherwise
func get_state_at(x: int, y: int) -> bool:
	return _current_states[_get_array_position(x, y)]
	
	
## Sets state of the cell at the given grid coordinates
func set_state_at(x: int, y: int, state: bool) -> void:
	_current_states[_get_array_position(x, y)] = state
	
	
## Checks if the cell was alive at the given grid position in the previous interation
## returns: True, if the cell was alive. False otherwise
func get_state_at_previous(x: int, y: int) -> bool:
	return _previous_states[_get_array_position(x, y)]
	
## Converts grid coordinates into internal array representation's position
## returns: Index inside the [_alive_states] array
func _get_array_position(x: int, y: int) -> int:
	return y * properties.dimensions.x + x


## Determines if the cell at the given coordinates should be alive in the next iteration
func _should_be_alive_at(x: int, y: int) -> bool:
	# Count cells alive around the given cell
	var alive_around: int = 0
	
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			# Check only cells around the given one
			if dx == 0 and dy == 0:
				continue
				
			var checked_x: int = _wrap_around(x + dx, 0, properties.dimensions.x - 1)
			var checked_y: int = _wrap_around(y + dy, 0, properties.dimensions.y - 1)
			
			if get_state_at_previous(checked_x, checked_y):
				alive_around += 1
				
	var self_alive: bool = get_state_at_previous(x, y)
	
	if not self_alive and alive_around == 3:
		return true
	elif self_alive and alive_around >= 2 and alive_around <= 3:
		return true
		
	return false

## Wraps around the provided [param value].
## returns: [param value] if it is between [param min_value] and [param max_value]. Otherwise wraps it around the 
## proper side. 
func _wrap_around(value: int, min_value: int, max_value: int) -> int:
	if value < min_value:
		return max_value - (min_value - value) + 1
	elif value > max_value:
		return min_value + (value - max_value) - 1
		
	return value
