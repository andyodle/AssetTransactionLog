extends Control

signal DeleteClicked;
signal EditClicked;
signal SplitClicked;

onready var edit_button = $MarginContainer/HBoxContainer/EditButton;
onready var delete_button = $MarginContainer/HBoxContainer/DeleteButton;
onready var split_button = $MarginContainer/HBoxContainer/SplitButton;

# Show and hide action buttons.
func show_buttons(visible_p, number_selected_p = 0):
	edit_button.visible = visible_p;
	delete_button.visible = visible_p;
	
	# Make sure only one transaction is selected.
	if number_selected_p == 1:
		split_button.visible = visible_p;
	else:
		split_button.visible = false;

# Hide indivual action buttons.
func hide_button(button_to_hide_p):
	# Hide the edit button.
	if button_to_hide_p == "edit_button":
		edit_button.visible = false;
	
	# Hide the delete button.
	if button_to_hide_p == "delete_button":
		delete_button.visible = false;
	
	# Hide the split button.
	if button_to_hide_p == "split_button":
		split_button.visible = false;

# Delete Clicked
func _on_BaseIconButton_pressed():
	emit_signal("DeleteClicked");

# Edit Clicked
func _on_EditButton_pressed():
	emit_signal("EditClicked");

# Split Clicked
func _on_SplitButton_pressed():
	emit_signal("SplitClicked");
