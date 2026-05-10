extends VBoxContainer

## Signal emitted when the start button is pressed
signal start_button_pressed
## Signal emitted when the stop button is pressed
signal stop_button_pressed
## Signal emitted when the pause button is pressed
signal pause_button_pressed
## Signal emitted when the resume button is pressed
signal resume_button_pressed

@onready var running_buttons: Control = $RunningButtons
@onready var start_button: Control = $StartButton
@onready var pause_button: Button = $RunningButtons/PauseButton
@onready var resume_button: Button = $RunningButtons/ResumeButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Only the start button should be visible at the start
	start_button.visible = true
	running_buttons.visible = false
	
	pause_button.disabled = false
	resume_button.disabled = true

func _on_start_button_pressed() -> void:
	# Show only the running buttons
	running_buttons.visible = true
	start_button.visible = false
	start_button_pressed.emit()


func _on_stop_button_pressed() -> void:
	# Return back to the start button
	running_buttons.visible = false
	start_button.visible = true
	stop_button_pressed.emit()


func _on_pause_button_pressed() -> void:
	# Game should be pause at this moment, so it needs resuming
	pause_button.disabled = true
	resume_button.disabled = false
	pause_button_pressed.emit()


func _on_resume_button_pressed() -> void:
	# Game should be running from this moment, so it can be paused
	pause_button.disabled = false
	resume_button.disabled = true
	resume_button_pressed.emit()
