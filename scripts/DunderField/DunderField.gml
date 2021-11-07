function DunderField() : DunderBaseStruct() constructor {
	// A field object used to construct datastructs
	__bases_add__(DunderField);
	
	static __init__ = function(_default_value=undefined, _default_factory=undefined, _validator=undefined) {
		default_value = _default_value;
		default_factory = _default_factory;
		validator = _validator;
		value_required = false;
	}
	
	static required = function() {
		value_required = true;
		return self;
	}
	
	static generate_default = function() {
		if (is_method(default_factory)) {
			return default_factory();	
		}
		return default_value;
	}
	
	static is_required = function() {
		return value_required;	
	}
	
	static validate = function(_value) {
		if (is_method(validator)) {
			return validator(_value);	
		}
		return true;
	}
}