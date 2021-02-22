extends "res://Scripts/DialogWindow.gd"

signal AddNewTransaction;

onready var transaction_ammount = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/TransactionAmount;
onready var exchange_price = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/ExchangePrice;
onready var transaction_date = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/TransactionDate;
onready var number_of_coins = $CenterContainer/DialogContainer/MarginContainer/CenterContainer/VBoxContainer/NumberOfCoins;

func _ready():
	reset_form();

# Clear the form to prepare for a new entry.
func reset_form():
	transaction_ammount.text = "";
	exchange_price.text = "";
	transaction_date.text = "";
	number_of_coins.text = "";

# Check to see if the user entered valid data.
func verify_input():
	pass;

# Ok Clicked
func _on_DialogActionButtons_OkClicked():
	# Step1: Validate User Input.
	# Step2: Create and fillout a Transaction obect.
	# Trade 1
	var temp_class : Transaction;
	temp_class = load("res://Scripts/Autoload/Transaction.gd").new();
	temp_class.set_trans_data(transaction_date.text, float(number_of_coins.text), float(exchange_price.text), float(transaction_ammount.text), true);
	#temp_trans_view.set_tras_data(temp_class);
	
	print(temp_class);
	
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
