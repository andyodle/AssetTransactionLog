extends TextEdit

@onready var animation_player = $AnimationPlayer;

var is_focused = false;

func set_input_value(value_p):
	_on_TextInput_focus_entered();
	self.text = value_p;

func _on_TextInput_focus_entered():
	if is_focused == false:
		animation_player.play("ShrinkLabel");
		await animation_player.animation_finished;
		is_focused = true;

func _on_TextInput_focus_exited():
	if is_focused == true:
		if self.text == "":
			animation_player.play("GrowLabel");
			await animation_player.animation_finished;
			is_focused = false;

func _input(event):
	# Check to make sure tab doesn't print in the TextEdit.
	if event.is_action_pressed("ui_focus_next") and is_focused:
		if str(focus_next) != "":
			get_node(focus_next).grab_focus()
		get_viewport().set_input_as_handled()
