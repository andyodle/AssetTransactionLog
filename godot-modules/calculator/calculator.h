#ifndef CALCULATOR_H
#define CALCULATOR_H

#include "core/object/ref_counted.h"
#include "core/variant/variant.h"

class Calculator : public RefCounted{

    GDCLASS(Calculator, RefCounted);

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