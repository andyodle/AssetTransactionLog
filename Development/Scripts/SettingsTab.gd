extends Control

onready var animation_player = $AnimationPlayer;

func fade_in():
	animation_player.play("fade_in");
	yield(animation_player, "animation_finished");
