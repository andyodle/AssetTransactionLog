extends Control

signal ActiveTransClicked;
signal ProfitTransClicked;
signal SoldPositionsTransClicked;
signal NewTransClicked;
signal LoadTransClicked;
signal SaveTrasnClicked;
signal SettingsClicked;

func toggle_tab_buttons(active_button_p):
	var navigation_buttons = get_tree().get_nodes_in_group("NavigationButton");
	for navigation_button in navigation_buttons:
		if navigation_button.name != active_button_p:
			navigation_button.button_pressed = false;

# Active Tab Clicked
func _on_ActiveTransButton_pressed():
	toggle_tab_buttons("ActiveTransButton");
	emit_signal("ActiveTransClicked");

# New Transaction Log Clicked
func _on_NewTransButton_pressed():
	emit_signal("NewTransClicked");

# Load Transactions Button Clicked
func _on_LoadTransButton_pressed():
	emit_signal("LoadTransClicked");

# Save Transactions Button Clicked
func _on_SaveTransButton_pressed():
	emit_signal("SaveTrasnClicked");

# Settings Button Clicked
func _on_SettingsButton_pressed():
	toggle_tab_buttons("SettingsButton");
	emit_signal("SettingsClicked");
