extends "res://Scripts/DialogWindow.gd"

signal AddSellTransaction;

onready var number_of_coins = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/MarginContainer/NumberOfCoins;
onready var total_coins_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/TotalCoins
onready var total_amount_paid_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/TotalAmountPaid;
onready var cost_average_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/CostAverage;
onready var total_profit_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/TotalProfit;
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

func calculate_total_gain():
	# Purchased Data
	var purchased_total_price : float;
	purchased_total_price = float(total_amount_paid_data_panel.get_data());
	var purchased_number_of_coins : float;
	purchased_number_of_coins = float(total_coins_data_panel.get_data());
	var purchased_cost_average : float;
	purchased_cost_average = float(cost_average_data_panel.get_data());
	
	# Sold Data
	var sold_exchange_rate : float;
	var sold_number_of_coins : float = float(number_of_coins.text);
	
	# Left Over Data
	var total_gains : float;
	var left_over_number_of_coins : float;
	var left_over_exchange_rate : float;
	
	# Make sure we have some coins.
	if sold_number_of_coins != 0:
		sold_exchange_rate = purchased_total_price / sold_number_of_coins;
		
		# Calcualte Possible Gains
		left_over_number_of_coins = purchased_number_of_coins - sold_number_of_coins;
		left_over_exchange_rate = sold_exchange_rate;
		total_gains = left_over_number_of_coins * left_over_exchange_rate;
		
		# Display the total gains.
		total_profit_data_panel.set_data(String("$" + "%3.2f" % total_gains));

# User entered a number recalulate the possilbe gains.
func _on_NumberOfCoins_text_changed():
	# Validate the input text.
	# Calculate the total possible gain.
	calculate_total_gain();
	pass
