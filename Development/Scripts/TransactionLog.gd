extends Control

signal AddTransactionClick;
signal CalcualteSellClick;
signal CalculatedNumberOfCoins;
signal CalcualteTotalPrice;
signal CalculateCostAverage;

onready var transaction_list = $MarginContainer/VBoxContainer/ScrollContainer/Trasactions;

var transaction_view = preload("res://Scenes/Controls/TransactionView.tscn");

# Clear added transactions.
func reset_trasactoins():
	for transaction in transaction_list.get_children():
		transaction_list.remove_child(transaction);

# Calcualte the totals for the data panels.
func calculate_toals():
	# Total Coins
	var total_coins = Utility.calcualte_total_coins(transaction_list);
	emit_signal("CalculatedNumberOfCoins", total_coins);
	
	# Total Price
	var total_price = Utility.calculate_total_price(transaction_list);
	emit_signal("CalcualteTotalPrice", total_price);
	
	# Cost Average
	var cost_average = Utility.calcualte_cost_average(transaction_list);
	emit_signal("CalculateCostAverage", cost_average);

func add_transaction(transaction_p):
	var temp_trans_view = transaction_view.instance();
	transaction_list.add_child(temp_trans_view);
	transaction_list.move_child(temp_trans_view, 0);
	
	# Add the transaction to the list.
	temp_trans_view.set_tras_data(transaction_p);

# Get all of the transactions.
func get_transactions():
	var temp_views = [];
	var transaction_views = transaction_list.get_children();
	for transaction_view in transaction_views:
		temp_views.append(transaction_view);
	return temp_views;

# Get the list of selected transactions.
func get_selected_transactions():
	var temp_views = [];
	var transaction_views = transaction_list.get_children();
	for transaction_view in transaction_views:
		if transaction_view.is_selected():
			temp_views.append(transaction_view);
	return temp_views;

# Remove the selected transaction.
func remove_selected_transactions():
	for transaction in transaction_list.get_children():
		if transaction.is_selected():
			transaction_list.remove_child(transaction);

# User wants to calcualte a sell.
func _on_ActionButtonContainer_CalcualteSellClicked():
	emit_signal("CalcualteSellClick");

# User wants to delete selected items.
func _on_ActionButtonContainer_DeleteClicked():
	# Remove the selected items.
	remove_selected_transactions();
	
	# Recalculate the data panels.
	calculate_toals();

# User wants to add a new transaction.
func _on_BaseActionButton_pressed():
	emit_signal("AddTransactionClick");
