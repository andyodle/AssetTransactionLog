extends Control

onready var transaction_log = $VBoxContainer/TransactionLog;

# User wants to add a new transaction.
func _on_AddTransactionButton_pressed():
	transaction_log.add_transaction();

# User wants to calcualte a sell.
func _on_CalculateSellButton_pressed():
	pass # Replace with function body.
