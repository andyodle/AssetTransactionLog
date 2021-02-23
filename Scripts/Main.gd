extends Control

onready var coin_transactions_view = $HBoxContainer/CoinTransactoinsView;
onready var add_trans_dialog = $AddTransaction;

# Add a new transaction.
func _on_AddTransaction_AddNewTransaction(transaction_p):
	coin_transactions_view.add_new_transaction(transaction_p);

# User wants to add a new transaction.
func _on_CoinTransactoinsView_AddTransactoinClick():
	# Step 1: Show the add transaction dialog.
	add_trans_dialog.fade_in();
