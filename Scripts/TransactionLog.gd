extends Control

signal AddTransactionClick;
signal CalcualteSellClick;
signal CalculatedNumberOfCoins;

onready var transaction_list = $MarginContainer/VBoxContainer/ScrollContainer/Trasactions;

var transaction_view = preload("res://Scenes/Controls/TransactionView.tscn");

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

func add_transaction():
	var temp_trans_view = transaction_view.instance();
	transaction_list.add_child(temp_trans_view);
	
	# date_acquired_p
	# number_of_coins_p
	# exchange_price_p
	# credit_amount_p
	# debit_amount_p
	var temp_class : Transaction;
	temp_class = load("res://Scripts/Autoload/Transaction.gd").new();
	temp_class.set_trans_data("02/17/2021", 0.001920220, 52077.37, 100.00, true);
	temp_trans_view.set_tras_data(temp_class);
	
	temp_trans_view = transaction_view.instance();
	transaction_list.add_child(temp_trans_view);
	temp_class = load("res://Scripts/Autoload/Transaction.gd").new();
	temp_class.set_trans_data("02/17/2021", 0.000020220, 52859.43, 75.00, false);
	temp_trans_view.set_tras_data(temp_class);

# User wants to add a new transaction.
func _on_AddTransactonButton_pressed():
	emit_signal("AddTransactionClick");

# User wants to calcualte a sell.
func _on_CalculateSellButton_pressed():
	emit_signal("CalcualteSellClick");
