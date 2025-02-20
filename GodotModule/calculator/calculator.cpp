#include "calculator.h"

String Calculator::add(const String &one_p, const String &two_p)
{
    double one = one_p.to_float();
    double two = two_p.to_float();
    double result = one + two;
    return String::num(result, 12);
}

String Calculator::subtract(const String &one_p, const String &two_p)
{
    double one = one_p.to_float();
    double two = two_p.to_float();
    double result = one - two;
    return String::num(result, 12);
}

String Calculator::multiply(const String &one_p, const String &two_p)
{
    double one = one_p.to_float();
    double two = two_p.to_float();
    double result = one * two;
    return String::num(result, 12);
}

String Calculator::divide(const String &one_p, const String &two_p)
{
    double one = one_p.to_float();
    double two = two_p.to_float();
    double result = one / two;
    return String::num(result, 12);
}

void Calculator::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("add", "one_p", "two_p"), &Calculator::add);
    ClassDB::bind_method(D_METHOD("subtract", "one_p", "two_p"), &Calculator::subtract);
    ClassDB::bind_method(D_METHOD("multiply", "one_p", "two_p"), &Calculator::multiply);
    ClassDB::bind_method(D_METHOD("divide", "one_p", "two_p"), &Calculator::divide);
}

Calculator::Calculator()
{
    
}