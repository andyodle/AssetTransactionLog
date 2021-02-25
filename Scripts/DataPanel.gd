extends Control

onready var data = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/Data;

func set_data(data_p):
	var temp_data : float = float(data_p.replace("$", ""));
	if int(temp_data) >= 0:
		# Gree for positive profit.
		data.set("custom_colors/font_color", Color(0,255,0,255));
	else:
		# Red for nagative profit.
		data.set("custom_colors/font_color", Color(255,0,0,255));
	data.text = String(data_p);

func get_data():
	var temp_data = data.text.replace("$", "");
	return temp_data;
