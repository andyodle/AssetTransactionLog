extends Control

signal ButtonClicked;

# Button was pressed.
func _on_Button_pressed():
	emit_signal("ButtonClicked");
