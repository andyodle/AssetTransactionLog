extends TextEdit

signal TextChanged(text_p)

@onready var animation_player = $AnimationPlayer;

var is_focused = false;

func _ready():
	# Hide scroll bars.
	var invisible_scrollbar_theme = Theme.new()
	invisible_scrollbar_theme.set_stylebox("scroll", "VScrollBar", StyleBoxEmpty.new())
	invisible_scrollbar_theme.set_stylebox("scroll", "HScrollBar", StyleBoxEmpty.new())
	self.theme = invisible_scrollbar_theme

func set_input_value(value_p):
	_on_TextInput_focus_entered();
	self.text = value_p;

func _on_TextInput_focus_entered():
	if is_focused == false:
		animation_player.play("ShrinkLabel");
		await animation_player.animation_finished;
		is_focused = true;
		self.select_all();

func _on_TextInput_focus_exited():
	if is_focused == true:
		if self.text == "":
			animation_player.play("GrowLabel");
			await animation_player.animation_finished;
			is_focused = false;

func _input(event):
	# Check to make sure tab doesn't print in the TextEdit.
	if event.is_action_pressed("ui_focus_next"):
		if str(focus_next) != "":
			get_node(focus_next).grab_focus()
		get_viewport().set_input_as_handled()

func _on_text_changed():
	emit_signal("TextChanged", self.text)
