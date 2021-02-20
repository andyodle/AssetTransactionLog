extends Control

onready var total_coins_data_panel = $HBoxContainer/VBoxContainer/HBoxContainer/TotalCoins;
onready var total_amount_paid_data_panel = $HBoxContainer/VBoxContainer/HBoxContainer/TotalAmountPaid;
onready var transaction_log = $HBoxContainer/VBoxContainer/TransactionLog;

# User wants to add a new transaction.
func _on_TransactionLog_AddTransactionClick():
	transaction_log.add_transaction();
	transaction_log.calcualte_total_coins();
	transaction_log.calculate_total_price();

# User wants to calcualte a sell.
func _on_TransactionLog_CalcualteSellClick():
	pass # Replace with function body.

# Number of coins was calculated. Refresh your data.
func _on_TransactionLog_CalculatedNumberOfCoins(number_of_coins_p):
	if total_coins_data_panel != null:
		total_coins_data_panel.set_data(String("%10.9f" % number_of_coins_p));

# Total price was calcualted. Refresh your data.
func _on_TransactionLog_CalcualteTotalPrice(amount_paid_p):
	if total_amount_paid_data_panel != null:
		total_amount_paid_data_panel.set_data(String("$" + "%3.2f" % amount_paid_p));
