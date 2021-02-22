extends Control

signal OkClicked;
signal CancelClicked;

# Cancel button was pressed.
func _on_CancelButton_ButtonClicked():
	emit_signal("CancelClicked");

# Ok button was pressed.
func _on_OkButton_ButtonClicked():
	emit_signal("OkClicked");
