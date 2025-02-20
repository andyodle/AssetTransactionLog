extends "res://Tests/TestBase.gd"

var calculator;
var number_one = "0.00046068";
var number_two = "0.00348896";

func initalize_test():
	calculator = Calculator.new();
	#sucess("Test initalized!");
	#failure("Test run!");
	pass;

func test_addition():
	var result = calculator.add(number_one, number_two);
	if result != "0.00394964":
		failure("addition result: "  + result);
	else:
		sucess("addition works!");
	pass;

func test_subtraction():
	var result = calculator.subtract(number_one, number_two);
	if result != "-0.00302828":
		failure("subtraction result: "  + result);
	else:
		sucess("subtraction works!");
	pass;

func test_multiplacation():
	var result = calculator.multiply(number_one, number_two);
	if result != "0.000001607294":
		failure("multipy result: "  + result);
	else:
		sucess("multipy works!");
	pass;

func test_division():
	var result = calculator.divide(number_one, number_two);
	if result != "0.132039346969":
		failure("divide result: "  + result);
	else:
		sucess("divide works!");
	pass;

func run_test():
	test_addition();
	test_subtraction();
	test_multiplacation();
	test_division();
	pass;
