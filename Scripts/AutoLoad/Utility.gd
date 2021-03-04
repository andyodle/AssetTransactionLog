extends Node

# Get the current date.
func get_current_date_str():
	var temp_date_time = OS.get_datetime();
	var date_string = String("%02d" % temp_date_time["day"]) + "/" + String("%02d" % temp_date_time["month"]) + "/" + String("%4d" % temp_date_time["year"]);
	return date_string;
