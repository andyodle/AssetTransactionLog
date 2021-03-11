extends Control

signal SelectAll;

# User selected all.
func _on_SelectAll_toggled(button_pressed_p):
	emit_signal("SelectAll", button_pressed_p);
