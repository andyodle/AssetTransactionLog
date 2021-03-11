extends Control

signal DeleteClicked;
signal EditClicked;

# Delete Clicked
func _on_BaseIconButton_pressed():
	emit_signal("DeleteClicked");

# Edit Clicked
func _on_EditButton_pressed():
	emit_signal("EditClicked");
