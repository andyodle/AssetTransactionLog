extends Control

onready var transaction_log = $HBoxContainer/VBoxContainer/TransactionLog;

# User wants to add a new transaction.
func _on_TransactionLog_AddTransactionClick():
	transaction_log.add_transaction();

# User wants to calcualte a sell.
func _on_TransactionLog_CalcualteSellClick():
	pass # Replace with function body.
