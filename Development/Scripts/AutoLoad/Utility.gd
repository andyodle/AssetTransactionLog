extends Node

# Get the current date.
func get_current_date_str():
	var temp_date_time = OS.get_datetime();
	var date_string = String("%02d" % temp_date_time["day"]) + "/" + String("%02d" % temp_date_time["month"]) + "/" + String("%4d" % temp_date_time["year"]);
	return date_string;

# Calcualte the total number of coins acquired.
func calcualte_total_coins(transacion_list_p):
	# Get all of the coin transactions.
	var coin_count : float = 0.0;
	var transaction_views = transacion_list_p.get_children();
	for transaction_view in transaction_views:
		var trans_data = transaction_view.trans_data;
		if trans_data.is_credit_m:
			coin_count += float(trans_data.number_of_coins_m);
		else:
			coin_count -= float(trans_data.number_of_coins_m);
	
	return coin_count;

# Calcualte the total price paid for the coins.
func calculate_total_price(transacion_list_p):
	# Get all of the price transactions.
	var total_price : float = 0.0;
	var transaction_views = transacion_list_p.get_children();
	for transaction_view in transaction_views:
		var trans_data = transaction_view.trans_data;
		if trans_data.is_credit_m:
			total_price += float(trans_data.amount_m);
		else:
			total_price -= float(trans_data.amount_m);
	
	return total_price;

# Calcualte the cost average of the purchased coins.
func calcualte_cost_average(transacion_list_p):
	# Get all of the price transactions.
	var total_price : float = 0.0;
	var coin_count : float = 0.0;
	var cost_average : float = 0.0;
	var transaction_views = transacion_list_p.get_children();
	for transaction_view in transaction_views:
		var trans_data = transaction_view.trans_data;
		if trans_data.is_credit_m:
			total_price += float(trans_data.amount_m);
			coin_count += float(trans_data.number_of_coins_m);
		else:
			total_price -= float(trans_data.amount_m);
			coin_count -= float(trans_data.number_of_coins_m);
	if coin_count != 0:
		cost_average = (total_price / coin_count);
	
	return cost_average;

# Calcualte the total gains
func calculate_total_gains(transacion_list_p):
	# Get all of the price transactions.
	var total_gains : float = 0.0;
	var transaction_views = transacion_list_p.get_children();
	for transaction_view in transaction_views:
		var trans_data = transaction_view.trans_data;
		total_gains += float(trans_data.total_gains_m);
	
	return total_gains;
