extends Control

signal AddTransactoinClick;
signal SellTransactionClick;
signal EditTransactionClick;
signal CurrentPriceChange(price_p);

@onready var total_coins_data_panel = %TotalAssets;
@onready var total_amount_paid_data_panel = %TotalAmountPaid;
@onready var cost_average_data_panel = %CostAverage;
@onready var current_price_panel = %CurrentPrice;
@onready var profit_or_loss_panel = %ProfitOrLoss;
@onready var profit_or_loss_percent_panel = %ProfitOrLossPercent;
@onready var current_asset_value = %CurrentAssetValue;
@onready var transaction_log = %TransactionLog;
@onready var animation_player = $AnimationPlayer;

func _ready():
	self.modulate = Color(1, 1, 1, 0);

func fade_in():
	animation_player.play("FadeIn");
	await animation_player.animation_finished;

# Get the specified transaction.
func get_transaction(trans_index_p):
	return transaction_log.get_transaction(trans_index_p);

# Get all of the current transactions.
func get_transactions():
	return transaction_log.get_transactions();

# Get the list of selected transactions.
func get_selected_transactions():
	return transaction_log.get_selected_transactions();

# Atempt to remove a transaction from the log.
func delete_transaction(trans_index_p):
	transaction_log.delete_transaction(trans_index_p);

# Add loaded transaction to list.
func add_loaded_transaction(transaction_p):
	# Step 2: Add the transaction to the transaction log.
	transaction_log.add_transaction(transaction_p, false);
	
	recalulate_totals();

# Add the new transactoin to the transaction log.
func add_new_transaction(transaction_p):
	# Check if trying to sell assets.
	if !transaction_p.is_credit_m:
		var sell_trans : SellTransaction;
		sell_trans = Utility.create_sell_transaction(transaction_p.number_of_coins_m, transaction_p.exchange_price_m, transaction_p.amount_m, transaction_p.date_m)
		sell_trans.index_m = transaction_p.index_m;
		
		# Calculate sold transactions.
		var remainder_transactions = Utility.process_sell_transaction(sell_trans, transaction_log);
		
		# Add the sell transaction to the transactin log.
		transaction_log.add_transaction(sell_trans, false);
		
		# Add any remaning partical transactions to the log.
		for count in range(0, remainder_transactions.size()):
			var remainder_trans = Utility.create_generated_transaction(remainder_transactions[count]);
			# Keep track of wich sell transaction created this partical transaction.
			remainder_trans.sell_trans_index_m = sell_trans.index_m;
			transaction_log.add_transaction(remainder_trans, false);
	else:
		# Step 2: Add the transaction to the transaction log.
		transaction_log.add_transaction(transaction_p, false);
	
	recalulate_totals();

# Remove the selected transactions.
func remove_selected_transactions():
	transaction_log.remove_selected_transactions();
	
	# Hide selection tools.
	transaction_log.hide_selection_controls();
	
	recalulate_totals();

# Rollback the previous changes made by the sell transaction.
func undo_sell_trans_changes(sell_trans_p: SellTransaction):
	transaction_log.undo_sell_trans_changes(sell_trans_p);

# Recalulate the displayed totals after a change.
func recalulate_totals():
	# Recalulate the displayed totals.
	transaction_log.calculate_toals();
	
	# Calculate Current Asset Value.
	calculate_current_values();

# Calcualte the assets current value.
func calculate_current_values():
	var calculator = Calculator.new();
	var current_price = current_price_panel.get_data();
	var total_assets = total_coins_data_panel.get_data();
	var total_paid = total_amount_paid_data_panel.get_data();
	# Current Asset Value
	if current_price:
		var current_value = Utility.bankers_round(float(calculator.multiply(str(total_assets), current_price)), 3);
		var profit_loss_value = Utility.bankers_round(float(calculator.subtract(str(current_value), total_paid)), 2);
		
		# Update data panels.
		current_asset_value.set_data("%3.2f", current_value);
		profit_or_loss_panel.set_data("%3.2f", Utility.bankers_round(float(profit_loss_value), 2));
		
		if float(total_paid) != 0:
			var profit_loss_percent_value = calculator.divide(str(profit_loss_value), total_paid);
			profit_loss_percent_value = calculator.multiply(profit_loss_percent_value, "100");
			# Update data panels.
			profit_or_loss_percent_panel.set_percent(profit_loss_percent_value);

# Reset the transaction list.
func reset_trasactoins():
	# Reset total coins.
	total_coins_data_panel.reset_data_panel();
	
	# Reset total amount paid.
	total_amount_paid_data_panel.reset_data_panel();
	
	# Reset cost average.
	cost_average_data_panel.reset_data_panel();
	
	# Reset current price.
	current_price_panel.reset_data_panel();
	
	# Reset profit or loss.
	profit_or_loss_panel.reset_data_panel();
	
	# Reset profit or loss percent.
	profit_or_loss_percent_panel.reset_data_panel();
	
	# Reset current asset value.
	current_asset_value.reset_data_panel();
	
	# Reset the Transaction log list.
	transaction_log.reset_trasactoins();

# Number of coins was calculated. Refresh your data.
func _on_TransactionLog_CalculatedNumberOfCoins(number_of_coins_p):
	if total_coins_data_panel != null:
		total_coins_data_panel.set_data("%3.8f", number_of_coins_p);

# Total price was calcualted. Refresh your data.
func _on_TransactionLog_CalcualteTotalPrice(amount_paid_p):
	if total_amount_paid_data_panel != null:
		total_amount_paid_data_panel.set_data("%3.2f", amount_paid_p);

# Cost average was calcualted. Refresh your data.
func _on_TransactionLog_CalculateCostAverage(cost_average_p):
	if cost_average_data_panel != null:
		cost_average_data_panel.set_data("%3.2f", cost_average_p);

# Attempt to open the add transaction dialog.
func _on_TransactionLog_AddTransactionClick():
	emit_signal("AddTransactoinClick");

# User wants to sell transactions.
func _on_TransactionLog_SellTransactoinClick():
	emit_signal("SellTransactionClick");

# User wants to edit the selected transaction.
func _on_TransactionLog_EditTransactionClick():
	emit_signal("EditTransactionClick");

# User changed crurrent price.
func _on_current_price_data_text_changed(text_p):
	emit_signal("CurrentPriceChange", text_p);
	recalulate_totals();
