extends Control

@onready var animation_player = $AnimationPlayer;

func fade_in():
	animation_player.play("fade_in");
	await animation_player.animation_finished;
