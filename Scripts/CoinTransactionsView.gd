extends Control

signal AddTransactoinClick;
signal SellTransactionClick;

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

# Add the new transactoin to the transaction log.
func add_new_transaction(transaction_p):
	# Step 2: Add the transaction to the transaction log.
	transaction_log.add_transaction(transaction_p);
	
	# Step 3: Recalulate the displayed totals.
	transaction_log.calcualte_total_coins();
	transaction_log.calculate_total_price();
	transaction_log.calcualte_cost_average();

# Get the list of selected transactions.
func get_selected_transactions():
	return transaction_log.get_selected_transactions();

# Remove the selected transactions.
func remove_selected_transactions():
	transaction_log.remove_selected_transactions();

# Number of coins was calculated. Refresh your data.
func _on_TransactionLog_CalculatedNumberOfCoins(number_of_coins_p):
	if total_coins_data_panel != null:
		total_coins_data_panel.set_data(String("%10.9f" % number_of_coins_p));

# Total price was calcualted. Refresh your data.
func _on_TransactionLog_CalcualteTotalPrice(amount_paid_p):
	if total_amount_paid_data_panel != null:
		total_amount_paid_data_panel.set_data(String("$" + "%3.2f" % amount_paid_p));

# Cost average was calcualted. Refresh your data.
func _on_TransactionLog_CalculateCostAverage(cost_average_p):
	if cost_average_data_panel != null:
		cost_average_data_panel.set_data(String("$" + "%3.2f" % cost_average_p));

# Attempt to open the add transaction dialog.
func _on_TransactionLog_AddTransactionClick():
	emit_signal("AddTransactoinClick");

# User wants to calcualte a sell.
func _on_TransactionLog_CalcualteSellClick():
	emit_signal("SellTransactionClick");
