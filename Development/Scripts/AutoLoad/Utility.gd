extends Node

# Get the current date.
func get_current_date_str():
	var temp_date_time = OS.get_datetime();
	var date_string = String("%02d" % temp_date_time["month"]) + "/" + String("%02d" % temp_date_time["day"]) + "/" + String("%4d" % temp_date_time["year"]);
	return date_string;

# Calcualte the total number of coins acquired.
func calcualte_total_coins(transacion_list_p):
	var calculator = Calculator.new();
	# Get all of the coin transactions.
	var coin_count : String = "0.0";
	var transaction_views = transacion_list_p.get_children();
	for transaction_view in transaction_views:
		var trans_data = transaction_view.trans_data;
		coin_count = calculator.add(coin_count, trans_data.number_of_coins_m);
	
	return coin_count;

# Calcualte the total price paid for the coins.
func calculate_total_price(transacion_list_p):
	var calculator = Calculator.new();
	# Get all of the price transactions.
	var total_price : String = "0.0";
	var transaction_views = transacion_list_p.get_children();
	for transaction_view in transaction_views:
		var trans_data = transaction_view.trans_data;
		total_price = calculator.add(total_price, trans_data.amount_m);
	
	return total_price;

# Calcualte the total sold for the coins.
func calculate_total_sold_price(transacion_list_p):
	var calculator = Calculator.new();
	# Get all of the price transactions.
	var total_price : String = "0.0";
	var transaction_views = transacion_list_p.get_children();
	for transaction_view in transaction_views:
		var trans_data = transaction_view.trans_data;
		total_price = calculator.add(total_price, trans_data.total_sold_m);
	
	return total_price;

# Calcualte the cost average of the purchased coins.
func calcualte_cost_average(transacion_list_p):
	var calculator = Calculator.new();
	# Get all of the price transactions.
	var total_price : String = "0.0";
	var coin_count : String = "0.0";
	var cost_average : String = "0.0";
	var transaction_views = transacion_list_p.get_children();
	for transaction_view in transaction_views:
		var trans_data = transaction_view.trans_data;
		total_price = calculator.add(total_price, trans_data.amount_m);
		coin_count = calculator.add(coin_count, trans_data.number_of_coins_m);
	if float(coin_count) != 0:
		cost_average = calculator.divide(total_price, coin_count);
	return cost_average;

# Calcualte the total gains
func calculate_total_gains(transacion_list_p):
	var calculator = Calculator.new();
	# Get all of the price transactions.
	var total_gains : String = "";
	var transaction_views = transacion_list_p.get_children();
	for transaction_view in transaction_views:
		var trans_data = transaction_view.trans_data;
		total_gains = calculator.add(total_gains, trans_data.total_gains_m);
	
	return total_gains;

# Calculate exchange rate.
func calculate_exchange_rate(acquired_price_p, number_of_coins_p):
	var exchange_rate = "";
	if number_of_coins_p != "" and number_of_coins_p != "0" and acquired_price_p != "":
		var calculator = Calculator.new();
		exchange_rate = calculator.divide(acquired_price_p, number_of_coins_p);
	return exchange_rate;

# Calculate sold transaction.
func calculate_sold_transaction(number_of_coins_sold_p, amount_sold_p, number_of_coins_bought_p, amount_paid_p, paid_cost_average_p):
	# Double Custom Calculator
	var calculator = Calculator.new();
	
	# Initalize the sold transaction.
	var sold_transactoin_class = preload("res://Scripts/Classes/SoldTransaction.gd").new();
	sold_transactoin_class.initalize();
	
	# Purchased Data
	var purchased_total_price;
	purchased_total_price = amount_paid_p;
	var purchased_number_of_coins;
	purchased_number_of_coins = number_of_coins_bought_p;
	var purchased_cost_average;
	purchased_cost_average = paid_cost_average_p;
	
	# Sold Data
	var sold_exchange_rate;
	var sold_total_price = amount_sold_p;
	var sold_number_of_coins = number_of_coins_sold_p;
	
	# Profit Data
	var total_gains;
	var left_over_number_of_coins;
	var left_over_exchange_rate;
	
	# Make sure we have some coins and a transaction amount.
	if float(sold_number_of_coins) != 0 and float(sold_total_price) != 0:
		# Calcualte sold exchange rate.
		sold_exchange_rate = calculator.divide(sold_total_price, sold_number_of_coins);
		
		# Calcualte Possible Gains
		left_over_number_of_coins = calculator.subtract(purchased_number_of_coins, sold_number_of_coins);
		left_over_exchange_rate = paid_cost_average_p;
		
		# Check to see if we need to calculate profit by
		# number of coins or selling price.
		total_gains = calculator.multiply(left_over_number_of_coins, left_over_exchange_rate);
		
		# Store the profit transaction.
		#sold_transactoin_class.profit_trans_m.date_m;
		sold_transactoin_class.profit_trans_m.number_of_coins_m = left_over_number_of_coins;
		sold_transactoin_class.profit_trans_m.exchange_price_m = left_over_exchange_rate;
		sold_transactoin_class.profit_trans_m.amount_m = total_gains;
		
		# Store the sell transaction.
		#sold_transactoin_class.sold_trans_m.date_m;
		sold_transactoin_class.sold_trans_m.number_of_coins_m = sold_number_of_coins;
		sold_transactoin_class.sold_trans_m.exchange_price_m = sold_exchange_rate;
		sold_transactoin_class.sold_trans_m.amount_m = sold_total_price;
		
		# Store the purchase transaction.
		#sold_transactoin_class.bought_trans_m.date_m;
		sold_transactoin_class.bought_trans_m.number_of_coins_m = sold_number_of_coins;
		sold_transactoin_class.bought_trans_m.exchange_price_m = purchased_cost_average;
		sold_transactoin_class.bought_trans_m.amount_m = calculator.multiply(sold_number_of_coins, purchased_cost_average);
		
		if float(total_gains) >= 0:
			sold_transactoin_class.profit_trans_m.is_credit_m = true;
			sold_transactoin_class.sold_trans_m.is_credit_m = true;
			sold_transactoin_class.bought_trans_m.is_credit_m = true;
		else:
			sold_transactoin_class.profit_trans_m.is_credit_m = false;
			sold_transactoin_class.sold_trans_m.is_credit_m = false;
			sold_transactoin_class.bought_trans_m.is_credit_m = false;
	
	return sold_transactoin_class;

# Format the decimal number to make 
# reading easier.
# Format: %3.8f
func format_decimal(format_p, number_p):
	if format_p != "":
		return String(format_p % float(number_p));
	return number_p;
