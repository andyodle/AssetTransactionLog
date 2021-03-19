extends Control

onready var active_transactions_view = $HBoxContainer/TabsContainer/MarginContainer/ActiveTransactionsTab;
onready var profit_transactions_view = $HBoxContainer/TabsContainer/MarginContainer/ProfitTransactionsTab;
onready var sold_transactions_log_view = $HBoxContainer/TabsContainer/MarginContainer/SoldTransactionLogTab;
onready var settings_tab = $HBoxContainer/TabsContainer/MarginContainer/SettingsTab;
onready var add_active_trans_dialog = $AddActiveTransaction;
onready var add_profit_trans_dialog = $AddProfitTransaction;
onready var sell_trans_dialog = $SellTransactionDialog;
onready var open_file_dialog = $OpenFileDialog;
onready var safe_file_dialog = $SaveFileDialog;

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

# Add a new active transaction.
func _on_AddActiveTransaction_AddNewTransaction(transaction_p):
	# Add to the active transaction log.
	active_transactions_view.add_new_transaction(transaction_p);

# User wants to add a profit transaction.
func _on_AddProfitTransaction_AddNewTransaction(transaction_p):
	# Add to the profit transaction log.
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

# Show the sold transactions log view.
func _on_SideNavigationRail_SoldPositionsTransClicked():
	hide_tabs();
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
	sell_trans_dialog.reset_dialog();
	
	# Get all of the selected transactions.
	var transaction_views = active_transactions_view.get_selected_transactions();
	if transaction_views.size() > 0:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				sell_trans_dialog.add_sell_transaction(transaction_view.trans_data);
		
		# Show the sell transaction dialog.
		sell_trans_dialog.fade_in();

# Add a profit transaction.
func _on_ProfitTransactionTab_AddTransactoinClick():
	# Reset the form to get it ready for new input.
	add_profit_trans_dialog.reset_form();
	
	# Step 1: Show the add transaction dialog.
	add_profit_trans_dialog.fade_in();

# Sell a profit transaction.
func _on_ProfitTransactionTab_SellTransactionClick():
	# Reset the dialog for a new trade.
	sell_trans_dialog.reset_dialog();
	
	# Get all of the selected transactions.
	var transaction_views = profit_transactions_view.get_selected_transactions();
	if transaction_views.size() > 0:
		for transaction_view in transaction_views:
			if transaction_view.is_selected():
				sell_trans_dialog.add_sell_transaction(transaction_view.trans_data);
		
		# Show the sell transaction dialog.
		sell_trans_dialog.fade_in();

# Add sell transaction to proper locations.
func _on_SellTransactionDialog_AddSellTransaction(sell_transaction_p):
	# Step1: Create a profit transaction.
	sell_transaction_p.profit_trans_m.date_m = Utility.get_current_date_str();
	profit_transactions_view.add_new_transaction(sell_transaction_p.profit_trans_m);
	
	# Step2: Create a sold history transaction.
	sold_transactions_log_view.add_new_transaction(sell_transaction_p);
	
	# Step3: Remove previously selected transactions.
	active_transactions_view.remove_selected_transactions();
	profit_transactions_view.remove_selected_transactions();
	
	# Dipslay a messge to the user that we added transactions.
	SnackBar.display_message("Added profit and sold transactions.", "DISMISS");

