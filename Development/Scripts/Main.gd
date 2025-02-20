extends Control

@onready var side_navigation_rail = %SideNavigationRail;
@onready var active_transactions_view = %ActiveTransactionsTab;
@onready var settings_tab = %SettingsTab;
@onready var add_active_trans_dialog = %AddActiveTransaction;
@onready var edit_active_trans_dialog = %EditActiveTransaction;
@onready var open_file_dialog = %OpenFileDialog;
@onready var safe_file_dialog = %SaveFileDialog;

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

# Deselct all transactions.
func deselect_all_transactions():
	active_transactions_view.transaction_log.select_all_transactions(false);

# Add a new active transaction.
func _on_AddActiveTransaction_AddNewTransaction(transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Add to the active transaction log.
	active_transactions_view.add_new_transaction(transaction_p);

# Show the active trans tab.
func _on_SideNavigationRail_ActiveTransClicked():
	hide_tabs();
	deselect_all_transactions();
	active_transactions_view.visible = true;
	active_transactions_view.fade_in();

# User selected the settings tab.
func _on_SideNavigationRail_SettingsClicked():
	hide_tabs();
	settings_tab.visible = true;
	settings_tab.fade_in();

# Add a active transaction.
func _on_ActiveTransactionsTab_AddTransactoinClick():
	# Reset the form to get it ready for new input.
	add_active_trans_dialog.reset_form();
	
	# Step 1: Show the add transaction dialog.
	add_active_trans_dialog.fade_in();

# Edit a active transaction.
func _on_EditActiveTransaction_EditTransaction(update_trans_p, old_transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Get the old transaction.
	var old_trans_view = active_transactions_view.get_transaction(old_transaction_p.index_m);
	
	# Check if old and updated transaction are the same type.
	if update_trans_p.trans_type_m == old_transaction_p.trans_type_m:
		# Check if buy transaction.
		if update_trans_p.trans_type_m == Transaction.TransactionType.BUY_TRANS:
			old_trans_view.set_trans_data(update_trans_p);
		
		# Check if sell transaction.
		if update_trans_p.trans_type_m == Transaction.TransactionType.SELL_TRANS: 
			# Delete the old unmatched transaction.
			active_transactions_view.remove_selected_transactions();
			
			# No longer editing old trans create a new one.
			active_transactions_view.add_new_transaction(update_trans_p);
	else:
		# Delete the old unmatched transaction.
		active_transactions_view.remove_selected_transactions();
		
		# No longer editing old trans create a new one.
		active_transactions_view.add_new_transaction(update_trans_p);
	
	# Refresh the calulations.
	active_transactions_view.recalulate_totals();
		
	# Display message to the user.
	SnackBar.display_message("Edited transaction.", "DISMISS");

# Edit the selected transaction.
func _on_ActiveTransactionsTab_EditTransactionClick():
	# Reset the form to get it ready for new input.
	edit_active_trans_dialog.reset_form();
	
	# Get all of the selected transactions.
	var transaction_views = active_transactions_view.get_selected_transactions();
	if transaction_views.size() == 1:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				edit_active_trans_dialog.edit_transaction(transaction_view.trans_data);
	
	# Step 1: Show the add transaction dialog.
	edit_active_trans_dialog.fade_in();

# Split transactions to add to active tab.
func _on_SplitActiveTransactionDialog_SplitTransaction(reduced_transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Double Custom Calculator
	var calculator = Calculator.new();
	
	# Get all of the selected transactions.
	var transaction_views = active_transactions_view.get_selected_transactions();
	if transaction_views.size() == 1:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				var temp_class : Transaction;
				temp_class = load("res://Scripts/Classes/Transaction.gd").new();
				temp_class.date_m = Utility.get_current_date_str();
				temp_class.number_of_coins_m = calculator.subtract(transaction_view.trans_data.number_of_coins_m, reduced_transaction_p.number_of_coins_m).pad_decimals(8);
				temp_class.exchange_price_m = transaction_view.trans_data.exchange_price_m;
				temp_class.amount_m = calculator.subtract(transaction_view.trans_data.amount_m, reduced_transaction_p.amount_m);
				temp_class.is_credit_m = transaction_view.trans_data.is_credit_m;
				transaction_view.set_trans_data(temp_class);
			# Add to the active transaction log.
		active_transactions_view.add_new_transaction(reduced_transaction_p);
		active_transactions_view.transaction_log.transaction_columns.emit_signal("SelectAll", false);
		SnackBar.display_message("Transaction reduced.", "DISMISS");

func save_transaction_record(trans_data_p: Transaction, trans_index_p: String, trans_type_key_p: String, transactions_data_p: Dictionary):
	transactions_data_p[trans_type_key_p][trans_index_p] = {};
	transactions_data_p[trans_type_key_p][trans_index_p]["index_m"] = trans_data_p.index_m;
	transactions_data_p[trans_type_key_p][trans_index_p]["sell_trans_index_m"] = trans_data_p.sell_trans_index_m;
	transactions_data_p[trans_type_key_p][trans_index_p]["trans_type_m"] = trans_data_p.trans_type_m;
	transactions_data_p[trans_type_key_p][trans_index_p]["date_m"] = trans_data_p.date_m;
	transactions_data_p[trans_type_key_p][trans_index_p]["number_of_coins_m"] = trans_data_p.number_of_coins_m;
	transactions_data_p[trans_type_key_p][trans_index_p]["exchange_price_m"] = trans_data_p.exchange_price_m;
	transactions_data_p[trans_type_key_p][trans_index_p]["amount_m"] = trans_data_p.amount_m;
	transactions_data_p[trans_type_key_p][trans_index_p]["is_credit_m"] = trans_data_p.is_credit_m;
	transactions_data_p[trans_type_key_p][trans_index_p]["is_sold_m"] = trans_data_p.is_sold_m;
	
	# Check if transaction is a sell transaction.
	if trans_data_p.trans_type_m == Transaction.TransactionType.SELL_TRANS:
		var temp_sell_trans = trans_data_p as SellTransaction;
		var temp_sold_data : Dictionary = {};
		temp_sold_data["SoldTransactions"] = {};
		temp_sold_data["GeneratedTransactions"] = {}
		
		# SoldTransactions
		for sell_count in range(0, temp_sell_trans.sold_trans_m.size()):
			temp_sold_data["SoldTransactions"][str(sell_count)] = {};
			temp_sold_data["SoldTransactions"][str(sell_count)]["index_m"] = temp_sell_trans.sold_trans_m[sell_count];
		
		# GeneratedTransactions
		for gen_count in range(0, temp_sell_trans.generated_trans_m.size()):
			temp_sold_data["GeneratedTransactions"][str(gen_count)] = {};
			temp_sold_data["GeneratedTransactions"][str(gen_count)]["index_m"] = temp_sell_trans.generated_trans_m[gen_count];
		
		transactions_data_p[trans_type_key_p][trans_index_p]["SoldTransData"] = temp_sold_data

# Helper function to save the users entered transactions.
func save_transactions(file_path_p):
	
	# Set the window title to the current opened file.
	Utility.set_main_window_title(file_path_p);
	
	var temp_data : Dictionary = {};
	temp_data["ActiveTransactions"] = {};
	
	# Get all of the selected transactions.
	var transaction_views = active_transactions_view.get_transactions();
	if transaction_views.size() > 0:
		for count in range(0, transaction_views.size()):
			var transaction_view = transaction_views[count];
			var trans_data : Transaction = transaction_view.trans_data;
			save_transaction_record(trans_data, str(count), "ActiveTransactions", temp_data);
	
	# Save out the transactions.
	JsonManager.save_json_file(file_path_p, temp_data);
	
	# Dipslay a messge to the user that we saved their data.
	SnackBar.display_message("Transactions saved.", "DISMISS");
	print("Saved Transactions");

# Save the transaction log data.
func _on_SideNavigationRail_SaveTrasnClicked():
	safe_file_dialog.popup();

# Create a new transaction record from json data.
func create_transaction_record(trans_data_p):
	var temp_class;
		# Determine transaction type.
	if trans_data_p["trans_type_m"] == Transaction.TransactionType.SELL_TRANS:
		temp_class = load("res://Scripts/Classes/SellTransaction.gd").new();
		# Sold Transaction Indexes
		temp_class.sold_trans_m = [];
		var temp_sold_indexes = trans_data_p["SoldTransData"]["SoldTransactions"];
		for sell_count in range(0, temp_sold_indexes.size()):
			temp_class.sold_trans_m.append(temp_sold_indexes[str(sell_count)]["index_m"]);
		# Generated Transaction Indexes
		temp_class.generated_trans_m = [];
		var temp_generated_indexes = trans_data_p["SoldTransData"]["GeneratedTransactions"];
		for gen_count in range(0, temp_generated_indexes.size()):
			temp_class.generated_trans_m.append(temp_generated_indexes[str(gen_count)]["index_m"])
		
	elif trans_data_p["trans_type_m"] == Transaction.TransactionType.GENERATED_TRANS:
		temp_class = load("res://Scripts/Classes/GeneratedTransaction.gd").new();
	elif trans_data_p["trans_type_m"]== Transaction.TransactionType.BUY_TRANS:
		temp_class = load("res://Scripts/Classes/Transaction.gd").new();
	
	temp_class.index_m = trans_data_p["index_m"];
	temp_class.sell_trans_index_m = trans_data_p["sell_trans_index_m"];
	temp_class.trans_type_m = trans_data_p["trans_type_m"] as Transaction.TransactionType;
	temp_class.date_m = trans_data_p["date_m"];
	temp_class.number_of_coins_m = trans_data_p["number_of_coins_m"];
	temp_class.exchange_price_m = trans_data_p["exchange_price_m"];
	temp_class.amount_m = trans_data_p["amount_m"];
	temp_class.is_credit_m = trans_data_p["is_credit_m"];
	temp_class.is_sold_m = trans_data_p["is_sold_m"];
	
	return temp_class;

# Helper function to load a chosen file.
func load_transactions(file_path_p):
	
	# Set the window title to the current opened file.
	Utility.set_main_window_title(file_path_p);
	
	var temp_data = JsonManager.load_json_file(file_path_p);
	
	# Check and make sure that we loaded a transaction file.
	if temp_data != null:
		# Active Transactions
		active_transactions_view.reset_trasactoins();
		var active_transactions = temp_data["ActiveTransactions"];
		if active_transactions.size() > 0:
			for count in range(active_transactions.size(), 0, -1):
				var temp_trans = create_transaction_record(temp_data["ActiveTransactions"][str(count - 1)]);
				active_transactions_view.add_loaded_transaction(temp_trans);
		
		# Dipslay a messge to the user that we saved their data.
		SnackBar.display_message("Transactions loaded.", "DISMISS");
		print("Loaded Transactions!");
	else:
		SnackBar.display_message("Error: Can not load selected file.", "DISMISS");

# Reset the transaction log to a new clean state.
func _on_SideNavigationRail_NewTransClicked():
	# Reload the current secen and reset the transactions.
	var temp_scene = get_tree()
	temp_scene.reload_current_scene();
	
	# Reset the window title to default.
	Utility.reset_main_window_title();

# Load the transaction log data.
func _on_SideNavigationRail_LoadTransClicked():
	# Prompt the user to open a file.
	open_file_dialog.popup();

# User selected a file to load from the OpenFileDialog.
func _on_OpenFileDialog_file_selected(path_p):
	load_transactions(path_p);
	
	# Toggle Active Transaction View 
	side_navigation_rail._on_ActiveTransButton_pressed();

# User selected a file to save from the SaveFileDialog.
func _on_SaveFileDialog_file_selected(path_p):
	save_transactions(path_p);
