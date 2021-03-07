extends "res://Scripts/DialogWindow.gd"

signal AddNewTransaction;

onready var transaction_ammount = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/TransactionAmount;
onready var exchange_price = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/ExchangePrice;
onready var transaction_date = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/TransactionDate;
onready var number_of_coins = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/NumberOfCoins;
onready var credit_or_debit = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/CreditOrDebit;

func _ready():
	reset_form();

# Clear the form to prepare for a new entry.
func reset_form():
	transaction_ammount.text = "";
	exchange_price.text = "";
	transaction_date.text = "";
	number_of_coins.text = "";
	credit_or_debit.set_checked(true);

# Check to see if the user entered valid data.
# Return true if valid input else false.
func verify_input():
	var valid_input = true;
	
	# Exchange Price
	if(transaction_ammount.text == ""):
		valid_input = false;
	# Transaction Date
	if(transaction_date.text == ""):
		valid_input = false;
	# Number of Coins
	if(number_of_coins.text == ""):
		valid_input = false;
	
	return valid_input;

# Ok Clicked
func _on_DialogActionButtons_OkClicked():
	# Step1: Validate User Input.
	if verify_input():
		# Step2: Create and fillout a Transaction obect.
		# Trade 1
		var temp_class : Transaction;
		temp_class = load("res://Scripts/Classes/Transaction.gd").new();
		temp_class.date_m = transaction_date.text;
		temp_class.number_of_coins_m = number_of_coins.text;
		temp_class.exchange_price_m = exchange_price.text;
		temp_class.amount_m = transaction_ammount.text;
		temp_class.is_credit_m = credit_or_debit.get_checked();
		
		# Step3: Emit signal with transaction data.
		emit_signal("AddNewTransaction", temp_class);
		
		self.fade_out();

# Cancel Clicked
func _on_DialogActionButtons_CancelClicked():
	self.fade_out();

# Check to see if the form has finished fadeing in.
func _on_AnimationPlayer_animation_finished(anim_name_p):
	if anim_name_p == "FadeIn":
		reset_form();
