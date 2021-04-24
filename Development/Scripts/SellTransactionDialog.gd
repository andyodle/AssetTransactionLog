extends "res://Scripts/DialogWindow.gd"

signal AddSellTransaction;

onready var number_of_coins = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxInputContainer/NumberOfCoins;
onready var transaction_amount = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxInputContainer/AmountToSell;
onready var total_coins_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/TotalCoins
onready var total_amount_paid_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/TotalAmountPaid;
onready var cost_average_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/CostAverage;
onready var total_profit_data_panel = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/TotalProfit;
onready var transaction_log = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/TransactionLog;

var sold_transactoin_class = preload("res://Scripts/Classes/SoldTransaction.gd").new();

func reset_dialog():
	number_of_coins.text = "";
	total_coins_data_panel.reset_data_panel();
	total_amount_paid_data_panel.reset_data_panel();
	cost_average_data_panel.reset_data_panel();
	total_profit_data_panel.reset_data_panel();
	transaction_log.reset_trasactoins();

# Add selected transactions to the sell log.
func add_sell_transaction(transaction_p):
	transaction_log.add_transaction(transaction_p, true);
	
	# Recalulate the displayed totals.
	transaction_log.calculate_toals();

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
		total_coins_data_panel.set_data(number_of_coins_p);
		
# Calculated total price. Refresh your data.
func _on_TransactionLog_CalcualteTotalPrice(amount_paid_p):
	if total_amount_paid_data_panel != null:
		# Prefill the amount paid.
		transaction_amount.set_input_value(amount_paid_p);
		total_amount_paid_data_panel.set_data(amount_paid_p);

# Cost average was calcualted. Refresh your data.
func _on_TransactionLog_CalculateCostAverage(cost_average_p):
	if cost_average_data_panel != null:
		cost_average_data_panel.set_data(cost_average_p);

# Add new sell transactoin to the proper places.
func _on_DialogActionButtons_OkClicked():
	if verify_input():
		emit_signal("AddSellTransaction", sold_transactoin_class);
		self.fade_out();

# Cancel adding a sell transaction.
func _on_DialogActionButtons_CancelClicked():
	self.fade_out();

func calculate_total_gain():
	# Double Custom Calculator
	var calculator = Calculator.new();
	
	# Purchased Data
	var purchased_total_price;
	purchased_total_price = total_amount_paid_data_panel.get_data();
	var purchased_number_of_coins;
	purchased_number_of_coins = total_coins_data_panel.get_data();
	var purchased_cost_average;
	purchased_cost_average = cost_average_data_panel.get_data();
	
	# Sold Data
	var sold_exchange_rate;
	var sold_total_price = transaction_amount.text;
	var sold_number_of_coins = number_of_coins.text;
	
	# Left Over Data
	var total_gains;
	var left_over_number_of_coins;
	var left_over_exchange_rate;
	
	# Percent Gains
	var percent_gains;
	
	# Make sure we have some coins and a transaction amount.
	if float(sold_number_of_coins) != 0 and float(sold_total_price) != 0:
		# Calcualte current exchange rate.
		sold_exchange_rate = calculator.divide(sold_total_price, sold_number_of_coins);
		
		# Calcualte Possible Gains
		left_over_number_of_coins = calculator.subtract(purchased_number_of_coins, sold_number_of_coins);
		left_over_exchange_rate = purchased_cost_average;
		
		# Check to see if we need to calculate profit by
		# number of coins or selling price.
		total_gains = calculator.subtract(sold_total_price, purchased_total_price);
		if(total_gains == "0"):
			total_gains = calculator.multiply(left_over_number_of_coins, left_over_exchange_rate);
		
		# Display the total gains.
		total_profit_data_panel.set_data(total_gains);
		
		# Calcualte Percentage Gains
		if float(purchased_total_price) != 0:
			percent_gains = calculator.multiply(calculator.divide(total_gains, purchased_total_price), "100");
			# Dispaly the total percent gains.
			total_profit_data_panel.set_percent(percent_gains);
		
		sold_transactoin_class.initalize();
		
		# Store the profit transaction.
		#sold_transactoin_class.profit_trans_m.date_m;
		sold_transactoin_class.profit_trans_m.number_of_coins_m = left_over_number_of_coins;
		sold_transactoin_class.profit_trans_m.exchange_price_m = left_over_exchange_rate;
		sold_transactoin_class.profit_trans_m.amount_m = total_gains;
		if float(total_gains) >= 0:
			sold_transactoin_class.profit_trans_m.is_credit_m = true;
		else:
			sold_transactoin_class.profit_trans_m.is_credit_m = false;
		
		# Store the sell transaction.
		#sold_transactoin_class.sold_trans_m.date_m;
		sold_transactoin_class.sold_trans_m.number_of_coins_m = sold_number_of_coins;
		sold_transactoin_class.sold_trans_m.exchange_price_m = sold_exchange_rate;
		sold_transactoin_class.sold_trans_m.amount_m = sold_total_price;
		if float(total_gains) >= 0:
			sold_transactoin_class.sold_trans_m.is_credit_m = true;
		else:
			sold_transactoin_class.sold_trans_m.is_credit_m = false;

		# Store the purchase transaction.
		#sold_transactoin_class.bought_trans_m.date_m;
		sold_transactoin_class.bought_trans_m.number_of_coins_m = purchased_number_of_coins;
		sold_transactoin_class.bought_trans_m.exchange_price_m = purchased_cost_average;
		sold_transactoin_class.bought_trans_m.amount_m = purchased_total_price;
		if float(total_gains) >= 0:
			sold_transactoin_class.bought_trans_m.is_credit_m = true;
		else:
			sold_transactoin_class.bought_trans_m.is_credit_m = false;

# User entered a number recalulate the possilbe gains.
func _on_NumberOfCoins_text_changed():
	# Validate the input text.
	# Calculate the total possible gain.
	calculate_total_gain();
	pass

# User enterd a new sell price.
func _on_AmountToSell_text_changed():
	# Calculate the total possible gain.
	calculate_total_gain();
	pass
