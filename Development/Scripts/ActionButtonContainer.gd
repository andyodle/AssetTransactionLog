extends Control

signal CalcualteSellClicked;
signal DeleteClicked;
signal EditClicked;

# Calcualte sell clicked.
func _on_CalculateSellButton_ButtonClicked():
	emit_signal("CalcualteSellClicked");

# Delete Clicked
func _on_BaseIconButton_pressed():
	emit_signal("DeleteClicked");

# Edit Clicked
func _on_EditButton_pressed():
	emit_signal("EditClicked");
