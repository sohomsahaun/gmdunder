function DunderDataStruct() : DunderBaseStruct() constructor {
	// A managed data struct
	__bases_add__(DunderDataStruct);
	
	static __init__ = function(_values={}) {
		var _keys = variable_struct_get_names(self);
		var _len = variable_struct_names_count(self);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			if (_key == "__bases__") continue;
			
			var _field = self[$ _key];
			
			if (variable_struct_exists(_values, _key)) {
				var _value = _values[$ _key];
				if (_field.validate(_value)) {
					self[$ _key] = _value;
				}
				else {
					throw __dunder__.init(DunderExceptionValueError, "Validation failed for "+string(_key));	
				}
			}
			else {
				if (_field.is_required()) {
					throw __dunder__.init(DunderExceptionValueError, "Field "+string(_key)+" required but not provided");	
				}
				else {
					self[$ _key] = _field.generate_default();
				}			
			}
		}
	}
}