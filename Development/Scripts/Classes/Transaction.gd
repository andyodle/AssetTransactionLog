extends Node

class_name Transaction

enum TransactionType {
	BUY_TRANS,
	SELL_TRANS,
	GENERATED_TRANS
}

var index_m;
var trans_type_m : TransactionType;
var date_m;
var number_of_coins_m : String;
var exchange_price_m : String;
var amount_m : String;
var is_credit_m : bool = false;
var is_sold_m : bool = false;

func _ready():
	# Default the type of transaction.
	trans_type_m = TransactionType.BUY_TRANS
