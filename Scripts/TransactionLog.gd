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

# Calcualte the total number of coins acquired.
func calcualte_total_coins():
	# Get all of the coin transactions.
	var coin_count : float = 0.0;
	var transaction_views = transaction_list.get_children();
	for transaction_view in transaction_views:
		if transaction_view.is_credit_trans():
			coin_count += transaction_view.get_number_of_coins();
		else:
			coin_count -= transaction_view.get_number_of_coins();
	emit_signal("CalculatedNumberOfCoins", coin_count);

# Calcualte the total price paid for the coins.
func calculate_total_price():
	# Get all of the price transactions.
	var total_price : float = 0.0;
	var transaction_views = transaction_list.get_children();
	for transaction_view in transaction_views:
		if transaction_view.is_credit_trans():
			total_price += transaction_view.get_amount_paid();
		else:
			total_price -= transaction_view.get_amount_paid();
	emit_signal("CalcualteTotalPrice", total_price);

# Calcualte the cost average of the purchased coins.
func calcualte_cost_average():
	# Get all of the price transactions.
	var total_price : float = 0.0;
	var coin_count : float = 0.0;
	var cost_average : float = 0.0;
	var transaction_views = transaction_list.get_children();
	for transaction_view in transaction_views:
		if transaction_view.is_credit_trans():
			total_price += transaction_view.get_amount_paid();
			coin_count += transaction_view.get_number_of_coins();
		else:
			total_price -= transaction_view.get_amount_paid();
			coin_count -= transaction_view.get_number_of_coins();
	if coin_count != 0:
		cost_average = (total_price / coin_count);
	emit_signal("CalculateCostAverage", cost_average);

func add_transaction(transaction_p):
	var temp_trans_view = transaction_view.instance();
	transaction_list.add_child(temp_trans_view);
	transaction_list.move_child(temp_trans_view, 0);
	
	# Add the transaction to the list.
	temp_trans_view.set_tras_data(transaction_p);

# User wants to add a new transaction.
func _on_ActionButtonContainer_AddTransClicked():
	emit_signal("AddTransactionClick");

# User wants to calcualte a sell.
func _on_ActionButtonContainer_CalcualteSellClicked():
	emit_signal("CalcualteSellClick");
