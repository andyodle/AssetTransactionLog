extends "res://Tests/TestBase.gd"

var calculator;

# Purchased Data
var amount_paid_m = "50.00";
var exchange_rate_paid_m = "47605.45";
var number_of_coins_bought_m = "0.00105030";

# Sold Data
var amount_sold_m = "50.00";
var exchange_rate_sold_m = "48399.84297600";
var number_of_coins_sold_m = "0.00103306";

func initalize_test():
	calculator = Calculator.new();
	#sucess("Test initalized!");
	#failure("Test run!");
	pass;

func test_sold_transaction():
	# Initalize the sold transaction.
	var sold_transactoin_class = null;
	
	# number_of_coins_sold_p, amount_sold_p, number_of_coins_bought_p, amount_paid_p, paid_cost_average_p
	sold_transactoin_class = Utility.calculate_sold_transaction(number_of_coins_sold_m, amount_sold_m, number_of_coins_bought_m, amount_paid_m, exchange_rate_paid_m);
	
	# Validate expected sold values.
	check_bought_transaction(sold_transactoin_class);	
	check_sold_transaction(sold_transactoin_class);
	
	pass

func check_bought_transaction(sold_transaction_class_p):
	# Check number_of_coins_sold
	var result = sold_transaction_class_p.bought_trans_m.number_of_coins_m;
	if result != "0.00103306":
		failure("bought_trans_m.number_of_coins_m: "  + result);
	else:
		sucess("bought_trans_m.number_of_coins_m: "  + result);
	
	# Check exchnage_price_sold
	result = sold_transaction_class_p.bought_trans_m.exchange_price_m;
	if result != "47605.45":
		failure("bought_trans_mexchange_price_m: "  + result);
	else:
		sucess("bought_trans_m.exchange_price_m: "  + result);
	
	# Check amount_sold
	result = sold_transaction_class_p.bought_trans_m.amount_m;
	if result != "49.179286177":
		failure("bought_trans_m.amount_m: "  + result);
	else:
		sucess("bought_trans_m.amount_m: "  + result);
	pass

func check_sold_transaction(sold_transaction_class_p):
	# Check number_of_coins_sold
	var result = sold_transaction_class_p.sold_trans_m.number_of_coins_m;
	if result != "0.00103306":
		failure("sold_trans_m.number_of_coins_m: "  + result);
	else:
		sucess("sold_trans_m.number_of_coins_m: "  + result);
	
	# Check exchnage_price_sold
	result = sold_transaction_class_p.sold_trans_m.exchange_price_m;
	if result != "48399.899328209402":
		failure("sold_trans_m.exchange_price_m: "  + result);
	else:
		sucess("sold_trans_m.exchange_price_m: "  + result);
	
	# Check amount_sold
	result = sold_transaction_class_p.sold_trans_m.amount_m;
	if result != "50.00":
		failure("sold_trans_m.amount_m: "  + result);
	else:
		sucess("sold_trans_m.amount_m: "  + result);
	pass

func run_test():
	test_sold_transaction();
	pass
