class_name WorldUpdater
extends WorldStateHolder

## Signal emitted whenever the state of the world is updated
signal world_updated

## Array that contains the internal state of the world cells
var _previous_states: Array[bool]


func _update_world_state() -> void:
	# First move the world state to the previous state array and clear the current state
	_previous_states = _states.duplicate()
	_states.fill(false)
	
	## Go through all cells in the grid and update their state
	for y in range(0, properties.dimensions.y):
		for x in range(0, properties.dimensions.x):
			var alive: bool = _should_be_alive_at(x, y)
			set_state_at(x, y, alive)
			
	world_updated.emit()
	
	
## Checks if the cell was alive at the given grid position in the previous interation
## returns: True, if the cell was alive. False otherwise
func get_state_at_previous(x: int, y: int) -> bool:
	return _previous_states[_get_array_position(x, y)]
	

## Determines if the cell at the given coordinates should be alive in the next iteration
func _should_be_alive_at(x: int, y: int) -> bool:
	var alive_around: int = _get_alive_around(x, y)	
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

## Obtains number of alive cells around the given position. If the position is around the
## edges, it is wrapped around
## returns: Number of cells around the provided position in the previous grid
func _get_alive_around(x: int, y: int) -> int:
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
				
	return alive_around


func _grid_properties_changed() -> void:
	super._grid_properties_changed()
	
	_previous_states = _states.duplicate()
	set_state_at(30, 30, true)
	set_state_at(30, 31, true)
	set_state_at(29, 30, true)
	set_state_at(28, 30, true)
	set_state_at(27, 30, true)