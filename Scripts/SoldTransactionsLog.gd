extends Control

signal AddTransactionClick;
signal CalcualteSellClick;
signal CalculatedTotalGains;
signal CalculatedNumberOfCoins;
signal CalcualtedTotalPrice;
signal CalculatedCostAverage;

onready var transaction_list = $MarginContainer/VBoxContainer/ScrollContainer/Trasactions;

var sold_transaction_view = preload("res://Scenes/Controls/SoldTransactionView.tscn");

# Clear added transactions.
func reset_trasactoins():
	for transaction in transaction_list.get_children():
		transaction_list.remove_child(transaction);

# Calcualte the totals for the data panels.
func calculate_toals():
	# Total Gains
	var total_gains = Utility.calculate_total_gains(transaction_list);
	emit_signal("CalculatedTotalGains", total_gains);
	
	# Total Price
	#var total_price = Utility.calculate_total_price(transaction_list);
	#emit_signal("CalcualtedTotalPrice", total_price);
	
	# Cost Average
	#var cost_average = Utility.calcualte_cost_average(transaction_list);
	#emit_signal("CalculatedCostAverage", cost_average);

# Remove the selected transaction.
func remove_selected_transactions():
	for transaction in transaction_list.get_children():
		if transaction.is_selected():
			transaction_list.remove_child(transaction);

func add_transaction(sold_transaction_p):
	var temp_sold_trans_view = sold_transaction_view.instance();
	transaction_list.add_child(temp_sold_trans_view);
	transaction_list.move_child(temp_sold_trans_view, 0);
	
	# Add the transaction to the list.
	temp_sold_trans_view.set_tras_data(sold_transaction_p);

# User wants to add a new transaction.
func _on_ActionButtonContainer_AddTransClicked():
	emit_signal("AddTransactionClick");

# User wants to calcualte a sell.
func _on_ActionButtonContainer_CalcualteSellClicked():
	emit_signal("CalcualteSellClick");


# User wants to delete selected items.
func _on_ActionButtonContainer_DeleteClicked():
	# Remove the selected items.
	remove_selected_transactions();
	
	# Recalculate the data panels.
	calculate_toals();
