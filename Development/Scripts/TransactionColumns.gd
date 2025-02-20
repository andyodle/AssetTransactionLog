extends Control

signal SelectAll;

@onready var select_all_button = $CenterContainer/HBoxContainer/SelectAll;

# User selected all.
func _on_SelectAll_toggled(button_pressed_p):
	emit_signal("SelectAll", button_pressed_p);

func clear_select_all_button():
	select_all_button.button_pressed = false;
