#include "register_types.h"
#include "core/class_db.h"
#include "calculator.h"

void register_calculator_types()
{
    ClassDB::register_class<Calculator>();
}

void unregister_calculator_types()
{
    /* Nothing to do here. */
}