# Helper function to save the users entered transactions.
func save_transactions(file_path_p):
	var temp_data : Dictionary = {};
	temp_data["ActiveTransactions"] = {};
	temp_data["ProfitTransactions"] = {};
	temp_data["SoldTransactions"] = {};
	
	# Get all of the selected transactions.
	var transaction_views = active_transactions_view.get_transactions();
	if transaction_views.size() > 0:
		for count in range(0, transaction_views.size()):
			var transaction_view = transaction_views[count];
			temp_data["ActiveTransactions"][String(count)] = {};
			temp_data["ActiveTransactions"][String(count)]["date_m"] = transaction_view.trans_data.date_m;
			temp_data["ActiveTransactions"][String(count)]["number_of_coins_m"] = transaction_view.trans_data.number_of_coins_m;
			temp_data["ActiveTransactions"][String(count)]["exchange_price_m"] = transaction_view.trans_data.exchange_price_m;
			temp_data["ActiveTransactions"][String(count)]["amount_m"] = transaction_view.trans_data.amount_m;
			temp_data["ActiveTransactions"][String(count)]["is_credit_m"] = transaction_view.trans_data.is_credit_m;
	
	# Get all of the selected transactions.
	transaction_views = profit_transactions_view.get_transactions();
	if transaction_views.size() > 0:
		for count in range(0, transaction_views.size()):
			var transaction_view = transaction_views[count];
			temp_data["ProfitTransactions"][String(count)] = {};
			temp_data["ProfitTransactions"][String(count)]["date_m"] = transaction_view.trans_data.date_m;
			temp_data["ProfitTransactions"][String(count)]["number_of_coins_m"] = transaction_view.trans_data.number_of_coins_m;
			temp_data["ProfitTransactions"][String(count)]["exchange_price_m"] = transaction_view.trans_data.exchange_price_m;
			temp_data["ProfitTransactions"][String(count)]["amount_m"] = transaction_view.trans_data.amount_m;
			temp_data["ProfitTransactions"][String(count)]["is_credit_m"] = transaction_view.trans_data.is_credit_m;
	
	# Get all of the selected transactions.
	transaction_views = sold_transactions_log_view.get_transactions();
	if transaction_views.size() > 0:
		for count in range(0, transaction_views.size()):
			var transaction_view = transaction_views[count];
			temp_data["SoldTransactions"][String(count)] = {};
			temp_data["SoldTransactions"][String(count)]["date_m"] = transaction_view.trans_data.date_m;
			temp_data["SoldTransactions"][String(count)]["number_of_coins_m"] = transaction_view.trans_data.number_of_coins_m;
			temp_data["SoldTransactions"][String(count)]["exchange_paid_m"] = transaction_view.trans_data.exchange_paid_m;
			temp_data["SoldTransactions"][String(count)]["total_paid_m"] = transaction_view.trans_data.total_paid_m;
			temp_data["SoldTransactions"][String(count)]["exchange_sold_m"] = transaction_view.trans_data.exchange_sold_m;
	
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
	temp_class.date_m = trans_data_p["date_m"];
	temp_class.number_of_coins_m = trans_data_p["number_of_coins_m"];
	temp_class.exchange_price_m = trans_data_p["exchange_price_m"];
	temp_class.amount_m = trans_data_p["amount_m"];
	temp_class.is_credit_m = trans_data_p["is_credit_m"];
	return temp_class;

# Create a new sold transaction record from json data.
func create_sold_transaction_record(sold_trans_data_p):
	var temp_class = preload("res://Scripts/Classes/SoldTransaction.gd").new();
	temp_class.initalize();
	temp_class.sold_trans_m.date_m = sold_trans_data_p["date_m"];
	temp_class.bought_trans_m.number_of_coins_m = sold_trans_data_p["number_of_coins_m"];
	temp_class.bought_trans_m.exchange_price_m = sold_trans_data_p["exchange_paid_m"];
	temp_class.bought_trans_m.amount_m = sold_trans_data_p["total_paid_m"];
	temp_class.sold_trans_m.exchange_price_m = sold_trans_data_p["exchange_sold_m"];
	return temp_class;

# Helper function to load a chosen file.
func load_transactions(file_path_p):
	var temp_data = JsonManager.load_json_file(file_path_p);
	
	# Check and make sure that we loaded a transaction file.
	if temp_data != null:
		# Active Transactions
		active_transactions_view.reset_trasactoins();
		var active_transactions = temp_data["ActiveTransactions"];
		if active_transactions.size() > 0:
			for count in range(active_transactions.size(), 0, -1):
				var temp_trans = create_transaction_record(temp_data["ActiveTransactions"][String(count - 1)]);
				active_transactions_view.add_new_transaction(temp_trans);
		
		# Profit Transactions
		profit_transactions_view.reset_trasactoins();
		var profit_transactions = temp_data["ProfitTransactions"];
		if profit_transactions.size() > 0:
			for count in range(profit_transactions.size(), 0, -1):
				var temp_trans = create_transaction_record(temp_data["ProfitTransactions"][String(count - 1)]);
				profit_transactions_view.add_new_transaction(temp_trans);
		
		# Sold Transactions
		sold_transactions_log_view.reset_trasactoins();
		var sold_transactions = temp_data["SoldTransactions"];
		if sold_transactions.size() > 0:
			for count in range(sold_transactions.size(), 0, -1):
				var temp_trans = create_sold_transaction_record(temp_data["SoldTransactions"][String(count - 1)]);
				sold_transactions_log_view.add_new_transaction(temp_trans);
		
		# Dipslay a messge to the user that we saved their data.
		SnackBar.display_message("Transactions loaded.", "DISMISS");
		print("Loaded Transactions!");
	else:
		SnackBar.display_message("Error: Can not load selected file.", "DISMISS");

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
