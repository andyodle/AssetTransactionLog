extends "res://Scripts/DialogWindow.gd"

signal AddSellTransaction;

onready var number_of_coins = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/MarginContainer/NumberOfCoins;
onready var total_coins_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/TotalCoins
onready var total_amount_paid_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/TotalAmountPaid;
onready var cost_average_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/CostAverage;
onready var transaction_log = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/TransactionLog;

func reset_dialog():
	total_coins_data_panel.set_data("");
	total_amount_paid_data_panel.set_data("");
	cost_average_data_panel.set_data("");
	transaction_log.reset_trasactoins();

# Add selected transactions to the sell log.
func add_sell_transaction(transaction_p):
	transaction_log.add_transaction(transaction_p);
	
	# Recalulate the displayed totals.
	transaction_log.calcualte_total_coins();
	transaction_log.calculate_total_price();
	transaction_log.calcualte_cost_average();

# Check to see if the user entered valid data.
# Return true if valid input else false.
func verify_input():
	var valid_input = true;
	
	# Number of Coins
	if(number_of_coins.text == ""):
		valid_input = false;
	
	return valid_input;

# Number of coins was calculated. Refresh your data.
func _on_TransactionLog_CalculatedNumberOfCoins(number_of_coins_p):
	if total_coins_data_panel != null:
		total_coins_data_panel.set_data(String("%10.9f" % number_of_coins_p));
		
# Calculated total price. Refresh your data.
func _on_TransactionLog_CalcualteTotalPrice(amount_paid_p):
	if total_amount_paid_data_panel != null:
		total_amount_paid_data_panel.set_data(String("$" + "%3.2f" % amount_paid_p));

# Cost average was calcualted. Refresh your data.
func _on_TransactionLog_CalculateCostAverage(cost_average_p):
	if cost_average_data_panel != null:
		cost_average_data_panel.set_data(String("$" + "%3.2f" % cost_average_p));

# Add new sell transactoin to the proper places.
func _on_DialogActionButtons_OkClicked():
	if verify_input():
		#TODO: Send the transaction in the signal.
		emit_signal("AddSellTransaction", "");
		self.fade_out();

# Cancel adding a sell transaction.
func _on_DialogActionButtons_CancelClicked():
	self.fade_out();
