extends "res://Scripts/DialogWindow.gd"

signal SplitTransaction;

func reset_dialog():
	pass;

func verify_input():
	return true;

# User clicked OK
func _on_DialogActionButtons_OkClicked():
	# Step1: Validate User Input.
	if verify_input():
		# Step2: Create and fillout a Transaction obect.
		var temp_class : Transaction;
		temp_class = load("res://Scripts/Classes/Transaction.gd").new();
		#temp_class.date_m = transaction_date.text;
		#temp_class.number_of_coins_m = number_of_coins.text;
		#temp_class.exchange_price_m = exchange_price.text;
		#temp_class.amount_m = transaction_ammount.text;
		#temp_class.is_credit_m = credit_or_debit.get_checked();
		
		# Step3: Emit signal with transaction data.
		emit_signal("SplitTransaction", temp_class);
		
		self.fade_out();

# User clicked Cancel
func _on_DialogActionButtons_CancelClicked():
	self.fade_out();
