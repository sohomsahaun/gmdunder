function DunderDict() : DunderBaseStruct() constructor {
	// A dict wrapper
	__bases_add__(DunderDict);

	// Initializer
	static __init__ = function(_input, _copy=false) {
		if (__dunder__.is_struct_with_method(_input, "__struct__")) {
			var _incoming_struct = _input.__struct__();
		}
		else if (__dunder__.is_dunder_struct(_input)) {
			throw __dunder__.init(DunderExceptionBadType, "Can't coerse type "+instanceof(_input)+" to dict");
		}
		else if (is_struct(_input)) {
			var _incoming_struct = _input;
		}
		else if (is_undefined(_input)) {
			var _incoming_struct = {};	
		}
		else if (is_array(_input)) {
			var _len = array_length(_input);
			for (var _i=0; _i<_len; _i++) {
				var _pair = _input[_i];
				if (not is_array(_pair) or array_length(_pair) != 2) {
					throw __dunder__.init(DunderExceptionBadType, "Can't coerse array, incorrect inner dimensions (must be [key, value])");
				}
				_incoming_struct[$ _pair[0]] = _pair[1];
			}
			_copy = false;
		}
		else {
			throw __dunder__.init(DunderExceptionBadType, "Can't coerse type "+typeof(_input)+" to dict");
		}
		
		if (_copy) {
			values = {};
			var _keys = variable_struct_get_names(_incoming_struct);
			var _len = variable_struct_names_count(_incoming_struct);
			for (var _i=0; _i<_len; _i++) {
				var _key = _keys[_i];
				values[$ _key] = _incoming_struct[$ _key];
			}
		}
		else {
			values = _incoming_struct;	
		}
	}	
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
			_input = __struct__();
		}
		return __dunder__.init(self.__type__(), _input, true);
	}
	
	// Dict methods
	static keys = function() {
		return variable_struct_get_names(values);
	}
	static values = function() {
		var _keys = variable_struct_get_names(values);
		var _len = variable_struct_names_count(values);
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			_array[_i] = values[$ _keys[_i]];
		}
		return _array;
	}
	static update = function(_other) {
		var _keys = variable_struct_get_names(_other);
		var _len = variable_struct_names_count(_other);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			values[$ _key] = _other[$ _key];
		}
	}
	static foreach = function(_func) {
		var _keys = variable_struct_get_names(self);
		var _len = variable_struct_names_count(self);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			_func(_key, self[$ _key]);
		};
	}
	
	// Representation methods
	static __repr__ = function() {
		return 	"<dunder '"+instanceof(self)+"' keys="+variable_struct_get_names(values)+">";
	}
	static __struct__ = function() {
		return values;	
	}
	
	// Structure methods
	static __len__ = function() {
		return array_length(variable_struct_get_names(values));
	}
	static __contains__ = function(_value) {
		var _keys = variable_struct_get_names(values);
		var _len = variable_struct_names_count(values);
		for (var _i=0; _i<_len; _i++) {
			if (values[$ _keys[_i]] == _value) return true;
		}
		return false
	}
	static __getattr__ = function(_key) {
		return variable_struct_get(values, _key);	
	}
	static __setattr__ = function(_key, _value) {
		variable_struct_set(values, _key, _value);	
	}
	static __hasattr__ = function(_key) {
		return variable_struct_exists(values, _key);	
	}
	
	// Iteration methods
	static __iter__ = function() {
		return __dunder__.init(DunderIteratorDict, 	values, keys());
	}
}