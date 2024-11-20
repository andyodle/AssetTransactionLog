extends CanvasLayer

signal ActionClicked;

@onready var control = $Control;
@onready var timer = $Control/Timer;
@onready var animation_player = $Control/AnimationPlayer;
@onready var button = $Control/MarginContainer/HBoxContainer/Button;
@onready var message_label = $Control/MarginContainer/HBoxContainer/MessageLabel;

func _ready():
	# Hide the snackbar initialy.
	control.modulate = Color(1, 1, 1, 0);
	control.visible = false;

# Display the message to the user.
func display_message(message_p, action_label_p):
	control.visible = true;
	# Set the buttons text to the desired label.
	button.text = action_label_p;
	
	# Set the message text to display.
	message_label.text = message_p;
	
	# Fade in the snackbar message.
	animation_player.play("fade_in");
	await animation_player.animation_finished;
	
	# Wait for 4 seconds before auto closing the message.
	timer.start();

# Action Button Pressed.
func _on_Button_pressed():
	# Emit a click signal incase we want to allow undo.
	emit_signal("ActionClicked");
	
	# Stop the timer so we don't get a double fade out.
	timer.stop();
	
	# Fade out the snackbar message.
	animation_player.play("fade_out");
	await animation_player.animation_finished;
	
	control.visible = false;

# Hide the message after 4 seconds.
func _on_Timer_timeout():
	
	animation_player.play("fade_out");
	await animation_player.animation_finished;
	
	control.visible = false;
