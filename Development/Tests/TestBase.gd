extends Node

class_name TestBase

signal display_message;

# Setup your test.
func initalize_test():
	pass;

# Exicute the test.
func run_test():
	pass;

# Pass
func sucess(message_p):
	message_p = "        Sucess: " + message_p;
	emit_signal("display_message", message_p, "sucess");
	pass;

# Fail
func failure(message_p):
	message_p = "        Failure: " + message_p;
	emit_signal("display_message", message_p, "failure");
	pass;

# Warning
func warning(message_p):
	message_p = "        Warning: " + message_p;
	emit_signal("display_message", message_p, "warning");
	pass;
