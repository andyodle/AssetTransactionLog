extends Control

signal DeleteClicked;
signal EditClicked;

onready var edit_button = $MarginContainer/HBoxContainer/EditButton;
onready var delete_button = $MarginContainer/HBoxContainer/DeleteButton;

# Show and hide action buttons.
func show_buttons(visible_p):
	edit_button.visible = visible_p;
	delete_button.visible = visible_p;

# Delete Clicked
func _on_BaseIconButton_pressed():
	emit_signal("DeleteClicked");

# Edit Clicked
func _on_EditButton_pressed():
	emit_signal("EditClicked");
