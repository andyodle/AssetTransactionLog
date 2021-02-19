extends Control

signal ButtonClicked;

# Button was pressed by the user.
func _on_TextureButton_pressed():
	emit_signal("ButtonClicked");
