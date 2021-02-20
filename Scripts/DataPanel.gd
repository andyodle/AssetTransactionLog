extends Control

onready var data = $MarginContainer/CenterContainer/VBoxContainer/Data;

func set_data(data_p):
	data.text = String("%10.9f" % data_p);
