extends Node

const uuid_util = preload("res://addons/UUID/uuid.gd");

var main_window_title = "";

func _ready():
	reset_main_window_title();

# Get the current date.
func get_current_date_str():
	var temp_date_time = Time.get_datetime_dict_from_system();
	var date_string = String("%02d" % temp_date_time["month"]) + "/" + String("%02d" % temp_date_time["day"]) + "/" + String("%4d" % temp_date_time["year"]);
	return date_string;

# Get all unsold transactions.
func get_unsold_transactions(trans_log_p):
	var trans_views = trans_log_p.get_transactions();
	# Sort transactions by oldest first.
	trans_views.reverse();
	var bought_transactions = [];
	for count in range(0, trans_views.size()):
		# Get the transaction view.
		var trans_view = trans_views[count];
		# Get the stroed tansaction data.
		var trans_data = trans_view.trans_data;
		# Filter out sell transactions.
		if trans_data.is_credit_m:
			# Check if transaction has not been sold.
			if !trans_data.is_sold_m:
				# Check for duplication transactions
				if !bought_transactions.has(trans_data):
					bought_transactions.append(trans_data);
	
	return bought_transactions;

# Attempt to sell assets using first in first out.
func process_sell_transaction(sell_trans_p:SellTransaction, transaction_log_p):
	var remainder_transactions = [];
	var calculator = Calculator.new();
	# Get a list of all unsold transactions.
	var active_trans = get_unsold_transactions(transaction_log_p);
	# Keep track of witch transactions were sold.
	var sold_transactions = [];
	# Keep track of total assets sold
	var total_sold = "0";
	
	print("Sold-Start...")
	for count in range(0, active_trans.size()):
		# Get the transaction data.
		var trans_data = active_trans[count];
		# Make sure we have enough assets avaible to sell.
		if float(total_sold) <= abs(float(sell_trans_p.number_of_coins_m)):
			# Keep track of wich sell transaction modifed this transaction.
			trans_data.sell_trans_index_m = sell_trans_p.index_m;
			# Keep track of how many have been sold.
			total_sold = calculator.add(total_sold, trans_data.number_of_coins_m);
			# Check if we are selling a partical position.
			var remainder = abs(float(calculator.divide(total_sold, sell_trans_p.number_of_coins_m)));
			print("Remainder: ", remainder)
			if remainder >= 0 && remainder < 1:
				# ---- Selling full amount of assets but still need more to sell. ----
				sold_transactions.append(trans_data);
				# Keep track of sold transactions.
				sell_trans_p.sold_trans_m.append(trans_data.index_m);
			elif remainder == 1:
				# ---- Selling exact amount of an asset ----
				sold_transactions.append(trans_data);
				# Keep track of sold transactions.
				sell_trans_p.sold_trans_m.append(trans_data.index_m);
				break;
			elif remainder > 1:
				sold_transactions.append(trans_data);
				
				# Keep track of sold transactions.
				sell_trans_p.sold_trans_m.append(trans_data.index_m);
				
				# ---- Selling a partical position. ----
				# In Memory Calculation
				# num_to_sell = abs(selling_num_of_assets) - (total_sold_assts - num_current_bought_assets)
				var num_to_sell = abs(float(sell_trans_p.number_of_coins_m)) - float(calculator.subtract(total_sold, trans_data.number_of_coins_m));
				var sell_exchange_price = trans_data.exchange_price_m;
				# sell_cost_basis = numb_to_sell * trans_data.exchange_price
				# Round to 2 decimal palces.
				var sell_cost_basis = Utility.bankers_round((num_to_sell * float(sell_exchange_price)), 2);
				print("InMemoryCalc:")
				print("    NumOfCoins: %s, ExchangePrice: %s, CostBasis: %s" % [num_to_sell, sell_exchange_price, sell_cost_basis])
				# Number of Remaning Assets Calculation
				# numb_of_remaning = trans_data.number_of_coins - num_to_sell
				var num_of_remaning = abs(float(trans_data.number_of_coins_m) - num_to_sell);
				# cost_basis_remaning = num_of_remaning * trans_data.exchange_price
				# Round to 2 decimal palces.
				var cost_basis_remaning = Utility.bankers_round((num_of_remaning * float(trans_data.exchange_price_m)), 2);
				# exchange_price_remaning = cost_basis_remaning / num_of_remaning
				# Round to 2 decimal palces.
				var exchange_price_remaning = Utility.bankers_round((cost_basis_remaning / num_of_remaning), 2);
				print("RemainingAssets:")
				print("    NumOfCoins: %s, ExchangePrice: %s, CostBasis: %s" % [num_of_remaning, exchange_price_remaning, cost_basis_remaning])
				# Create remander asset transaction.
				var temp_trans = create_asset_trans(str(num_of_remaning), str(exchange_price_remaning), str(cost_basis_remaning), trans_data.date_m, true, false);
				remainder_transactions.append(temp_trans);
				
				# Keep track of remainder transactions.
				sell_trans_p.generated_trans_m.append(temp_trans.index_m);
				
				break;
	
	# Flag sold transactions as sold including partical sold transaction.
	transaction_log_p.mark_sold_transactions(sell_trans_p.sold_trans_m, true);
	
	print("Sold-End...")
	return remainder_transactions;

