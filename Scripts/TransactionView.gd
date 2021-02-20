extends Control

onready var date_acquired = $CenterContainer/VBoxContainer/HBoxContainer/DateAcquired;
onready var number_of_coins = $CenterContainer/VBoxContainer/HBoxContainer/NumberOfCoins;
onready var exchange_price = $CenterContainer/VBoxContainer/HBoxContainer/ExchangePrice;
onready var credit_amount = $CenterContainer/VBoxContainer/HBoxContainer/CreditAmount;
onready var debit_amount = $CenterContainer/VBoxContainer/HBoxContainer/DebitAmount;

var trans_data = null;

func _ready():
	clear_data();

func clear_data():
	date_acquired.text = "";
	number_of_coins.text = "";
	exchange_price.text = "";
	credit_amount.text = "";
	debit_amount.text = "";

func set_tras_data(transaction_p):
	trans_data = transaction_p;
	date_acquired.text = String(transaction_p.date_acquired_m);
	number_of_coins.text = String("%10.9f" % transaction_p.number_of_coins_m);
	exchange_price.text = String("$" + "%3.2f" % transaction_p.exchange_price_m);
	if(transaction_p.is_credit_m == true):
		credit_amount.text = String("$" + "%3.2f" % transaction_p.amount_m);
	else:
		debit_amount.text = String("$" + "%3.2f" % transaction_p.amount_m);

# Get the number of coins for the current transaction.
func get_number_of_coins():
	return float(trans_data.number_of_coins_m);

func get_amount_paid():
	return float(trans_data.amount_m);

# Get weither the transaction is a credit or debit.
func is_credit_trans():
	return trans_data.is_credit_m;
