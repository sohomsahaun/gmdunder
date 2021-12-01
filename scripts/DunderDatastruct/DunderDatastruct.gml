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
					delete self[$ _key];
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
		return dunder.init(DunderField, _default_value, _default_factory, _validator);	
	}
	
	// validator factories
	static is_string_between = function(_min_len, _max_len) {
        return method({min_len: _min_len, max_len: _max_len}, function(_value) {
            var _len = string_length(_value);
            return is_string(_value) and  _len >= min_len and _len <= max_len;
       });
    }
    
    static is_number_between = function(_min_value, _max_value) {
        return method({min_value: _min_value, max_value: _max_value}, function(_value) {
            return is_numeric(_value) and  _value >= min_value and _value <= max_value;
       });
    }
    static is_sprite = function() {
        return function(_value) {
            return sprite_exists(_value);
       };
    }
    static is_object = function() {
        return function(_value) {
            return object_exists(_value);
       };
    }
    static is_script = function() {
        return function(_value) {
            return script_exists(_value);
       };
    }
}