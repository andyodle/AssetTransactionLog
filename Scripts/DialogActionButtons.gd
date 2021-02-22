extends Control

signal OkClicked;
signal CancelClicked;

# Ok button was pressed.
func _on_OkButton_pressed():
	emit_signal("OkClicked");

# Cancel button was pressed.
func _on_CancelButton_pressed():
	emit_signal("CancelClicked");
