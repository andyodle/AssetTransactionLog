extends Control

onready var active_transactions_view = $HBoxContainer/TabsContainer/ActiveTransactionsView;
onready var profit_transactions_view = $HBoxContainer/TabsContainer/ProfitTransactionsView;
onready var add_trans_dialog = $AddTransaction;
onready var sell_trans_dialog = $SellTransactionDialog;

func _ready():
	# Show the active tab by default.
	hide_tabs();
	active_transactions_view.visible = true;
	active_transactions_view.fade_in();
	pass

# Hide all the tabs.
func hide_tabs():
	var trans_tab_views = get_tree().get_nodes_in_group("Tab");
	for trans_tab_view in trans_tab_views:
		trans_tab_view.visible = false;

# Add a new transaction.
func _on_AddTransaction_AddNewTransaction(transaction_p):
	# Add to the active transaction log.
	if active_transactions_view.visible:
		active_transactions_view.add_new_transaction(transaction_p);
	
	# Add to the profit transaction log.
	if profit_transactions_view.visible:
		profit_transactions_view.add_new_transaction(transaction_p);

# Show the active trans tab.
func _on_SideNavigationRail_ActiveTransClicked():
	hide_tabs();
	active_transactions_view.visible = true;
	active_transactions_view.fade_in();

# Show the profit trans tab.
func _on_SideNavigationRail_ProfitTransClicked():
	hide_tabs();
	profit_transactions_view.visible = true;
	profit_transactions_view.fade_in();

# Add a active transaction.
func _on_ActiveTransactionsView_AddTransactoinClick():
	# Step 1: Show the add transaction dialog.
	add_trans_dialog.fade_in();

# Add a profit transaction.
func _on_ProfitTransactionsView_AddTransactoinClick():
	# Step 1: Show the add transaction dialog.
	add_trans_dialog.fade_in();

# Calulate the sell transaction.
func _on_ActiveTransactionsView_SellTransactionClick():
	# Reset the dialog for a new trade.
	sell_trans_dialog.reset_dialog();
	
	# Get all of the selected transactions.
	var transaction_views = get_tree().get_nodes_in_group("Transaction");
	for transaction_view in transaction_views:
		if transaction_view.is_selected():
			sell_trans_dialog.add_sell_transaction(transaction_view.trans_data);
	
	# Show the sell transaction dialog.
	sell_trans_dialog.fade_in();

# Add sell transaction to proper locations.
func _on_SellTransactionDialog_AddSellTransaction(transaction_p):
	pass # Replace with function body.
