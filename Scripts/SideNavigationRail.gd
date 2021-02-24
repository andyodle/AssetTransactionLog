extends Control

signal ActiveTransClicked;
signal ProfitTransClicked;

# Active Tab Clicked
func _on_ActiveTransButton_pressed():
	emit_signal("ActiveTransClicked");

# Profit Tab Clicked
func _on_ProfitTransButton_pressed():
	emit_signal("ProfitTransClicked");
