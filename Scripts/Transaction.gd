extends Control

onready var date_acquired = $CenterContainer/VBoxContainer/HBoxContainer/DateAcquired;
onready var number_of_coins = $CenterContainer/VBoxContainer/HBoxContainer/NumberOfCoins;
onready var exchange_price = $CenterContainer/VBoxContainer/HBoxContainer/ExchangePrice;
onready var credit_amount = $CenterContainer/VBoxContainer/HBoxContainer/CreditAmount;
onready var debit_amount = $CenterContainer/VBoxContainer/HBoxContainer/DebitAmount;

func set_tras_data(date_acquired_p, number_of_coins_p, exchange_price_p, credit_amount_p, debit_amount_p):
	date_acquired.text = date_acquired_p;
	number_of_coins.text = number_of_coins_p;
	exchange_price.text = exchange_price_p;
	credit_amount.text = credit_amount_p;
	debit_amount.text = debit_amount_p;
