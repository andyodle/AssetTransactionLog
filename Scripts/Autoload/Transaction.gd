extends Node

class_name Transaction

var date_acquired_m;
var number_of_coins_m : float;
var exchange_price_m : float;
var amount_m : float;
var is_credit_m : bool;
	
# Fill out the transaction data.
func set_trans_data(var date_acquired_p, var number_of_coins_p : float, var exchange_price_p : float, var amount_p : float, var is_credit_p : bool):
	self.date_acquired_m = date_acquired_p;
	self.number_of_coins_m = number_of_coins_p;
	self.exchange_price_m = exchange_price_p;
	self.amount_m = amount_p;
	self.is_credit_m = is_credit_p;

