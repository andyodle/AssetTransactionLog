extends Control

signal AddTransClicked;
signal CalcualteSellClicked;
signal DeleteClicked;

# Add transaction clicked.
func _on_AddTransactonButton_ButtonClicked():
	emit_signal("AddTransClicked");

# Calcualte sell clicked.
func _on_CalculateSellButton_ButtonClicked():
	emit_signal("CalcualteSellClicked");

# Delete clicked.
func _on_BaseIconButton_pressed():
	emit_signal("DeleteClicked");
