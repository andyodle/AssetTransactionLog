extends Control

signal AddTransactionClick;
signal SellTransactoinClick;
signal CalculatedNumberOfCoins;
signal CalcualteTotalPrice;
signal CalculateCostAverage;
signal EditTransactionClick;
signal SplitTransactionClick;
signal DeleteTransactionClick;

@onready var add_action_button = $AddActionButton;
@onready var sell_action_button = $SellActionButton;
@onready var action_button_container = $MarginContainer/VBoxContainer/ActionButtonContainer;
@onready var transaction_list = $MarginContainer/VBoxContainer/ScrollContainer/Trasactions;
@onready var transaction_columns = $MarginContainer/VBoxContainer/TransactionColumns;

var transaction_view = preload("res://Scenes/Controls/TransactionView.tscn");

func _ready():
	# Hide the action buttons.
	action_button_container.show_buttons(false);

# Clear added transactions.
func reset_trasactoins():
	for transaction in transaction_list.get_children():
		transaction.select_transaction(false);
		transaction_list.remove_child(transaction);
	
	transaction_columns.clear_select_all_button();

# Calcualte the totals for the data panels.
func calculate_toals():
	# Get a list of all unsold transactions.
	var active_trans = Utility.get_unsold_transactions(self);
	
	# Total Coins
	var total_assets = Utility.calcualte_total_coins(active_trans);
	emit_signal("CalculatedNumberOfCoins", total_assets);
	
	# Total Price
	var total_price = Utility.calculate_total_price(active_trans);
	emit_signal("CalcualteTotalPrice", total_price);
	
	# Cost Average
	var cost_average = Utility.calcualte_cost_average(total_price, total_assets);
	emit_signal("CalculateCostAverage", cost_average);

func add_transaction(transaction_p, hide_select_p):
	var temp_trans_view = transaction_view.instantiate();
	transaction_list.add_child(temp_trans_view);
	transaction_list.move_child(temp_trans_view, 0);
	
	# Don't show the select transaction button.
	if hide_select_p == true:
		temp_trans_view.selected_trans.visible = false;
		
	# Connect the transaction to the selected event.
	temp_trans_view.connect("SelectedTransaction", Callable(self, "transaction_selected"));
	
	# Add the transaction to the list.
	temp_trans_view.set_tras_data(transaction_p);

# User selected a transaction.
func transaction_selected(pressed_p, trans_view_p):
	if pressed_p:
		# Make sure transaction is not disabled.
		if !trans_view_p.disalbed:
			show_selection_controls();
		else:
			# Don't allow disbled transtions to be selected.
			trans_view_p.select_transaction(false);
	else:
		hide_selection_controls();

func show_selection_controls():
	# Hide the add transaction button.
	add_action_button.visible = false;
	
	# Show the edit and delete buttons.
	var number_selected = get_selected_transactions().size();
	action_button_container.show_buttons(true, number_selected);

func hide_selection_controls():
	# Check to see if any transactions are still selected.
	if get_selected_transactions().size() == 0:
		# Hide the sell transactoin button, if no trans action are selected.
		sell_action_button.visible = false;
		
		# Hide the edit and delete buttons.
		action_button_container.show_buttons(false);
		
		# Show the add transaction button.
		add_action_button.visible = true;
	else:
		show_selection_controls();

# Get all of the transactions.
func get_transactions():
	var temp_views = [];
	var transaction_views = transaction_list.get_children();
	for temp_transaction_view in transaction_views:
		temp_views.append(temp_transaction_view);
	return temp_views;

# Get the list of selected transactions.
func get_selected_transactions():
	var temp_views = [];
	var transaction_views = transaction_list.get_children();
	for temp_transaction_view in transaction_views:
		if temp_transaction_view.is_selected():
			temp_views.append(temp_transaction_view);
	return temp_views;

# Remove the selected transaction.
func remove_selected_transactions():
	var selected_trans = get_selected_transactions();
	for transaction in selected_trans:
		var trans_data : Transaction = transaction.trans_data;
		# Check if deleting bought transaction.
		if trans_data.trans_type_m == Transaction.TransactionType.BUY_TRANS:
			transaction_list.remove_child(transaction);
		
		# Check if deleting a sold transaction.
		if trans_data.trans_type_m == Transaction.TransactionType.SELL_TRANS:
			var sell_trans : SellTransaction = trans_data as SellTransaction;
			# Delete any auto generated transactions.
			for gen_trans_index in sell_trans.generated_trans_m:
				delete_transaction(gen_trans_index);
			
			# Mark sold transactions as not sold.
			mark_sold_transactions(sell_trans.sold_trans_m, false);
			
			# Remove sell transaction from the log.
			transaction_list.remove_child(transaction);

# Atempt to remove a transaction from the log.
func delete_transaction(trans_index_p):
	if trans_index_p:
		# Find the matching transaction.
		var transactions = get_transactions();
		for temp_trans_view in transactions:
			if temp_trans_view.trans_data.index_m == trans_index_p:
				transaction_list.remove_child(temp_trans_view);
				break;

# Atempt to make all endable trasactions as selected.
func select_all_transactions(select_transaction_p):
	for transaction in transaction_list.get_children():
		if select_transaction_p:
			transaction.select_transaction(true);
		else:
			transaction.select_transaction(false);

# Flag transactions as sold or not sold.
func mark_sold_transactions(sold_transactions_p, is_sold_p: bool):
	var transactions = get_transactions();
	for sold_trans_index in sold_transactions_p:
		# Find and mark sold all matching transactions.
		for count in range(0, transactions.size()):
			# Get the transaction view.
			var trans_view = transactions[count];
			# Get the stroed tansaction data.
			var trans_data : Transaction = trans_view.trans_data;
			if trans_data.index_m == sold_trans_index:
				trans_data.is_sold_m = is_sold_p;
				trans_view.set_tras_data(trans_data);

# User wants to delete selected items.
func _on_ActionButtonContainer_DeleteClicked():
	emit_signal("DeleteTransactionClick");
	
	# Remove the selected items.
	remove_selected_transactions();
	
	# Hide the selection tools if necessary.
	hide_selection_controls();
	
	# Recalculate the data panels.
	calculate_toals();

# User wants to add a new transaction.
func _on_BaseActionButton_pressed():
	emit_signal("AddTransactionClick");

# User wants to sell a transaction.
func _on_SellActionButton_pressed():
	emit_signal("SellTransactoinClick");

# User wants to select all of the transactions.
func _on_TransactionColumns_SelectAll(pressed_p):
	select_all_transactions(pressed_p);

# User wants to split the selected transactions.
func _on_ActionButtonContainer_SplitClicked():
	emit_signal("SplitTransactionClick");

# User wants to edit the selected transactions.
func _on_ActionButtonContainer_EditClicked():
	emit_signal("EditTransactionClick");
