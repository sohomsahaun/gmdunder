function DunderDataStruct() : DunderBaseStruct() constructor {REGISTER_SUBTYPE(DunderDataStruct);
	// A managed data struct
	
	static __init__ = function(_values={}) {
		var _keys = variable_struct_get_names(self);
		var _len = variable_struct_names_count(self);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			var _field = self[$ _key];
			
			if (variable_struct_exists(_values, _key)) {
				var _value = _values[$ _key];
				if (_field.validate(_value)) {
					delete _self[$ _key];
					self[$ _key] = _value;
				}
				else {
					throw dunder.init(DunderExceptionValueError, "Validation failed for "+string(_key));	
				}
			}
			else {
				if (_field.is_required()) {
					throw dunder.init(DunderExceptionValueError, "Field "+string(_key)+" required but not provided");	
				}
				else {
					delete _self[$ _key];
					self[$ _key] = _field.generate_default();
				}			
			}
		}
	}
	
	static field = function(_default_value=undefined, _default_factory=undefined, _validator=undefined) {
		return init(DunderField, _default_value, _default_factory, _validator);	
	}
}