extends Control

signal CalculatedTotalGains;
signal CalcualtedTotalPaidPrice;
signal CalcualtedTotalSoldPrice;
signal CalculatedPercentGains;

@onready var action_button_container = %ActionButtonContainer;
@onready var transaction_list = %Transactions;

var sold_transaction_view = preload("res://Scenes/Controls/SoldTransactionView.tscn");

func _ready():
	# Hide the edit and delete buttons.
	action_button_container.show_buttons(false);

# Get all of the transactions.
func get_transactions():
	var temp_views = [];
	var transaction_views = transaction_list.get_children();
	for transaction_view in transaction_views:
		temp_views.append(transaction_view);
	return temp_views;

# Clear added transactions.
func reset_trasactoins():
	for transaction in transaction_list.get_children():
		transaction_list.remove_child(transaction);

# Calcualte the totals for the data panels.
func calculate_toals():
	# Total Gains
	var total_gains = Utility.calculate_total_gains(transaction_list);
	emit_signal("CalculatedTotalGains", total_gains);
	
	# Total Paid Price
	var total_paid_price = Utility.calculate_total_price(transaction_list);
	emit_signal("CalcualtedTotalPaidPrice", total_paid_price);
	
	# Total Sold Price
	var total_sold_price = Utility.calculate_total_sold_price(transaction_list);
	emit_signal("CalcualtedTotalSoldPrice", total_sold_price);
	
	# Calcualte Percentage Gains
	if float(total_sold_price) != 0:
		var calculator = Calculator.new();
		var percent_gains = calculator.multiply(calculator.divide(total_gains, total_sold_price), "100");
		emit_signal("CalculatedPercentGains", percent_gains);
	
	# Cost Average
	#var cost_average = Utility.calcualte_cost_average(transaction_list);
	#emit_signal("CalculatedCostAverage", cost_average);

# Remove the selected transaction.
func remove_selected_transactions():
	for transaction in transaction_list.get_children():
		if transaction.is_selected():
			transaction_list.remove_child(transaction);

func add_transaction(sold_transaction_p):
	var temp_sold_trans_view = sold_transaction_view.instantiate();
	transaction_list.add_child(temp_sold_trans_view);
	transaction_list.move_child(temp_sold_trans_view, 0);
	
	# Connect the transaction to the selected event.
	temp_sold_trans_view.connect("SoldSelectedTransaction", Callable(self, "sold_transaction_selected"));
	
	# Add the transaction to the list.
	temp_sold_trans_view.set_tras_data(sold_transaction_p);

# User selected a transaction.
func sold_transaction_selected(pressed_p):
	if pressed_p:
		show_selection_controls();
	else:
		hide_selection_controls();

func show_selection_controls():
	# Show the edit and delete buttons.
	action_button_container.show_buttons(true);

func hide_selection_controls():
	# Check to see if any transactions are still selected.
	if get_selected_transactions().size() == 0:
		# Hide the edit and delete buttons.
		action_button_container.show_buttons(false);

# Get the list of selected transactions.
func get_selected_transactions():
	var temp_views = [];
	var transaction_views = transaction_list.get_children();
	for transaction_view in transaction_views:
		if transaction_view.is_selected():
			temp_views.append(transaction_view);
	return temp_views;

func select_all_transactions(select_transaction_p):
	for transaction in transaction_list.get_children():
		if select_transaction_p:
			transaction.select_transaction(true);
		else:
			transaction.select_transaction(false);

# User wants to delete selected items.
func _on_ActionButtonContainer_DeleteClicked():
	# Remove the selected items.
	remove_selected_transactions();
	
	# Attempt to hide the selection controls.
	hide_selection_controls();
	
	# Recalculate the data panels.
	calculate_toals();

# User wants to select all of the transactions.
func _on_SoldTransactionColumns_SelectAll(pressed_p):
	select_all_transactions(pressed_p);
