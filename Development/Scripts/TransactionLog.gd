extends Control

signal AddTransactionClick;
signal SellTransactoinClick;
signal CalculatedNumberOfCoins;
signal CalcualteTotalPrice;
signal CalculateCostAverage;
signal EditTransactionClick;
signal SplitTransactionClick;

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
func transaction_selected(pressed_p):
	if pressed_p:
		show_selection_controls();
	else:
		hide_selection_controls();

func show_selection_controls():
	# Hide the add transaction button.
	add_action_button.visible = false;
	
	# Show the edit and delete buttons.
	var number_selected = get_selected_transactions().size();
	action_button_container.show_buttons(true, number_selected);
	
	# Show the sell transactoin button.
	#sell_action_button.visible = true;

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
	for transaction in transaction_list.get_children():
		if transaction.is_selected():
			transaction_list.remove_child(transaction);

func select_all_transactions(select_transaction_p):
	for transaction in transaction_list.get_children():
		if select_transaction_p:
			transaction.select_transaction(true);
		else:
			transaction.select_transaction(false);

# Flag transactions as already sold.
func mark_sold_transactions(sold_transactions_p):
	var trans_list_view = transaction_list.get_children();
	for sold_trans in sold_transactions_p:
		# Find and mark sold all matching transactions.
		for count in range(0, trans_list_view.size()):
			# Get the transaction view.
			var trans_view = trans_list_view[count];
			# Get the stroed tansaction data.
			var trans_data : Transaction = trans_view.trans_data;
			if trans_data.index_m == sold_trans.index_m:
				trans_data.is_sold_m = true;

# User wants to delete selected items.
func _on_ActionButtonContainer_DeleteClicked():
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
