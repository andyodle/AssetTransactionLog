extends Control

signal AddTransactoinClick;
signal SellTransactionClick;

onready var total_gains_data_panel = $VBoxContainer/HBoxContainer/TotalGains;
onready var total_amount_paid_data_panel = $VBoxContainer/HBoxContainer/TotalAmountPaid;
onready var cost_average_data_panel = $VBoxContainer/HBoxContainer/CostAverage;
onready var sold_transaction_log = $VBoxContainer/SoldTransactionsLog;
onready var animation_player = $AnimationPlayer;

func _ready():
	self.modulate = Color(1, 1, 1, 0);

func fade_in():
	animation_player.play("FadeIn");
	yield(animation_player,"animation_finished");

# Add the new transactoin to the transaction log.
func add_new_transaction(transaction_p):
	# Step 1: Create a sell history transaction.
	var temp_class : SoldTransactionRecord;
	temp_class = load("res://Scripts/Classes/SoldTransactionRecord.gd").new();
	temp_class.date_m = Utility.get_current_date_str();
	temp_class.number_of_coins_m = transaction_p.bought_trans_m.number_of_coins_m;
	temp_class.exchange_paid_m = transaction_p.bought_trans_m.exchange_price_m;
	temp_class.total_paid_m = transaction_p.bought_trans_m.amount_m;
	temp_class.exchange_sold_m = transaction_p.sold_trans_m.exchange_price_m;
	temp_class.total_sold_m = (temp_class.number_of_coins_m * transaction_p.sold_trans_m.exchange_price_m);
	temp_class.total_gains_m = (temp_class.total_sold_m - temp_class.total_paid_m);
	if temp_class.total_paid_m != 0:
		temp_class.percent_gains_m = (temp_class.total_gains_m / temp_class.total_paid_m) * 100;
	
	# Step 2: Add the transaction to the transaction log.
	sold_transaction_log.add_transaction(temp_class);
	
	# Step 3: Recalulate the displayed totals.
	sold_transaction_log.calculate_toals();

# Total gains was calcualted. Refresh your data.
func _on_SoldTransactionsLog_CalculatedTotalGains(total_gains_p):
	if total_gains_data_panel != null:
		total_gains_data_panel.set_data(String("$" + "%3.2f" % total_gains_p));

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
