function Dict(_other=undefined) constructor {
	// A wrapper for structs to give them some extra capabilities
	__values = {}
	
	// Initializer
	if (is_struct(_other)) {
		// shallow copy struct
		var _keys = variable_struct_get_names(_other);
		var _len = array_length(_keys);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			__values[$ _key] = _other[$ _key];
		}
	}
	else if (is_array(_other)) {
		// from an arry
		var _len = array_length(_other);
		for (var _i=0; _i<_len; _i++) {
			var _value = _other[_i];
			__values[$ _value[0]] = _value[1];
		}
	}
	
	// dunder methods
	__get__ = function(_key) {
		return variable_struct_get(__values, _key);	
	}
	__set__ = function(_key, _value) {
		variable_struct_set(__values, _key, _value);	
	}
	__has__ = function(_key) {
		return variable_struct_exists(__values, _key);	
	}
	__length__ = function() {
		return array_length(variable_struct_get_names(__values));
	}
	__keys__ = function() {
		return variable_struct_get_names(__values);
	}
	__values__ = function() {
		var _keys = variable_struct_get_names(__values);
		var _len = array_length(_keys);
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			_array[_i] = __values[$ _keys[_i]];
		}
		return _array;
	}
	__as_struct__ = function() {
		// returns the inner struct
		return __values;
	}
	__wrap_struct__ = function(_other) {
		// wraps the struct
		__values = _other;
		return self;
	}
	__update__ = function(_other) {
		// merge from another struct/Dict
		var _keys = variable_struct_get_names(_other);
		var _len = array_length(_keys);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			__values[$ _key] = _other[$ _key];
		}
	}
	__as_json__ = function() {
		// returns json
		return json_stringify(__values);
	}
	__from_json__ = function(_json_str) {
		// wraps the struct
		var _other = json_parse(_json_str);
		if (is_struct(_other)) {
			__values = _other;
		}
		else {
	
		}
		return self;
	}
	__foreach__ = function(_func) {
		var _keys = variable_struct_get_names(self);
		var _len = array_length(_keys);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			_func(_key, self[$ _key]);
		};
	}
}