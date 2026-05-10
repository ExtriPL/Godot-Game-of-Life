@abstract
class_name WorldStateHolder
extends Node

## Properties of a grid this class holds
@export var properties: GridProperties

var _states: Array[bool]

func _ready() -> void:
	_grid_properties_changed()
	
## Checks if the cell is alive at the given grid position
## returns: True, if the cell is alive. False otherwise
func get_state_at(x: int, y: int) -> bool:
	return _states[_get_array_position(x, y)]
	
	
## Sets state of the cell at the given grid position
func set_state_at(x: int, y: int, state: bool) -> void:
	_states[_get_array_position(x, y)] = state
	
## Converts grid coordinates into internal array representation's position
## returns: Index inside the [_alive_states] array
func _get_array_position(x: int, y: int) -> int:
	return y * properties.dimensions.x + x
	

func _grid_properties_changed() -> void:
	var cell_count: int = properties.dimensions.x * properties.dimensions.y
	_states = []
	_states.resize(cell_count)
	_states.fill(false)
