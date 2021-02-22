extends Control

onready var total_coins_data_panel = $HBoxContainer/VBoxContainer/HBoxContainer/TotalCoins;
onready var total_amount_paid_data_panel = $HBoxContainer/VBoxContainer/HBoxContainer/TotalAmountPaid;
onready var cost_average_data_panel = $HBoxContainer/VBoxContainer/HBoxContainer/CostAverage;
onready var transaction_log = $HBoxContainer/VBoxContainer/TransactionLog;
onready var add_trans_dialog = $AddTransaction;

# User wants to add a new transaction.
func _on_TransactionLog_AddTransactionClick():
	# Step 1: Show the add transaction dialog.
	add_trans_dialog.fade_in();

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

# Cost average was calcualted. Refresh your data.
func _on_TransactionLog_CalculateCostAverage(cost_average_p):
	if cost_average_data_panel != null:
		cost_average_data_panel.set_data(String("$" + "%3.2f" % cost_average_p));

# Add a new transaction.
func _on_AddTransaction_AddNewTransaction(transaction_p):
	# Step 2: Add the transaction to the transaction log.
	transaction_log.add_transaction(transaction_p);
	
	# Step 3: Recalulate the displayed totals.
	transaction_log.calcualte_total_coins();
	transaction_log.calculate_total_price();
	transaction_log.calcualte_cost_average();
