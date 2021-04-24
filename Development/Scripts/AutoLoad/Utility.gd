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

# Format the decimal number to make 
# reading easier.
# Format: %3.8f
func format_decimal(format_p, number_p):
	return String(format_p % float(number_p));
