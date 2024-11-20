extends Control

@onready var data_label = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/DataLabel;
@onready var percent_label = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/PercentLabel;

var data;
var percent;
var red_color : Color = Color("#E92127");
var green_color : Color = Color("#59B747");
var white_color : Color = Color("#FFFFFF");

func _ready():
	percent_label.visible = false;

# Moved the updateing of the text color to only occur once.
# If the update is done in the _process function 1% of the cpu will be used.
# If we are constanly using 1% of the CPU batteries will be drained faster
# on laptop and portibale devices.
func update_label_color():
	# Color the data label.
	var temp_data : float = float(data_label.text.replace("$", ""));
	if temp_data > 0:
		# Green for positive profit.
		data_label.set("theme_override_colors/font_color", green_color);
	elif temp_data < 0:
		# Red for nagative profit.
		data_label.set("theme_override_colors/font_color", red_color);
	else:
		# White for zero profit.
		data_label.set("theme_override_colors/font_color", white_color);
	
	# Color the percent label.
	var temp_percent : float = float(percent_label.text.replace("%", ""));
	if temp_percent > 0:
		# Green for positive profit.
		percent_label.set("theme_override_colors/font_color", green_color);
	elif temp_percent < 0:
		# Red for nagative profit.
		percent_label.set("theme_override_colors/font_color", red_color);
	else:
		# White for zero profit.
		percent_label.set("theme_override_colors/font_color", white_color);

func set_data(format_p, data_p):
	data = data_p;
	var formated_text = Utility.format_decimal(format_p, data_p);
	if format_p == "%3.2f":
		formated_text = "$" + formated_text;
	data_label.text = formated_text;
	update_label_color();

func get_data():
	return data;

func set_percent(percent_p):
	percent = percent_p;
	percent_label.visible = true;
	percent_label.text = Utility.format_decimal("%3.2f", percent_p) + "%";

# Set the panel to the default values.
func reset_data_panel():
	data_label.text = "0.0";
	percent_label.visible = false;
	update_label_color();
