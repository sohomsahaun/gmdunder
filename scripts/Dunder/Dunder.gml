function Dunder() constructor {
	
	// ******
	// ****** Creation functions
	// ******
	
	static init = function(_type, _values) {
		// Tries to create an object that has an __init__ dunder
		if (is_numeric(_type) and script_exists(_type)) {
			var _struct = new _type()
			
			if (not variable_struct_exists(_struct, "__init__")) {
				throw init(DunderExceptionNoMethod, "Struct "+instanceof(_struct)+" does not have an __init__ method");
			}
			
			// we're doing this pyramid of doom because gamemaker has no string_execute_ext for methods
			switch(argument_count) {
				case  1: _struct.__init__(); break;
				case  2: _struct.__init__(argument[1]); break;
				case  3: _struct.__init__(argument[1], argument[2]); break;
				case  4: _struct.__init__(argument[1], argument[2], argument[3]); break;
				case  5: _struct.__init__(argument[1], argument[2], argument[3], argument[4]); break;
				case  6: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5]); break;
				case  7: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6]); break;
				case  8: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]); break;
				case  9: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]); break;
				case 10: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]); break;
				case 11: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10]); break;
				case 12: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11]); break;
				case 13: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12]); break;
				case 14: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13]); break;
				case 15: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14]); break;
				case 16: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14], argument[15]); break;
				case 17: _struct.__init__(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14], argument[15], argument[16]); break;
				default: throw init(DunderException, "Init can't accept more than 16 extra arguments");
			}
			
			return _struct;
		}
		else {
			throw init(DunderExceptionResourceNotFound, "Could not find dunder struct constructor "+string(_type));
		}
	}
	
	static instance = function(_object, _xx=0, _yy=0, _depth=0, _layer=undefined, _values={}) {
		// Calls DunderInstance to wrap an object
		
		if (not object_exists(_object)) {
			throw init(DunderExceptionResourceNotFound, "Could not find object "+string(_object))	
		}
		
		if (not is_undefined(_layer)) {
			var _inst = instance_create_layer(_xx, _yy, _layer, _object);
		}
		else {
			var _inst = instance_create_depth(_xx, _yy, _depth, _object);
		}
		return init(DunderInstance, _inst, _values);
	}
	
	static exception = function(_err) {
		// Cleans up exception objects, wrapping them with custom exceptions
		if (not is_struct(_err)) {
			// Not a struct, so maybe a string? Wrap it in generic custom Exception
			return init(DunderException, _err);
		}
	
		if (is_exception(_err)) {
			// If it's a dunder exception just return it
			return _err;
		}
	
		// Otherwise, assume it's a a gamemaker runtime error, wrap it
		return init(DunderExceptionRuntimeError, _err);
	}
	
	static del = function(_struct) {
		__throw_if_not_struct_with_method(_struct, "__del__");
		
		var _result = _struct.__del__();
		if (is_exception(_result)) return _result;
		delete _struct;
	}
	
	// ******
	// ****** Type checking functions
	// ******
	
	static is_subtype = function(_struct, _type) {
		if (not is_struct(_struct) or not variable_struct_exists(_struct, "__is_subtype__")) {
			return false;
		}
		
		return _struct.__is_subtype__(_constructor);
	}
	
	static is_constructor = function(_struct, _type) {
		if (not is_struct(_struct) or not variable_struct_exists(_struct, "__is_type__")) {
			return false;
		}
		
		return _struct.__is_type__(_constructor);
	}
	
	static is_exception = function(_struct) {
		return is_subtype(_struct, DunderException)
	}
	
	static is_dunder_struct = function(_struct) {
		return is_subtype(_struct, DunderBaseStruct)
	}
	
	static is_same_type = function(_struct_a, _struct_b) {
		if (is_struct(_struct_a) and variable_struct_exists(_struct_a, "__is_same_type_as__")) {
			return _struct_a.__is_same_type_as__(_struct_b);	
		}
		if (is_struct(_struct_b) and variable_struct_exists(_struct_b, "__is_same_type_as__")) {
			return _struct_b.__is_same_type_as__(_struct_a);
		}
		return false;
	}
	
	
	// ******
	// ****** Type coersion functions
	// ******
	
	static str = function(_struct) {
		if (is_string(_struct)) {
			return _struct;
		}
		if (is_struct(_struct_a) and variable_struct_exists(_struct_a, "__str__")) {
			return _struct.__str__();
		}
		return string(_struct);
	}
	
	static repr = function(_struct) {
		__throw_if_not_struct_with_method(_struct, "__repr__");

		return _struct.__repr__();
	}
	
	// ******
	// ****** Mathematical functions
	// ******
	
	static add = function(_struct_a, _struct_b) {
		if (is_struct(_struct_a) and variable_struct_exists(_struct_a, "__add__")) {
			return _struct_a.__add__(_struct_b);	
		}
		if (is_struct(_struct_b) and variable_struct_exists(_struct_b, "__add__")) {
			return _struct_b.__add__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Neither arguments have an __add__ method");
	}
	
	static mul = function(_struct_a, _struct_b) {
		if (is_struct(_struct_a) and variable_struct_exists(_struct_a, "__mul__")) {
			return _struct_a.__mul__(_struct_b);	
		}
		if (is_struct(_struct_b) and variable_struct_exists(_struct_b, "__mul__")) {
			return _struct_b.__mul__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Neither arguments have an __mul__ method");
	}
	
	
	// ******
	// ****** Dunder-specific utilities
	// ******
		
	static __throw_if_not_struct_with_method = function(_struct, _method) {
		if (not is_struct(_struct)) {
			throw init(DunderExceptionNotStruct, "Argument of type " + typeof(_struct) + " was not a struct");
		}
		if (not variable_struct_exists(_struct, _method)) {
			throw init(DunderExceptionNoMethod, "Struct "+instanceof(_struct)+" does not have a "+_method+" method")
		}
	}
	
	static __is_struct_with_method = function(_struct, _method) {
		return is_struct(_struct) and variable_struct_exists(_struct, _method)
	}

	// ******
	// ****** Exception handling
	// ******
	static register_exception_handler = function(_enable=true) {
		exception_unhandled_handler(_enable ? __exception_handler : undefined)
		return self;
	}
	
	static __exception_handler = function(_err){
		// Custom exception handler that helps format our custom exceptions
		var _msg = _err.message
	
		// match our hacked custom exceptions
		if (string_pos("Unable to find a handler for exception ", _msg) == 1) {
		
			// split message into lines
			var _pos = 39;
			var _lines = [];
			var _strlen = string_length(_msg);
			var _arrlen = -1;
			do {
				var _last_pos = _pos;
				_pos = string_pos_ext("\n", _msg, _last_pos);
				var _line = string_copy(_msg, _last_pos+1, (_pos>0?_pos: _strlen)-_last_pos-1);
				if (_line != "" and _line != "NO CALLSTACK") {
					array_push(_lines, _line);
					_arrlen += 1;
				}
			} until (_pos == 0);
		
			// get the call stack
			var _stacktrace = json_parse(array_pop(_lines));
		
			// join the rest of the lines back up
			var _message = _lines[0];
			for (var _i=1; _i<_arrlen; _i++) {
				_message += "\r" + _lines[_i];
			}
		}
		else {
			var _message = _err.message;
			var _stacktrace = _err.stacktrace;
		}
	
	
		var _output = "__________________________________________________________________________\r\r" +
					_message + "\r" +
					"__________________________________________________________________________\r\r" +
					"STACKTRACE:\r";
	
		var _len = array_length(_stacktrace);
		for (var _i=0; _i<_len; _i++) {
			_output += string(_stacktrace[_i]) + "\r\r";
		}
		
	
		show_debug_message(_output);
		show_message(_output);
	}
}
