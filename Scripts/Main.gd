extends Control

onready var total_coins_data_panel = $HBoxContainer/VBoxContainer/HBoxContainer/TotalCoinsDataPanel;
onready var transaction_log = $HBoxContainer/VBoxContainer/TransactionLog;

# User wants to add a new transaction.
func _on_TransactionLog_AddTransactionClick():
	transaction_log.add_transaction();
	transaction_log.calcualte_total_coins();

# User wants to calcualte a sell.
func _on_TransactionLog_CalcualteSellClick():
	pass # Replace with function body.

# Number of coins was calculated. Refresh your data.
func _on_TransactionLog_CalculatedNumberOfCoins(number_of_coins_p):
	if total_coins_data_panel != null:
		total_coins_data_panel.set_data(number_of_coins_p);
