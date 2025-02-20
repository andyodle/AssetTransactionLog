extends Node

func save_json_file(path_to_file_p:String, data_to_save_p:Dictionary):
	var save_file = FileAccess.open(path_to_file_p, FileAccess.WRITE);
	
	# Write the dictonay as a single string to the json file.
	save_file.store_line(JSON.stringify(data_to_save_p));
	
	# Close the file when were done with it.
	save_file.close();

func load_json_file(path_to_file_p:String):
	var temp_data = {}
	
	var load_file = null;
	
	# Check to see if the file actualy exists.
	if !FileAccess.file_exists(path_to_file_p):
		return temp_data;
	
	# Open the file for reading.
	load_file = FileAccess.open(path_to_file_p, FileAccess.READ);
	
	# Parse the json into a dictonary.
	var test_json_conv = JSON.new()
	test_json_conv.parse(load_file.get_as_text());
	temp_data = test_json_conv.get_data()
	
	# Close the file when were done with it.
	load_file.close();
	
	return temp_data;
