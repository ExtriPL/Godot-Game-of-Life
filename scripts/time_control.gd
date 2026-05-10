extends HBoxContainer

## Timer controlled by this node
@export var timer: Timer
## Time interval corresponding to the x1 setting
@export var base_time_interval: float


func _ready() -> void:
	# The time buttons are hidden by default
	_hide_time_buttons()


## Changes the time interval used by the timer. New interval will be equal to 
## [base_time_interval] * [param override_value].
func override_time(override_value: float) -> void:
	timer.wait_time = base_time_interval / override_value
	
	
## Enables all time buttons
func _enable_time_buttons() -> void:
	_change_time_buttons_disabled(false)
	

## Disables all time buttons
func _disable_time_buttons() -> void:
	_change_time_buttons_disabled(true)
	
	
func _show_time_buttons() -> void:
	visible = true
	_enable_time_buttons()
	
	
func _hide_time_buttons() -> void:
	visible = false
	_disable_time_buttons()
	

## Changes the disabled state of the time buttons
## [param disabled] - should the buttons be disabled?	
func _change_time_buttons_disabled(disabled: bool) -> void:
	for child in get_children(true):
		if child is not Button:
			continue
			
		var time_button: Button = child as Button
		time_button.disabled = disabled
