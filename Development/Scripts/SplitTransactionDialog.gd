extends "res://Scripts/DialogWindow.gd"

@onready var reduce_transaction_input = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/ReduceTransactionInput;
@onready var transaction_log = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/TransactionLog;

signal SplitTransaction;

var reduced_transaction;

func reset_dialog():
	reduce_transaction_input.text = "";
	transaction_log.reset_trasactoins();

func verify_input():
	return true;

# Add selected transactions to the split log.
func add_transaction_to_split(transactoin_to_split_p):
	transaction_log.add_transaction(transactoin_to_split_p, true);

func calculate_split_transaction():
	# Double Custom Calculator
	var calculator = Calculator.new();
	
	# Get the amount to reduce the transaction by.
	var amount_to_reduce = reduce_transaction_input.text;
	
	# Make sure we have an amount to calcualte.
	if float(amount_to_reduce) != 0:
		var transaction_views = transaction_log.get_transactions();
		for transaction_view in transaction_views:
			var temp_class : Transaction;
			temp_class = load("res://Scripts/Classes/Transaction.gd").new();
			temp_class.date_m = Utility.get_current_date_str();
			temp_class.number_of_coins_m = calculator.divide(amount_to_reduce, transaction_view.trans_data.exchange_price_m).pad_decimals(8);
			temp_class.exchange_price_m = transaction_view.trans_data.exchange_price_m;
			temp_class.amount_m = amount_to_reduce;
			temp_class.is_credit_m = true;
			reduced_transaction = temp_class;
	

# User clicked OK
func _on_DialogActionButtons_OkClicked():
	# Step1: Validate User Input.
	if verify_input():
		if reduced_transaction != null:
			# Step2: Emit signal with transaction data.
			emit_signal("SplitTransaction", reduced_transaction);
		
		self.fade_out();

# User clicked Cancel
func _on_DialogActionButtons_CancelClicked():
	self.fade_out();

# User enterd an amount.
func _on_ReduceTransactionInput_text_changed():
	calculate_split_transaction();
