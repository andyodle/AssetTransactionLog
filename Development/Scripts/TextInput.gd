extends TextEdit

onready var animation_player = $AnimationPlayer;

var has_focus = false;

func _on_TextInput_focus_entered():
	if has_focus == false:
		animation_player.play("ShrinkLabel");
		yield(animation_player, "animation_finished");
		has_focus = true;

func _on_TextInput_focus_exited():
	if has_focus == true:
		if self.text == "":
			animation_player.play("GrowLabel");
			yield(animation_player, "animation_finished");
			has_focus = false;

func _input(event):
	# Check to make sure tab doesn't print in the TextEdit.
	if event.is_action_pressed("ui_focus_next") and has_focus():
		if focus_next != "":
			get_node(focus_next).grab_focus()
		get_tree().set_input_as_handled()
