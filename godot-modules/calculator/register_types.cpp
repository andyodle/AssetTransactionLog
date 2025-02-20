#include "register_types.h"
#include "core/object/class_db.h"
#include "calculator.h"

void initialize_calculator_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

    ClassDB::register_class<Calculator>();
}

void uninitialize_calculator_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
    /* Nothing to do here. */
}