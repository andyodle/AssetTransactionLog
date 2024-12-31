extends Control

@export var enable_text : String = "Bought"
@export var disable_text : String = "Sold"

@onready var check_button = $MarginContainer/CheckButton;

func _ready():
	set_checked(check_button.button_pressed);


func set_checked(checked_p:bool):
	check_button.button_pressed = checked_p;
	if checked_p:
		check_button.text = enable_text
	else:
		check_button.text = disable_text

func get_checked():
	return check_button.button_pressed;

func set_focus():
	# Set Focus on First Control
	if check_button:
		check_button.grab_focus.call_deferred();

func _on_check_button_toggled(toggled_on):
	set_checked(toggled_on)
