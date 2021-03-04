extends Control

onready var data_label = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/DataLabel;
onready var percent_label = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/PercentLabel;

var red_color : Color = Color(255,0,0,255);
var green_color : Color = Color(0,255,0,255);
var white_color : Color = Color(255,255,255,255);

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
		data_label.set("custom_colors/font_color", green_color);
	elif temp_data < 0:
		# Red for nagative profit.
		data_label.set("custom_colors/font_color", red_color);
	else:
		# White for zero profit.
		data_label.set("custom_colors/font_color", white_color);
		
	# Color the percent label.
	var temp_percent : float = float(percent_label.text.replace("%", ""));
	if temp_percent > 0:
		# Green for positive profit.
		percent_label.set("custom_colors/font_color", green_color);
	elif temp_percent < 0:
		# Red for nagative profit.
		percent_label.set("custom_colors/font_color", red_color);
	else:
		# White for zero profit.
		percent_label.set("custom_colors/font_color", white_color);

func set_data(data_p):
	data_label.text = String(data_p);
	update_label_color();

func get_data():
	var temp_data = data_label.text.replace("$", "");
	return temp_data;

func set_percent(percent_p:float):
	percent_label.visible = true;
	percent_label.text = String("%3.2f" % percent_p) +  "%";
