extends Control

signal ActiveTransClicked;
signal ProfitTransClicked;
signal SoldPositionsTransClicked;
signal LoadTransClicked;
signal SaveTrasnClicked;

func toggle_tab_buttons(active_button_p):
	var navigation_buttons = get_tree().get_nodes_in_group("NavigationButton");
	for navigation_button in navigation_buttons:
		if navigation_button.name != active_button_p:
			navigation_button.pressed = false;

# Active Tab Clicked
func _on_ActiveTransButton_pressed():
	toggle_tab_buttons("ActiveTransButton");
	emit_signal("ActiveTransClicked");

# Profit Tab Clicked
func _on_ProfitTransButton_pressed():
	toggle_tab_buttons("ProfitTransButton");
	emit_signal("ProfitTransClicked");

# Sold Position Tab Clicked
func _on_SoldPositionsTransButton_pressed():
	toggle_tab_buttons("SoldPositionsTransButton");
	emit_signal("SoldPositionsTransClicked");

# Load Transactions Button Clicked
func _on_LoadTransButton_pressed():
	emit_signal("LoadTransClicked");

# Save Transactions Button Clicked
func _on_SaveTransButton_pressed():
	emit_signal("SaveTrasnClicked");
