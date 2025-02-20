extends Node

class_name SoldTransaction

var profit_trans_m;
var sold_trans_m;
var bought_trans_m;

func initalize():
	profit_trans_m = load("res://Scripts/Classes/Transaction.gd").new();
	sold_trans_m = load("res://Scripts/Classes/Transaction.gd").new();
	bought_trans_m = load("res://Scripts/Classes/Transaction.gd").new();
