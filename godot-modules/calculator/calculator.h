#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <string>
#include "core/reference.h"

class Calculator : public Reference{

    GDCLASS(Calculator, Reference);

protected:
    static void _bind_methods();

public:
    String add(const String &one_p, const String &two_p);
    String subtract(const String &one_p, const String &two_p);
    String multiply(const String &one_p, const String &two_p);
    String divide(const String &one_p, const String &two_p);

    Calculator();

};

#endif