extends Control

onready var selected_trans = $CenterContainer/VBoxContainer/HBoxContainer/SelectedTrans;
onready var date_sold = $CenterContainer/VBoxContainer/HBoxContainer/DateSold;
onready var number_of_coins = $CenterContainer/VBoxContainer/HBoxContainer/NumberOfCoins;
onready var exchange_paid = $CenterContainer/VBoxContainer/HBoxContainer/ExchangePaid;
onready var total_paid = $CenterContainer/VBoxContainer/HBoxContainer/TotalPaid;
onready var exchange_sold = $CenterContainer/VBoxContainer/HBoxContainer/ExchangeSold;
onready var total_sold = $CenterContainer/VBoxContainer/HBoxContainer/TotalSold;
onready var total_gains = $CenterContainer/VBoxContainer/HBoxContainer/TotalGains;
onready var percent_gains = $CenterContainer/VBoxContainer/HBoxContainer/PercentGains;

var trans_data = null;

func _ready():
	clear_data();

func clear_data():
	date_sold.text = "";
	number_of_coins.text = "";
	exchange_paid.text = "";
	total_paid.text = "";
	exchange_sold.text = "";
	total_sold.text = "";
	total_gains.text = "";
	percent_gains.text = "";

# Fill out the transaction.
func set_tras_data(sold_transaction_p):
	trans_data = sold_transaction_p;
	# Date Sold
	if trans_data.date_m != null:
		date_sold.text = String(trans_data.date_m);
	# Number of Coins
	number_of_coins.text = String("%10.9f" % trans_data.number_of_coins_m);
	# Exchange Paid
	exchange_paid.text = String("$" + "%3.2f" % trans_data.exchange_paid_m);
	# Total Paid
	total_paid.text = String("$" + "%3.2f" % trans_data.total_paid_m);
	# Exchange Sold
	exchange_sold.text = String("$" + "%3.2f" % trans_data.exchange_sold_m);
	# Total Sold
	total_sold.text = String("$" + "%3.2f" % trans_data.total_sold_m);
	# Total Gains
	total_gains.text = String("$" + "%3.2f" % trans_data.total_gains_m);
	# Percent Gains
	percent_gains.text = String("%3.2f" % trans_data.percent_gains_m) +  "%";

# Flag to check if a row was selected.
func is_selected():
	return selected_trans.pressed;
