extends "res://Scripts/DialogWindow.gd"

signal AddNewTransaction;
signal EditTransaction;

@onready var transaction_ammount = %TransactionAmount;
@onready var exchange_price = %ExchangePrice;
@onready var transaction_date = %TransactionDate;
@onready var number_of_coins = %NumberOfCoins;
@onready var credit_or_debit = %CreditOrDebit;


var old_transaction;
var is_edit_transaction = false;

func _ready():
	reset_form();

# Clear the form to prepare for a new entry.
func reset_form():
	transaction_ammount.text = "";
	exchange_price.text = "";
	transaction_date.text = "";
	number_of_coins.text = "";
	credit_or_debit.set_checked(true);
	# Set Focus on First Control
	credit_or_debit.set_focus();

func _input(event):
	if event.is_action_pressed("ui_focus_next") and has_focus():
		if str(focus_next) != "":
			get_node(focus_next).grab_focus()
		get_tree().set_input_as_handled();

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

# The transaction to edit.
func edit_transaction(transaction_to_edit_p):
	# Set the from into edit mode.
	is_edit_transaction = true;
	
	# Store the previous transaction.
	old_transaction = transaction_to_edit_p;
	
	# Populate form with previously entred data.
	transaction_date.set_input_value(transaction_to_edit_p.date_m);
	number_of_coins.set_input_value(transaction_to_edit_p.number_of_coins_m);
	exchange_price.set_input_value(transaction_to_edit_p.exchange_price_m);
	transaction_ammount.set_input_value(transaction_to_edit_p.amount_m);
	credit_or_debit.set_checked(transaction_to_edit_p.is_credit_m);

# Ok Clicked
func _on_DialogActionButtons_OkClicked():
	var calculator = Calculator.new();
	# Step1: Validate User Input.
	if verify_input():
		if !is_edit_transaction:
			# Step2: Create and fillout a Transaction obect.
			var temp_class : Transaction;
			var number_of_assets = number_of_coins.text;
			var asset_exchange_price = exchange_price.text;
			var asset_cost_basis = transaction_ammount.text;
			var trans_date = transaction_date.text
			var is_credit = credit_or_debit.get_checked();
			if !is_credit:
				# Withdraw / Sell Asset
				number_of_assets = calculator.multiply("-1", number_of_assets);
				temp_class = Utility.create_asset_trans(number_of_assets, asset_exchange_price, asset_cost_basis, trans_date, is_credit, true);
			else:
				# Deposit / Buy Asset
				temp_class = Utility.create_asset_trans(number_of_assets, asset_exchange_price, asset_cost_basis, trans_date, is_credit, false);
			
			# Step3: Emit signal with transaction data.
			emit_signal("AddNewTransaction", temp_class);
		else:
			old_transaction.date_m = transaction_date.text;
			old_transaction.number_of_coins_m = number_of_coins.text;
			old_transaction.exchange_price_m = exchange_price.text;
			old_transaction.amount_m = transaction_ammount.text;
			old_transaction.is_credit_m = credit_or_debit.get_checked();
			if !old_transaction.is_credit_m:
				old_transaction.number_of_coins_m = calculator.multiply("-1", old_transaction.number_of_coins_m);
			emit_signal("EditTransaction", old_transaction);
		
		self.fade_out();

# Cancel Clicked
func _on_DialogActionButtons_CancelClicked():
	self.fade_out();

# Check to see if the form has finished fadeing in.
func _on_AnimationPlayer_animation_finished(anim_name_p):
	if anim_name_p == "FadeIn" && !is_edit_transaction:
		reset_form();

# Calculate purchase price was pressed.
func _on_CalculatePurchasePriceButton_pressed():
	transaction_ammount._on_TextInput_focus_entered();
	var temp_price = Utility.calculate_purchase_price(exchange_price.text, number_of_coins.text);
	transaction_ammount.text = str(Utility.bankers_round(float(temp_price), 2));

# Calculate button was pressed.
func _on_BaseIconButton_pressed():
	exchange_price._on_TextInput_focus_entered();
	var temp_price = Utility.calculate_exchange_rate(transaction_ammount.text, number_of_coins.text);
	exchange_price.text = temp_price;


func _on_NumberOfCoins_BaseIconButton_pressed():
	number_of_coins._on_TextInput_focus_entered()
	var temp_numb_assets = Utility.calculate_total_assets(transaction_ammount.text, exchange_price.text)
	temp_numb_assets = Utility.bankers_round(float(temp_numb_assets), 8)
	number_of_coins.text = str(temp_numb_assets);
