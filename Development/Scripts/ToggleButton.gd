extends Control

@onready var check_button = $MarginContainer/CheckButton;

func set_checked(checked_p:bool):
	check_button.button_pressed = checked_p;

func get_checked():
	return check_button.button_pressed;
