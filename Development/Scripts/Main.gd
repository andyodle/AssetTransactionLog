extends Control

@onready var active_transactions_view = %ActiveTransactionsTab;
@onready var profit_transactions_view = %ProfitTransactionsTab;
@onready var sold_transactions_log_view = %SoldTransactionLogTab;
@onready var settings_tab = %SettingsTab;
@onready var add_active_trans_dialog = %AddActiveTransaction;
@onready var add_profit_trans_dialog = %AddProfitTransaction;
@onready var edit_active_trans_dialog = %EditActiveTransaction;
@onready var edit_profit_trans_dialog = %EditProfitTransaction;
@onready var sell_active_trans_dialog = %SellActiveTransactionDialog;
@onready var sell_profit_trans_dialog = %SellProfitTransactionDialog;
@onready var split_active_transaction_dialog = %SplitActiveTransactionDialog;
@onready var split_profit_transaction_dialog = %SplitProfitTransactionDialog;
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
	profit_transactions_view.transaction_log.select_all_transactions(false);
	sold_transactions_log_view.sold_transaction_log.select_all_transactions(false);

# Add a new active transaction.
func _on_AddActiveTransaction_AddNewTransaction(transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Add to the active transaction log.
	active_transactions_view.add_new_transaction(transaction_p);

# User wants to add a profit transaction.
func _on_AddProfitTransaction_AddNewTransaction(transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Add to the profit transaction log.
	profit_transactions_view.add_new_transaction(transaction_p);

# Show the active trans tab.
func _on_SideNavigationRail_ActiveTransClicked():
	hide_tabs();
	deselect_all_transactions();
	active_transactions_view.visible = true;
	active_transactions_view.fade_in();

# Show the profit trans tab.
func _on_SideNavigationRail_ProfitTransClicked():
	hide_tabs();
	deselect_all_transactions();
	profit_transactions_view.visible = true;
	profit_transactions_view.fade_in();

# Show the sold transactions log view.
func _on_SideNavigationRail_SoldPositionsTransClicked():
	hide_tabs();
	deselect_all_transactions();
	sold_transactions_log_view.visible = true;
	sold_transactions_log_view.fade_in();

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

# Calulate the sell transaction.
func _on_ActiveTransactionsTab_SellTransactionClick():
	# Reset the dialog for a new trade.
	sell_active_trans_dialog.reset_dialog();
	
	# Get all of the selected transactions.
	var transaction_views = active_transactions_view.get_selected_transactions();
	if transaction_views.size() > 0:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				sell_active_trans_dialog.add_sell_transaction(transaction_view.trans_data);
		
		# Show the sell transaction dialog.
		sell_active_trans_dialog.fade_in();

# Split the selected sell transaction into multiple smaller ones.
func _on_ActiveTransactionsTab_SplitTransactionClick():
	# Reset the dialog for a new split transaction.
	split_active_transaction_dialog.reset_dialog();
	
	# Get all of the selected transactions.
	var transaction_views = active_transactions_view.get_selected_transactions();
	if transaction_views.size() == 1:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				split_active_transaction_dialog.add_transaction_to_split(transaction_view.trans_data);
		
		# Show the sell transaction dialog.
		split_active_transaction_dialog.fade_in();

# Edit a active transaction.
func _on_EditActiveTransaction_EditTransaction(transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Get all of the selected transactions.
	var transaction_views = active_transactions_view.get_selected_transactions();
	if transaction_views.size() == 1:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				var temp_class : Transaction;
				temp_class = load("res://Scripts/Classes/Transaction.gd").new();
				temp_class.index_m = transaction_p.index_m
				temp_class.date_m = transaction_p.date_m;
				temp_class.number_of_coins_m = transaction_p.number_of_coins_m;
				temp_class.exchange_price_m = transaction_p.exchange_price_m;
				temp_class.amount_m = transaction_p.amount_m;
				temp_class.is_credit_m = transaction_p.is_credit_m;
				temp_class.is_sold_m = transaction_p.is_sold_m;
				transaction_view.set_tras_data(temp_class);
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
				transaction_view.set_tras_data(temp_class);
			# Add to the active transaction log.
		active_transactions_view.add_new_transaction(reduced_transaction_p);
		active_transactions_view.transaction_log.transaction_columns.emit_signal("SelectAll", false);
		SnackBar.display_message("Transaction reduced.", "DISMISS");

# Add sell transaction to proper locations.
func _on_SellActiveTransactionDialog_AddSellTransaction(sell_transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Step1: Create a profit transaction.
	if sell_transaction_p.profit_trans_m.number_of_coins_m != "0":
		sell_transaction_p.profit_trans_m.date_m = Utility.get_current_date_str();
		profit_transactions_view.add_new_transaction(sell_transaction_p.profit_trans_m);
	
	# Step2: Create a sold history transaction.
	sold_transactions_log_view.add_new_transaction(sell_transaction_p);
	
	# Step3: Remove previously selected transactions.
	active_transactions_view.remove_selected_transactions();
	
	# Dipslay a messge to the user that we added transactions.
	SnackBar.display_message("Added profit and sold transactions.", "DISMISS");

# Add a profit transaction.
func _on_ProfitTransactionTab_AddTransactoinClick():
	# Reset the form to get it ready for new input.
	add_profit_trans_dialog.reset_form();
	
	# Step 1: Show the add transaction dialog.
	add_profit_trans_dialog.fade_in();

# Sell a profit transaction.
func _on_ProfitTransactionTab_SellTransactionClick():
	# Reset the dialog for a new trade.
	sell_profit_trans_dialog.reset_dialog();
	
	# Get all of the selected transactions.
	var transaction_views = profit_transactions_view.get_selected_transactions();
	if transaction_views.size() > 0:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				sell_profit_trans_dialog.add_sell_transaction(transaction_view.trans_data);
		
		# Show the sell transaction dialog.
		sell_profit_trans_dialog.fade_in();

# Split the profit transaction.
func _on_ProfitTransactionsTab_SplitTransactionClick():
	# Reset the dialog for a new split transaction.
	split_profit_transaction_dialog.reset_dialog();
	
	# Get all of the selected transactions.
	var transaction_views = profit_transactions_view.get_selected_transactions();
	if transaction_views.size() == 1:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				split_profit_transaction_dialog.add_transaction_to_split(transaction_view.trans_data);
		
		# Show the sell transaction dialog.
		split_profit_transaction_dialog.fade_in();

# Split transactions to add to profit tab.
func _on_SplitProfitTransactionDialog_SplitTransaction(reduced_transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Double Custom Calculator
	var calculator = Calculator.new();
	
	# Get all of the selected transactions.
	var transaction_views = profit_transactions_view.get_selected_transactions();
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
				transaction_view.set_tras_data(temp_class);
			# Add to the active transaction log.
		profit_transactions_view.add_new_transaction(reduced_transaction_p);
		profit_transactions_view.transaction_log.transaction_columns.emit_signal("SelectAll", false);
		SnackBar.display_message("Transaction reduced.", "DISMISS");

# Edit the selected transaction.
func _on_ProfitTransactionsTab_EditTransactionClick():
	# Reset the form to get it ready for new input.
	edit_profit_trans_dialog.reset_form();
	
	# Get all of the selected transactions.
	var transaction_views = profit_transactions_view.get_selected_transactions();
	if transaction_views.size() == 1:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				edit_profit_trans_dialog.edit_transaction(transaction_view.trans_data);
	
	# Step 1: Show the add transaction dialog.
	edit_profit_trans_dialog.fade_in();

# Edit the selected transaction.
func _on_EditProfitTransaction_EditTransaction(transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Get all of the selected transactions.
	var transaction_views = profit_transactions_view.get_selected_transactions();
	if transaction_views.size() == 1:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				var temp_class : Transaction;
				temp_class = load("res://Scripts/Classes/Transaction.gd").new();
				temp_class.date_m = transaction_p.date_m;
				temp_class.number_of_coins_m = transaction_p.number_of_coins_m;
				temp_class.exchange_price_m = transaction_p.exchange_price_m;
				temp_class.amount_m = transaction_p.amount_m;
				temp_class.is_credit_m = transaction_p.is_credit_m;
				transaction_view.set_tras_data(temp_class);
		# Refresh the calulations.
		profit_transactions_view.recalulate_totals();
		# Display message to the user.
		SnackBar.display_message("Edited transaction.", "DISMISS");

# Add sell transaction to proper locations.
func _on_SellProfitTransactionDialog_AddSellTransaction(sell_transaction_p):
	# Show user that changes need to be saved.
	Utility.show_save_changes();
	
	# Step1: Create a profit transaction.
	if sell_transaction_p.profit_trans_m.number_of_coins_m != "0":
		sell_transaction_p.profit_trans_m.date_m = Utility.get_current_date_str();
		profit_transactions_view.add_new_transaction(sell_transaction_p.profit_trans_m);
	
	# Step2: Create a sold history transaction.
	sold_transactions_log_view.add_new_transaction(sell_transaction_p);
	
	# Step3: Remove previously selected transactions.
	profit_transactions_view.remove_selected_transactions();
	
	# Dipslay a messge to the user that we added transactions.
	SnackBar.display_message("Added profit and sold transactions.", "DISMISS");

func save_transaction_record(trans_data_p: Transaction, trans_index_p: String, trans_type_key_p: String, transactions_data_p: Dictionary):
	transactions_data_p[trans_type_key_p][trans_index_p] = {};
	transactions_data_p[trans_type_key_p][trans_index_p]["index_m"] = trans_data_p.index_m;
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
			var temp_sold_trans : Transaction = temp_sell_trans.sold_trans_m[sell_count];
			temp_sold_data["SoldTransactions"][str(sell_count)] = {};
			temp_sold_data["SoldTransactions"][str(sell_count)]["index_m"] = temp_sold_trans.index_m;
			temp_sold_data["SoldTransactions"][str(sell_count)]["trans_type_m"] = temp_sold_trans.trans_type_m;
			temp_sold_data["SoldTransactions"][str(sell_count)]["date_m"] = temp_sold_trans.date_m;
			temp_sold_data["SoldTransactions"][str(sell_count)]["number_of_coins_m"] = temp_sold_trans.number_of_coins_m;
			temp_sold_data["SoldTransactions"][str(sell_count)]["exchange_price_m"] = temp_sold_trans.exchange_price_m;
			temp_sold_data["SoldTransactions"][str(sell_count)]["amount_m"] = temp_sold_trans.amount_m;
			temp_sold_data["SoldTransactions"][str(sell_count)]["is_credit_m"] = temp_sold_trans.is_credit_m;
			temp_sold_data["SoldTransactions"][str(sell_count)]["is_sold_m"] = temp_sold_trans.is_sold_m;
		
		transactions_data_p[trans_type_key_p][trans_index_p]["SoldTransactions"] = temp_sold_data
		print("Debug2")

# Helper function to save the users entered transactions.
func save_transactions(file_path_p):
	
	# Set the window title to the current opened file.
	Utility.set_main_window_title(file_path_p);
	
	var temp_data : Dictionary = {};
	temp_data["ActiveTransactions"] = {};
	temp_data["ProfitTransactions"] = {};
	temp_data["SoldTransactions"] = {};
	
	# Get all of the selected transactions.
	var transaction_views = active_transactions_view.get_transactions();
	if transaction_views.size() > 0:
		for count in range(0, transaction_views.size()):
			var transaction_view = transaction_views[count];
			var trans_data : Transaction = transaction_view.trans_data;
			save_transaction_record(trans_data, str(count), "ActiveTransactions", temp_data);
			#temp_data["ActiveTransactions"][str(count)] = {};
			#temp_data["ActiveTransactions"][str(count)]["index_m"] = trans_data.index_m;
			#temp_data["ActiveTransactions"][str(count)]["date_m"] = trans_data.date_m;
			#temp_data["ActiveTransactions"][str(count)]["number_of_coins_m"] = trans_data.number_of_coins_m;
			#temp_data["ActiveTransactions"][str(count)]["exchange_price_m"] = trans_data.exchange_price_m;
			#temp_data["ActiveTransactions"][str(count)]["amount_m"] = trans_data.amount_m;
			#temp_data["ActiveTransactions"][str(count)]["is_credit_m"] = trans_data.is_credit_m;
			#temp_data["ActiveTransactions"][str(count)]["is_sold_m"] = trans_data.is_sold_m;
	
	# Get all of the selected transactions.
	transaction_views = profit_transactions_view.get_transactions();
	if transaction_views.size() > 0:
		for count in range(0, transaction_views.size()):
			var transaction_view = transaction_views[count];
			temp_data["ProfitTransactions"][str(count)] = {};
			temp_data["ProfitTransactions"][str(count)]["date_m"] = transaction_view.trans_data.date_m;
			temp_data["ProfitTransactions"][str(count)]["number_of_coins_m"] = transaction_view.trans_data.number_of_coins_m;
			temp_data["ProfitTransactions"][str(count)]["exchange_price_m"] = transaction_view.trans_data.exchange_price_m;
			temp_data["ProfitTransactions"][str(count)]["amount_m"] = transaction_view.trans_data.amount_m;
			temp_data["ProfitTransactions"][str(count)]["is_credit_m"] = transaction_view.trans_data.is_credit_m;
	
	# Get all of the selected transactions.
	transaction_views = sold_transactions_log_view.get_transactions();
	if transaction_views.size() > 0:
		for count in range(0, transaction_views.size()):
			var transaction_view = transaction_views[count];
			temp_data["SoldTransactions"][str(count)] = {};
			temp_data["SoldTransactions"][str(count)]["date_m"] = transaction_view.trans_data.date_m;
			temp_data["SoldTransactions"][str(count)]["number_of_coins_m"] = transaction_view.trans_data.number_of_coins_m;
			temp_data["SoldTransactions"][str(count)]["exchange_paid_m"] = transaction_view.trans_data.exchange_paid_m;
			temp_data["SoldTransactions"][str(count)]["amount_m"] = transaction_view.trans_data.amount_m;
			temp_data["SoldTransactions"][str(count)]["exchange_sold_m"] = transaction_view.trans_data.exchange_sold_m;
	
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
	var temp_class : Transaction;
	temp_class = load("res://Scripts/Classes/Transaction.gd").new();
	temp_class.index_m = trans_data_p["index_m"];
	temp_class.date_m = trans_data_p["date_m"];
	temp_class.number_of_coins_m = trans_data_p["number_of_coins_m"];
	temp_class.exchange_price_m = trans_data_p["exchange_price_m"];
	temp_class.amount_m = trans_data_p["amount_m"];
	temp_class.is_credit_m = trans_data_p["is_credit_m"];
	temp_class.is_sold_m = trans_data_p["is_sold_m"];
	
	return temp_class;

# Create a new sold transaction record from json data.
func create_sold_transaction_record(sold_trans_data_p):
	var calculator = Calculator.new();
	var temp_class = preload("res://Scripts/Classes/SoldTransaction.gd").new();
	temp_class.initalize();
	temp_class.sold_trans_m.date_m = sold_trans_data_p["date_m"];
	temp_class.sold_trans_m.exchange_price_m = sold_trans_data_p["exchange_sold_m"];
	temp_class.sold_trans_m.number_of_coins_m = sold_trans_data_p["number_of_coins_m"];
	temp_class.sold_trans_m.amount_m = sold_trans_data_p["amount_m"];
	temp_class.bought_trans_m.number_of_coins_m = sold_trans_data_p["number_of_coins_m"];
	temp_class.bought_trans_m.exchange_price_m = sold_trans_data_p["exchange_paid_m"];
	temp_class.bought_trans_m.amount_m = calculator.multiply(sold_trans_data_p["number_of_coins_m"], sold_trans_data_p["exchange_paid_m"]);
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
		
		# Profit Transactions
		profit_transactions_view.reset_trasactoins();
		var profit_transactions = temp_data["ProfitTransactions"];
		if profit_transactions.size() > 0:
			for count in range(profit_transactions.size(), 0, -1):
				var temp_trans = create_transaction_record(temp_data["ProfitTransactions"][str(count - 1)]);
				profit_transactions_view.add_new_transaction(temp_trans);
		
		# Sold Transactions
		sold_transactions_log_view.reset_trasactoins();
		var sold_transactions = temp_data["SoldTransactions"];
		if sold_transactions.size() > 0:
			for count in range(sold_transactions.size(), 0, -1):
				var temp_trans = create_sold_transaction_record(temp_data["SoldTransactions"][str(count - 1)]);
				sold_transactions_log_view.add_new_transaction(temp_trans);
		
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

# User selected a file to save from the SaveFileDialog.
func _on_SaveFileDialog_file_selected(path_p):
	save_transactions(path_p);
