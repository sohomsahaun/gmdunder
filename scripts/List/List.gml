function List(_other=undefined) constructor {
	// A wrapper for arrays to give them some extra capabilities
	__values = [];

	// Initializer
	if (is_array(_other)) {
		// from an arry
		var _len = array_length(_other);
		array_copy(__values, 0, _other, 0, _len);
	}
	
	// dunder methods
	__get__ = function(_idx) {
		return array_get(__values, _idx);	
	}
	__set__ = function(_idx, _value) {
		array_set(__values, _idx, _value);
	}
	__has__ = function(_idx) {
		return _idx >= 0 and _idx <= array_length(__values);
	}
	__equals__ = functions(_other) {
		return array_equals(__value, _other);	
	}
	__length__ = function() {
		return array_length(__value);	
	}
	__values__ = function() {
		var _array = []
		var _len = array_length(__values);
		array_copy(_array, 0, __values, 0, _len);
		return _array;
	}
	__as_array__ = function() {
		// returns a pure struct, removing all the dunders
		var _array = []
		var _len = array_length(__values);
		array_copy(_array, 0, __values, 0, _len);
		return _array;
	}
	__append__ = function(_value) {
		// append values
		array_push(__values, _value)
		for (var _i=1; _i<argument_count; _i++) {
			array_push(__values, argument[_i]);	
		}
	}
	__extend__ = function(_other) {
		// takes an array and extends this one with it
		var _len = array_length(__values);
		var _other_len = array_length(_other);
		array_copy(__values, _len, _other, 0, _other_len);
	}
	__json__ = function() {
		// returns json
		return json_stringify(__values);
	}
	__foreach__ = function(_func) {
		var _len = array_length(__values);
		for (var _i=0; _i<_len; _i++) {
			_func(_i, __values[_i]);
		};
	}
	__map__ = function(_func) {
		var _len = array_length(__values);
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			__array[_i] = _func(_i, __values[_i]);
		};
	}
	__filter__ = function(_func) {
		var _len = array_length(__values);
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			if (_func(__values[_i])) {
				array_push(_array, __values[_i]);
			}
		};
		return _array;
	}
}