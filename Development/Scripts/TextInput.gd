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
