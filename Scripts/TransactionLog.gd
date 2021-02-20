extends Control

signal AddTransactionClick;
signal CalcualteSellClick;
signal CalculatedNumberOfCoins;
signal CalcualteTotalPrice;
signal CalculateCostAverage;

onready var transaction_list = $MarginContainer/VBoxContainer/ScrollContainer/Trasactions;

var transaction_view = preload("res://Scenes/Controls/TransactionView.tscn");

# Calcualte the total number of coins acquired.
func calcualte_total_coins():
	# Get all of the coin transactions.
	var coin_count : float = 0.0;
	var transaction_views = get_tree().get_nodes_in_group("Transaction");
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
	var transaction_views = get_tree().get_nodes_in_group("Transaction");
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
	var transaction_views = get_tree().get_nodes_in_group("Transaction");
	for transaction_view in transaction_views:
		if transaction_view.is_credit_trans():
			total_price += transaction_view.get_amount_paid();
			coin_count += transaction_view.get_number_of_coins();
		else:
			total_price -= transaction_view.get_amount_paid();
			coin_count -= transaction_view.get_number_of_coins();
	var cost_average = (total_price / coin_count);
	emit_signal("CalculateCostAverage", cost_average);

func add_transaction():
	var temp_trans_view = transaction_view.instance();
	transaction_list.add_child(temp_trans_view);
	
	# Trade 1
	var temp_class : Transaction;
	temp_class = load("res://Scripts/Autoload/Transaction.gd").new();
	temp_class.set_trans_data("02/17/2021", 0.001932000, 51759.83, 100.00, true);
	temp_trans_view.set_tras_data(temp_class);
	
	# Trade 2
	temp_trans_view = transaction_view.instance();
	transaction_list.add_child(temp_trans_view);
	temp_class = load("res://Scripts/Autoload/Transaction.gd").new();
	temp_class.set_trans_data("02/17/2021", 0.001928520, 51853.23, 100, true);
	temp_trans_view.set_tras_data(temp_class);

# User wants to add a new transaction.
func _on_AddTransactonButton_pressed():
	emit_signal("AddTransactionClick");

# User wants to calcualte a sell.
func _on_CalculateSellButton_pressed():
	emit_signal("CalcualteSellClick");
