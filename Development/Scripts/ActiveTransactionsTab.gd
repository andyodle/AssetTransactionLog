extends Control

signal AddTransactoinClick;
signal SellTransactionClick;
signal SplitTransactionClick;
signal EditTransactionClick;

@onready var total_coins_data_panel = %TotalAssets;
@onready var total_amount_paid_data_panel = %TotalAmountPaid;
@onready var cost_average_data_panel = %CostAverage;
@onready var current_price_panel = %CurrentPrice;
@onready var profit_or_loss_panel = %ProfitOrLoss;
@onready var profit_or_loss_percent = %ProfitOrLossPercent;
@onready var current_asset_value = %CurrentAssetValue;
@onready var transaction_log = %TransactionLog;
@onready var animation_player = $AnimationPlayer;

func _ready():
	self.modulate = Color(1, 1, 1, 0);

func fade_in():
	animation_player.play("FadeIn");
	await animation_player.animation_finished;

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
	profit_or_loss_percent.reset_data_panel();
	
	# Reset current asset value.
	current_asset_value.reset_data_panel();
	
	# Reset the Transaction log list.
	transaction_log.reset_trasactoins();

# Add the new transactoin to the transaction log.
func add_new_transaction(transaction_p):
	# Step 2: Add the transaction to the transaction log.
	transaction_log.add_transaction(transaction_p, false);
	
	# Check if trying to sell assets.
	if !transaction_p.is_credit_m:
		var sell_trans : SellTransaction;
		sell_trans = load("res://Scripts/Classes/SellTransaction.gd").new();
		sell_trans.date_m = transaction_p.date_m;
		sell_trans.number_of_coins_m = transaction_p.number_of_coins_m;
		sell_trans.exchange_price_m = transaction_p.exchange_price_m;
		sell_trans.sell_price_m = transaction_p.amount_m;
		var remainder_transactions = Utility.process_sell_transaction(sell_trans, transaction_log);
		# Add any remaning partical transactions to the log.
		for count in range(0, remainder_transactions.size()):
			var remainder_trans = remainder_transactions[count];
			transaction_log.add_transaction(remainder_trans, false);
	
	recalulate_totals();

# Get all of the current transactions.
func get_transactions():
	return transaction_log.get_transactions();

# Get the list of selected transactions.
func get_selected_transactions():
	return transaction_log.get_selected_transactions();

# Remove the selected transactions.
func remove_selected_transactions():
	transaction_log.remove_selected_transactions();
	
	# Hide selection tools.
	transaction_log.hide_selection_controls();
	
	recalulate_totals();

# Recalulate the displayed totals after a change.
func recalulate_totals():
	# Recalulate the displayed totals.
	transaction_log.calculate_toals();

# Number of coins was calculated. Refresh your data.
func _on_TransactionLog_CalculatedNumberOfCoins(number_of_coins_p):
	if total_coins_data_panel != null:
		total_coins_data_panel.set_data("", number_of_coins_p);

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

# User wants to split the selected transaction.
func _on_TransactionLog_SplitTransactionClick():
	emit_signal("SplitTransactionClick");

# User wants to edit the selected transaction.
func _on_TransactionLog_EditTransactionClick():
	emit_signal("EditTransactionClick");
