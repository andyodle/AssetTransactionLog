extends Control

onready var active_transactions_view = $HBoxContainer/Control/ActiveTransactionsView;
onready var profit_transactions_view = $HBoxContainer/Control/ProfitTransactionsView;
onready var add_trans_dialog = $AddTransaction;

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
	active_transactions_view.add_new_transaction(transaction_p);

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

func _on_ActiveTransactionsView_AddTransactoinClick():
	# Step 1: Show the add transaction dialog.
	add_trans_dialog.fade_in();
