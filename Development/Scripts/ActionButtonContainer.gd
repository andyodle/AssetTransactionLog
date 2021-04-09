extends Control

signal DeleteClicked;
signal EditClicked;
signal SplitClicked;

onready var edit_button = $MarginContainer/HBoxContainer/EditButton;
onready var delete_button = $MarginContainer/HBoxContainer/DeleteButton;
onready var split_button = $MarginContainer/HBoxContainer/SplitButton;

# Show and hide action buttons.
func show_buttons(visible_p):
	edit_button.visible = visible_p;
	delete_button.visible = visible_p;
	split_button.visible = visible_p;

# Delete Clicked
func _on_BaseIconButton_pressed():
	emit_signal("DeleteClicked");

# Edit Clicked
func _on_EditButton_pressed():
	emit_signal("EditClicked");

# Split Clicked
func _on_SplitButton_pressed():
	emit_signal("SplitClicked");