# Createa a transaction object.
# Retuns: A filled out transaction object.
func create_asset_trans(num_of_assets_p:String, exchange_price_p:String, cost_basis_p:String, date_p:String, is_credit_p:bool, is_sold_p:bool) -> Transaction:
	var asset_trans : Transaction;
	asset_trans = load("res://Scripts/Classes/Transaction.gd").new();
	asset_trans.index_m = create_new_uuid();
	asset_trans.trans_type_m = Transaction.TransactionType.BUY_TRANS;
	asset_trans.date_m = date_p;
	asset_trans.number_of_coins_m = num_of_assets_p;
	asset_trans.exchange_price_m = exchange_price_p;
	asset_trans.amount_m = cost_basis_p;
	asset_trans.is_credit_m = is_credit_p;
	asset_trans.is_sold_m = is_sold_p
	return asset_trans;

# Create a auto generated transaction object.
# Returns: A filled out generated transaction object.
func create_generated_transaction(transaction_p: Transaction):
	var generated_transaction : GeneratedTransaction;
	generated_transaction = load("res://Scripts/Classes/GeneratedTransaction.gd").new();
	generated_transaction.trans_type_m = Transaction.TransactionType.GENERATED_TRANS;
	generated_transaction.index_m = transaction_p.index_m;
	generated_transaction.date_m = transaction_p.date_m;
	generated_transaction.number_of_coins_m = transaction_p.number_of_coins_m;
	generated_transaction.exchange_price_m = transaction_p.exchange_price_m;
	generated_transaction.amount_m = transaction_p.amount_m;
	generated_transaction.is_credit_m = transaction_p.is_credit_m;
	generated_transaction.is_sold_m = transaction_p.is_sold_m;
	
	return generated_transaction;

# Calculate Bankers Rounding Rules
# 1. Scaling: The input value is multiplied by 10^decimals to shift the decimal point.
# 2. Rounding: The value is rounded normally.
# 3. Tie-breaking: 
#     If the scaled value is exactly halfway between tow intergers
#     Then check if rounded value is odd.
#         If valuse is odd.
#         Then adjust the value to make it even.
# 4. Return: The scaled and adjusted value is divided by 10^decimals to restore orginal scale.
func bankers_round(value_p: float, decimals: int = 0) -> float:
	var factor = pow(10, decimals)
	var scaled_value = value_p * factor
	var rounded_value = floor(scaled_value)
	
	# Check for a tie
	if abs(scaled_value - rounded_value) == 0.5:
		# Round towars the nearest even number.
		if fmod(rounded_value, 2) != 0:
			rounded_value += (1 if scaled_value > 0 else -1)
	
	return rounded_value / factor

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
func calcualte_total_coins(active_trans_p):
	var calculator = Calculator.new();
	# Get all of the coin transactions.
	var coin_count : String = "0.0";
	for transaction in active_trans_p:
		coin_count = str(Utility.bankers_round(float(calculator.add(coin_count, transaction.number_of_coins_m)), 4));
	
	return coin_count;

# Calcualte the total price paid for the coins.
func calculate_total_price(active_trans_p):
	var calculator = Calculator.new();
	# Get all of the price transactions.
	var total_price : String = "0.0";
	for transaction in active_trans_p:
		total_price = str(Utility.bankers_round(float(calculator.add(total_price, transaction.amount_m)), 2));
	
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
func calcualte_cost_average(total_paid_p, total_asset_p):
	var calculator = Calculator.new();
	var cost_average = Utility.bankers_round(float(calculator.divide(total_paid_p, total_asset_p)), 2);

	return str(cost_average);

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

# Calculate Total Assets
func calculate_total_assets(cost_basis_p, exchange_price_p):
	var total_assets = "";
	if exchange_price_p != "" and exchange_price_p != "0" and cost_basis_p != "":
		var calculator = Calculator.new();
		total_assets = calculator.divide(cost_basis_p, exchange_price_p);
	
	return total_assets

# Calculate sold transaction.
func calculate_sold_transaction(number_of_coins_sold_p, amount_sold_p, number_of_coins_bought_p, amount_paid_p, paid_cost_average_p):
	# Double Custom Calculator
	var calculator = Calculator.new();
	
	# Initalize the sold transaction.
	var sold_transactoin_class = preload("res://Scripts/Classes/SoldTransaction.gd").new();
	sold_transactoin_class.initalize();
	
	# Purchased Data
	var _purchased_total_price;
	_purchased_total_price = amount_paid_p;
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

# Generate a new uuid.
func create_new_uuid():
	return uuid_util.v4()
