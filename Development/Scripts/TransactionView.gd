extends Control

signal SelectedTransaction;

@onready var background_color = %BackgroundColor;
@onready var date_acquired = %DateAcquired;
@onready var number_of_coins = %NumberOfCoins;
@onready var exchange_price = %ExchangePrice;
@onready var credit_amount = %CreditAmount;
@onready var debit_amount = %DebitAmount;
@onready var selected_trans = %SelectedTrans;

var trans_data = null;

func _ready():
	clear_data();

func clear_data():
	date_acquired.text = "";
	number_of_coins.text = "";
	exchange_price.text = "";
	credit_amount.text = "";
	debit_amount.text = "";

# Fill out the transaction.
func set_tras_data(transaction_p):
	trans_data = transaction_p;
	if transaction_p.date_m != null:
		date_acquired.text = String(transaction_p.date_m);
	number_of_coins.text = Utility.format_decimal("", transaction_p.number_of_coins_m);
	exchange_price.text = "$" + Utility.format_decimal("%3.2f", transaction_p.exchange_price_m);
	if(transaction_p.is_credit_m == true):
		credit_amount.text = "$" + Utility.format_decimal("%3.2f", transaction_p.amount_m);
	else:
		debit_amount.text = "$" + Utility.format_decimal("%3.2f", transaction_p.amount_m);

# Get the number of coins for the current transaction.
func get_number_of_coins():
	return trans_data.number_of_coins_m;

# Get the amount paid.
func get_amount_paid():
	return trans_data.amount_m;

# Flag to check if a row was selected.
func is_selected():
	return selected_trans.button_pressed;

# Get weither the transaction is a credit or debit.
func is_credit_trans():
	return trans_data.is_credit_m;

# Select a transaction.
func select_transaction(is_selected_p):
	background_color.visible = is_selected_p;
	selected_trans.button_pressed = is_selected_p;

# Selected the individual transaction.
func _on_SelectedTrans_toggled(button_pressed_p):
	emit_signal("SelectedTransaction", button_pressed_p);

# User clicked on the whole row.
func _on_CenterContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select_transaction(!selected_trans.button_pressed);
