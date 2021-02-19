extends Control

onready var transactions = $VBoxContainer/ScrollContainer/Trasactions;

var transaction = preload("res://Scenes/Controls/Transaction.tscn");

func add_transaction():
	var temp_transaction = transaction.instance();
	transactions.add_child(temp_transaction);
	
		# date_acquired_p
	# number_of_coins_p
	# exchange_price_p
	# credit_amount_p
	# debit_amount_p
	temp_transaction.set_tras_data("02/18/2021", "0.001891810", "$52,859.43", "$100", "");
