extends Transaction

class_name SellTransaction

var sell_price_m : String;
var sold_trans_m : Array[Transaction];
var generated_trans_m : Array[Transaction];

func _ready():
	# Default the transaction type.
	trans_type_m = TransactionType.SELL_TRANS
