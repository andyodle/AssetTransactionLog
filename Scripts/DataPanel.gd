extends Control

onready var data = $MarginContainer/CenterContainer/VBoxContainer/Data;

func set_data(data_p):
	data.text = String(data_p);
