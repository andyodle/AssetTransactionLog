extends Node

func save_json_file(path_to_file_p:String, data_to_save_p:Dictionary):
	var save_file = File.new();
	save_file.open(path_to_file_p, File.WRITE);
	
	# Write the dictonay as a single string to the json file.
	save_file.store_line(to_json(data_to_save_p));
	
	# Close the file when were done with it.
	save_file.close();

func load_json_file(path_to_file_p:String):
	var temp_data = {}
	
	var load_file = File.new();
	
	# Check to see if the file actualy exists.
	if !load_file.file_exists(path_to_file_p):
		return temp_data;
	
	# Open the file for reading.
	load_file.open(path_to_file_p, File.READ);
	
	# Parse the json into a dictonary.
	temp_data = parse_json(load_file.get_as_text());
	
	# Close the file when were done with it.
	load_file.close();
	
	return temp_data;
