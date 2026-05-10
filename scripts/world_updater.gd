extends WorldStateHolder

## Array that contains the internal state of the world cells
var _previous_states: Array[bool]
## Array that contains shifts that allows getting to the closest neighbor
static var _around_shifts: Array[Vector2i] = [
	Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(-1, 0), Vector2i(1, 0),
	Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)
]

var _alive_around_map: Array[int]


func _update_world_state() -> void:
	# First move the world state to the previous state array and clear the current state
	_previous_states = _states
	_states = []
	_states.resize(_previous_states.size())
	
	_alive_around_map = []
	_alive_around_map.resize(_previous_states.size())
	_fill_alive_around_map()
	
	## Go through all cells in the grid and update their state
	for y in range(0, properties.dimensions.y):
		for x in range(0, properties.dimensions.x):
			var alive: bool = _should_be_alive_at(x, y)
			set_state_at(x, y, alive)
			
	world_state_changed.emit()
	
	
## Checks if the cell was alive at the given grid position in the previous interation
## returns: True, if the cell was alive. False otherwise
func get_state_at_previous(x: int, y: int) -> bool:
	return _previous_states[_get_array_position(x, y)]


## Determines if the cell at the given coordinates should be alive in the next iteration
func _should_be_alive_at(x: int, y: int) -> bool:
	var array_index: int = _get_array_position(x, y)
	var alive_around: int = _alive_around_map[array_index]
	var self_alive: bool = _previous_states[array_index]
	
	if not self_alive and alive_around == 3:
		return true
	elif self_alive and alive_around >= 2 and alive_around <= 3:
		return true
		
	return false
	
	
## Fills the alive around map. The filling process happens only when the given cell is alive.
## This improves the execution speed skipping interations for every dead cell.
func _fill_alive_around_map() -> void:
	for y in range(properties.dimensions.y):
		for x in range(properties.dimensions.x):
			# Fill around positions only when this cell is alive
			if not get_state_at_previous(x, y):
				continue
		
			_increase_around_at(x, y)
				

## Increases value stored in the [_alive_around_map] for cells around the given grid position.
func _increase_around_at(x: int, y: int) -> void:
	for shift in _around_shifts:
		var neighbor_x: int = _wrap_around(x + shift.x, 0, properties.dimensions.x - 1)
		var neighbor_y: int = _wrap_around(y + shift.y, 0, properties.dimensions.y - 1)
		var index: int = _get_array_position(neighbor_x, neighbor_y)
		_alive_around_map[index] += 1

## Wraps around the provided [param value].
## returns: [param value] if it is between [param min_value] and [param max_value]. Otherwise wraps it around the 
## proper side. 
func _wrap_around(value: int, min_value: int, max_value: int) -> int:
	if value < min_value:
		return max_value - (min_value - value) + 1
	elif value > max_value:
		return min_value + (value - max_value) - 1
		
	return value


func _grid_properties_changed() -> void:
	super._grid_properties_changed()
	
	_previous_states = _states.duplicate()
	set_state_at(30, 30, true)
	set_state_at(30, 31, true)
	set_state_at(29, 30, true)
	set_state_at(28, 30, true)
	set_state_at(27, 30, true)