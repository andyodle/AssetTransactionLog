extends Control

const TESTS_PATH = "res://Tests/";

onready var test_console = $MarginContainer/VBoxContainer/TestConsole;

var test_count = 0;
var red_color : Color = Color("#E92127");
var green_color : Color = Color("#59B747");
var white_color : Color = Color("#FFFFFF");
var yellow_color : Color = Color("#FEFE33");

# Recurse through the directory and run any
# test script that starts with test_ in the
# name of the script.
func run_tests(current_dir_p):
	var levels_dir = Directory.new();
	levels_dir.open(current_dir_p);
	levels_dir.list_dir_begin(true);
	
	var file_name = levels_dir.get_next();
	while file_name != "":
		# Check to see if there is a directory.
		if levels_dir.current_is_dir():
			# Create the sub directory path.
			var temp_current_dir = current_dir_p + file_name + "/";
			# Recurse through the sub directory.
			run_tests(temp_current_dir);
		else:
			# Check to see if we are loading a test script or not.
			if "test_" in file_name:
				var temp_file_path = current_dir_p + file_name;
				
				# Attempt to load and run the test.
				var temp_class = load(temp_file_path).new();
				temp_class.connect("display_message", self, "display_test_message");
				temp_class.initalize_test();
				display_test_message("    Running " + file_name + " ...");
				temp_class.run_test();
				
				display_test_message("");
				test_count += 1;
		
		# Get the next file or directory.
		file_name = levels_dir.get_next();
	
	# Finished going though the directory.
	levels_dir.list_dir_end();

# Add a message to the test console.
func display_test_message(message_p, message_type_p = ""):
	test_console.add_item(message_p, null, false);
	
	var current_index = test_console.get_item_count() - 1;
	if message_type_p == "failure":
		test_console.set_item_custom_fg_color(current_index, red_color);
	elif message_type_p == "sucess":
		test_console.set_item_custom_fg_color(current_index, green_color);
	elif message_type_p == "warning":
		test_console.set_item_custom_fg_color(current_index, yellow_color);

# Run all of the tests scripts.
func _on_RuntTestsButton_pressed():
	test_console.clear();
	
	display_test_message("Running test scripts...");
	display_test_message("");
	
	# Run the tests found in the current directory.
	run_tests(TESTS_PATH);
	
	# Finished running the tests.
	display_test_message("Finished running test scripts...");
	display_test_message("");
	display_test_message("Tests Run ( " + String(test_count) + " )");
