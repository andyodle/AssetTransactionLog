extends Control

onready var total_gains_data_panel = $VBoxContainer/HBoxContainer/TotalGains;
onready var total_amount_paid_data_panel = $VBoxContainer/HBoxContainer/TotalAmountPaid;
onready var total_amount_sold_data_panel = $VBoxContainer/HBoxContainer/TotalAmountSold;
onready var sold_transaction_log = $VBoxContainer/SoldTransactionsLog;
onready var animation_player = $AnimationPlayer;

var calculator;

func _ready():
	calculator = Calculator.new();
	self.modulate = Color(1, 1, 1, 0);
	pass

func fade_in():
	animation_player.play("FadeIn");
	yield(animation_player,"animation_finished");

# Reset the transaction list.
func reset_trasactoins():
	# Reset total gains.
	total_gains_data_panel.reset_data_panel();
	
	# Reset total amount paid.
	total_amount_paid_data_panel.reset_data_panel();
	
	# Reset total amount sold.
	total_amount_sold_data_panel.reset_data_panel();
	
	# Reset the Transaction log list.
	sold_transaction_log.reset_trasactoins();

# Get all of the transactions.
func get_transactions():
	return sold_transaction_log.get_transactions();

# Add the new transactoin to the transaction log.
func add_new_transaction(transaction_p):
	# Step 1: Create a sell history transaction.
	var temp_class : SoldTransactionRecord;
	temp_class = load("res://Scripts/Classes/SoldTransactionRecord.gd").new();
	if transaction_p.sold_trans_m.date_m == null:
		temp_class.date_m = Utility.get_current_date_str();
	else:
		temp_class.date_m = transaction_p.sold_trans_m.date_m;
	temp_class.number_of_coins_m = transaction_p.sold_trans_m.number_of_coins_m;
	temp_class.exchange_paid_m = transaction_p.bought_trans_m.exchange_price_m;
	temp_class.amount_m = transaction_p.bought_trans_m.amount_m;
	temp_class.exchange_sold_m = transaction_p.sold_trans_m.exchange_price_m;
	temp_class.total_sold_m = calculator.multiply(temp_class.number_of_coins_m, transaction_p.sold_trans_m.exchange_price_m);
	temp_class.total_gains_m = calculator.subtract(temp_class.total_sold_m, temp_class.amount_m);
	if float(temp_class.amount_m) != 0:
		temp_class.percent_gains_m = calculator.multiply(calculator.divide(temp_class.total_gains_m, temp_class.amount_m), "100");
	
	# Step 2: Add the transaction to the transaction log.
	sold_transaction_log.add_transaction(temp_class);
	
	# Step 3: Recalulate the displayed totals.
	sold_transaction_log.calculate_toals();

# Total gains was calcualted. Refresh your data.
func _on_SoldTransactionsLog_CalculatedTotalGains(total_gains_p):
	if total_gains_data_panel != null:
		total_gains_data_panel.set_data("%3.2f", total_gains_p);

# Total price was calcualted. Refresh your data.
func _on_SoldTransactionsLog_CalcualtedTotalPaidPrice(amount_paid_p):
	if total_amount_paid_data_panel != null:
		total_amount_paid_data_panel.set_data("%3.2f", amount_paid_p);

# Total sold was calcualted. Refresh your data.
func _on_SoldTransactionsLog_CalcualtedTotalSoldPrice(amount_sold_p):
	if total_amount_sold_data_panel != null:
		total_amount_sold_data_panel.set_data("%3.2f", amount_sold_p);

# Percent gains was calcualted. Refresh your data.
func _on_SoldTransactionsLog_CalculatedPercentGains(percent_gains_p):
	total_gains_data_panel.set_percent(percent_gains_p);
