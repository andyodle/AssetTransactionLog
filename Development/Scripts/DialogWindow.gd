extends Control

class_name DialogWindow

@onready var animation_player = $AnimationPlayer;

func _ready():
	self.modulate = Color(1, 1, 1, 0);

func fade_in():
	visible = true;
	animation_player.play("FadeIn");
	await animation_player.animation_finished;

func fade_out():
	visible = false;
	animation_player.play("FadeOut");
	await animation_player.animation_finished;

# User clicked the overlay mask. Close the dialog.
func _on_OverlayMaskButton_pressed():
	fade_out();
