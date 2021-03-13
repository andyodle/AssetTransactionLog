extends Control

signal SelectAll;

# Attempt to select all of the transactions.
func _on_SelectAll_toggled(button_pressed_p):
	emit_signal("SelectAll", button_pressed_p);
