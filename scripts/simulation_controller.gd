extends Node2D

@onready var _updater: WorldStateHolder = $Grid/Updater
@onready var _drawer: WorldStateHolder = $Grid/Drawer
@onready var _visualizer: GridVisualizer = $Grid/Visualizer
@onready var _timer: Timer = $UpdateTimer

func _ready() -> void:
	_visualizer.change_state_holder(_drawer)

func _on_start_button_pressed() -> void:
	_updater.copy_states_from(_drawer)
	_visualizer.change_state_holder(_updater)
	_timer.start()


func _on_stop_button_pressed() -> void:
	_visualizer.change_state_holder(_drawer)
	_timer.stop()


func _on_pause_button_pressed() -> void:
	_timer.stop()


func _on_resume_button_pressed() -> void:
	_timer.start()
