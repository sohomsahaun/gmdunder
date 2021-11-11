function DunderDict() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderDict);
	// A dict wrapper
	static __init__ = function(_input, _copy=false) {
		if (dunder.can_struct(_input)) {
			var _incoming_struct = dunder.as_struct(_input);
		}
		else if (is_undefined(_input)) {
			var _incoming_struct = {};	
		}
		else if (dunder.can_array(_input)) {
			var _array = dunder.as_array(_input);
			var _incoming_struct = {};
			var _len = array_length(_array);
			for (var _i=0; _i<_len; _i++) {
				var _pair = _array[_i];
				if (not is_array(_pair) or array_length(_pair) != 2) {
					throw dunder.init(DunderExceptionTypeError, "Can't coerse array, incorrect inner dimensions (must be [key, value])");
				}
				_incoming_struct[$ _pair[0]] = _pair[1];
			}
			_copy = false;
		}
		else {
			throw dunder.init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to dict");
		}
		
		if (_copy) {
			__values = {};
			var _keys = variable_struct_get_names(_incoming_struct);
			var _len = variable_struct_names_count(_incoming_struct);
			for (var _i=0; _i<_len; _i++) {
				var _key = _keys[_i];
				__values[$ _key] = _incoming_struct[$ _key];
			}
		}
		else {
			__values = _incoming_struct;	
		}
	}	
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
		return dunder.init(self.__type__(), __struct__(), true);
		}
		return dunder.init(self.__type__(), _input, true);
	}
	
	// Representation methods
	static __repr__ = function() {
		return 	"<dunder '"+instanceof(self)+"' keys="+variable_struct_get_names(__values)+">";
	}
	static __struct__ = function() {
		return __values;	
	}
	static __array__ = function() {
		var _keys = variable_struct_get_names(__values);
		var _len = variable_struct_names_count(__values);
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			_array[_i] = [_key, __values[$ _key]];
		}
		return _array;
	}
	static __bool__ = function() {
		return variable_struct_names_count(__values) > 0;
	}
	
	// Mathematical operators
	static __add__ = function(_other) {
		var _struct = dunder.as_struct(_other);
		var _new_dict = __clone__();
		_new_dict.update(_struct)
		return _struct;
	}
	
	// Structure methods
	static __len__ = function() {
		return variable_struct_names_count(__values);
	}
	static __contains__ = function(_value) {
		return variable_struct_exists(__values, _value);
	}
	static __getattr__ = function(_key) {
		if (variable_struct_exists(__values, _key)) {
			return variable_struct_get(__values, _key);
		}
		if (argument_count>1) { // default value
			return argument[1];
		}
		throw dunder.init(DunderExceptionKeyError);
	}
	static __setattr__ = function(_key, _value) {
		variable_struct_set(__values, _key, _value);
	}
	static __hasattr__ = function(_key) {
		return variable_struct_exists(__values, _key);
	}
	static __removeattr__ = function(_key) {
		if (variable_struct_exists(__values, _key)) {
			variable_struct_remove(__values, _key);
			return true;
		}
		throw dunder.init(DunderExceptionKeyError);
	}
	static len = __len__;
	static contains = __contains__;
	static get = __getattr__;
	static set = __setattr__;
	static has = __hasattr__;
	static remove = __removeattr__;
	
	// Iteration methods
	static __iter__ = function() {
		return dunder.init(DunderIterator, method(self, __getattr__), keys());
	}
	
	// Dict methods
	static keys = function() {
		return dunder.init(DunderList, variable_struct_get_names(__values));
	}
	static items = function() {
		return dunder.init(DunderList, __array__);	
	}
	static values = function() {
		var _keys = variable_struct_get_names(__values);
		var _len = variable_struct_names_count(__values);
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			_array[_i] = __values[$ _keys[_i]];
		}
		return dunder.init(DunderList, _array);
	}
	static update = function(_input) {
		var _struct = dunder.as_struct(_input);
		var _keys = variable_struct_get_names(_struct);
		var _len = variable_struct_names_count(_struct);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			__values[$ _key] = _struct[$ _key];
		}
		return self;
	}
	
	static clear = function() {
		__values = {};	
	}
	static from_json = function(_input) {
		var _string = dunder.as_string(_input);
		var _struct = json_parse(_string);
		__values = _struct;
		return self;
	}
	static from_file = function(_input) {
		var _path = dunder.as_string(_input);
		if (not file_exists(_path)) {
			throw dunder.init(DunderExceptionFileError, "Can't load file "+typeof(_path));
		}
			
		var _buff = buffer_load(_path);
		var _string = buffer_read(_buff, buffer_text);
		buffer_delete(_buff);
		
		__values = json_parse(_string)
		return self;
	}
}
