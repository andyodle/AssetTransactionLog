extends Control

signal AddTransactoinClick;
signal SellTransactionClick;
signal SplitTransactionClick;
signal EditTransactionClick;

onready var total_coins_data_panel = $VBoxContainer/HBoxContainer/TotalCoins;
onready var total_amount_paid_data_panel = $VBoxContainer/HBoxContainer/TotalAmountPaid;
onready var cost_average_data_panel = $VBoxContainer/HBoxContainer/CostAverage;
onready var transaction_log = $VBoxContainer/TransactionLog;
onready var animation_player = $AnimationPlayer;

func _ready():
	self.modulate = Color(1, 1, 1, 0);

func fade_in():
	animation_player.play("FadeIn");
	yield(animation_player,"animation_finished");

# Reset the transaction list.
func reset_trasactoins():
	# Reset total coins.
	total_coins_data_panel.reset_data_panel();
	
	# Reset total amount paid.
	total_amount_paid_data_panel.reset_data_panel();
	
	# Reset cost average.
	cost_average_data_panel.reset_data_panel();
	
	# Reset the Transaction log list.
	transaction_log.reset_trasactoins();

# Add the new transactoin to the transaction log.
func add_new_transaction(transaction_p):
	# Step 2: Add the transaction to the transaction log.
	transaction_log.add_transaction(transaction_p, false);
	
	# Step 3: Recalulate the displayed totals.
	transaction_log.calculate_toals();

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
