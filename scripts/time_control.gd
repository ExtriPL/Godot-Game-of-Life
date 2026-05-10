extends HBoxContainer

## Timer controlled by this node
@export var timer: Timer
## Time interval corresponding to the x1 setting
@export var base_time_interval: float


## Changes the time interval used by the timer. New interval will be equal to 
## [base_time_interval] * [param override_value].
func override_time(override_value: float) -> void:
	timer.wait_time = base_time_interval / override_value