extends TextureButton

signal SoldSelectedTransaction;

@onready var background_color = %BackgroundColor;
@onready var selected_trans = %SelectedTrans;
@onready var date_sold = %DateSold;
@onready var number_of_coins = %NumberOfCoins;
@onready var exchange_paid = %ExchangePaid;
@onready var total_paid = %TotalPaid;
@onready var exchange_sold = %ExchangeSold;
@onready var total_sold = %TotalSold;
@onready var total_gains = %TotalGains;
@onready var percent_gains = %PercentGains;
@onready var transaction_list = %Transactions;

var trans_data = null;
var transaction_selected = false;

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
	transaction_selected = false;

# Fill out the transaction.
func set_tras_data(sold_transaction_p):
	trans_data = sold_transaction_p;
	# Date Sold
	if trans_data.date_m != null:
		date_sold.text = trans_data.date_m;
	# Number of Coins
	number_of_coins.text = Utility.format_decimal("", trans_data.number_of_coins_m);
	# Exchange Paid
	exchange_paid.text = "$" + Utility.format_decimal("%3.2f", trans_data.exchange_paid_m);
	# Total Paid
	total_paid.text = "$" + Utility.format_decimal("%3.2f", trans_data.amount_m);
	# Exchange Sold
	exchange_sold.text = "$" + Utility.format_decimal("%3.2f", trans_data.exchange_sold_m);
	# Total Sold
	total_sold.text = "$" + Utility.format_decimal("%3.2f", trans_data.total_sold_m);
	# Total Gains
	total_gains.text = "$" + Utility.format_decimal("%3.2f", trans_data.total_gains_m);
	# Percent Gains
	percent_gains.text = Utility.format_decimal("%3.2f", trans_data.percent_gains_m) + "%";

# Add and keep track of transactions that make up the sold transaction.
func add_transaction(transaction_p):
	var transaction_view = load("res://Scenes/Controls/TransactionView.tscn");
	var temp_trans_view = transaction_view.instantiate();
	transaction_list.add_child(temp_trans_view);
	transaction_list.move_child(temp_trans_view, 0);
	
	# Add the transaction to the list.
	temp_trans_view.set_tras_data(transaction_p);

# Flag to check if a row was selected.
func is_selected():
	return transaction_selected;

# Select a transaction.
func select_transaction(is_selected_p):
	background_color.visible = is_selected_p;
	selected_trans.button_pressed = is_selected_p;
	transaction_selected = is_selected_p;

# Selected the individual transaction.
func _on_SelectedTrans_toggled(button_pressed_p):
	emit_signal("SoldSelectedTransaction", button_pressed_p);

# User clicked on whole row.
func _on_pressed():
	select_transaction(!transaction_selected);
