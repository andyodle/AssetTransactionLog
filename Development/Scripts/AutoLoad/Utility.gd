extends Node

var main_window_title = "";

func _ready():
	reset_main_window_title();

# Get the current date.
func get_current_date_str():
	var temp_date_time = Time.get_datetime_dict_from_system();
	var date_string = String("%02d" % temp_date_time["month"]) + "/" + String("%02d" % temp_date_time["day"]) + "/" + String("%4d" % temp_date_time["year"]);
	return date_string;

# Calculate Transaction Values
func calculate_transaction_values(transaction_list_p):
	var calculator = Calculator.new();
	# Get the list of transaction list view items.
	var transaction_views = transaction_list_p.get_children();
	transaction_views.reverse();
	var bought_transactions = [];
	for count in range(0, transaction_views.size() - 1):
		# Get the current transaction list view item.
		var trans_view = transaction_views[count];
		# Get the stored transaction data.
		var trans_data = trans_view.trans_data;
		if trans_data.is_credit_m:
			# Bought Asset / Deposit
			#print("Bought", trans_data.number_of_coins_m)
			if !trans_data.is_sold_m:
				if !bought_transactions.has(trans_data):
					bought_transactions.append(trans_data);
		else:
			print("Sold-Start...", trans_data.number_of_coins_m)
			# Make srue we actually sold some assets.
			if trans_data.number_of_coins_m != "0":
				var total_sold = "0"
				for bought_count in range(0, bought_transactions.size()):
					var bought_trans_data = bought_transactions[bought_count];
					if !bought_trans_data.is_sold_m:
						# Keep track of how many have been sold.
						total_sold = calculator.add(total_sold, bought_trans_data.number_of_coins_m);
						# See if we are selling a partical position.
						var remainder = abs(float(calculator.divide(total_sold, trans_data.number_of_coins_m)));
						print("Remainder: ", remainder)
						if remainder <= 0:
							# ---- Not selling a partical position. ----
							bought_trans_data.is_sold_m = true;
						elif remainder > 1:
							# ---- Selling a partical position. ----
							# In Memory Calculation
							# num_remaining = abs(num_of_sold_assets) - (total_sold_assets - num_current_bought_assets)
							var num_of_assets = abs(float(trans_data.number_of_coins_m)) - float(calculator.subtract(total_sold, bought_trans_data.number_of_coins_m));
							var exchange_price = bought_trans_data.exchange_price_m
							var cost_basis = num_of_assets * float(exchange_price);
							print("InMemoryCalc:")
							print("    NumOfCoins: %s, ExchangePrice: %s, CostBasis: %s" % [num_of_assets, exchange_price, cost_basis]);
			print("Sold-End...", trans_data.number_of_coins_m)

# Calculate Sold Asset
func calculate_sold_asset_transaction(trans_list_p, prev_sell_trans_idx_p):
	var trans_views = trans_list_p.get_children();
	# Reverse transactin list to get oldest transaction first.
	trans_views.reverse()
	for count in range(prev_sell_trans_idx_p, trans_views.size() - 1):
		var trans_view_item = trans_views[count];
		var trans_data = trans_view_item.trans_data;
		if trans_data.is_credit_m:
			print(trans_data.number_of_coins_m)
		else:
			break;

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
	if transacion_list_p.get_child_count() > 1:
		for transaction_view in transaction_views:
			var trans_data = transaction_view.trans_data;
			total_price = calculator.add(total_price, trans_data.amount_m);
			coin_count = calculator.add(coin_count, trans_data.number_of_coins_m);
		if float(coin_count) != 0:
			cost_average = calculator.divide(total_price, coin_count);
	elif transacion_list_p.get_child_count() == 1:
		# Can't have an average if there is only one result.
		var trans_data = transaction_views[0].trans_data;
		cost_average = trans_data.exchange_price_m;
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

# Reset the main window title to a default state.
func reset_main_window_title():
	# Keep track of the window title.
	main_window_title = ProjectSettings.get("application/config/name");
	get_window().set_title(main_window_title);

# Helper function to set and keep track of the window title.
func set_main_window_title(title_p):
	if title_p != null:
		main_window_title = title_p;
		get_window().set_title(title_p);

# Show the user that there are changes that need to be saved.
func show_save_changes():
	if main_window_title[0] != "*":
		set_main_window_title("*" + main_window_title);
