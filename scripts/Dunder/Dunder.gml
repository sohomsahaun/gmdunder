function Dunder() constructor {
	
	// ******
	// ****** Creation
	// ******
	
	static init = function(_type, _values) {
		// Tries to create an object that has an __init__ dunder
		if (is_numeric(_type) and script_exists(_type)) {
			var _struct = new _type()
			
			if (not is_struct_with_method(_struct, "__init__")) {
				throw init(DunderExceptionNoMethod, "Struct "+instanceof(_struct)+" does not have an __init__ method");
			}
			
			// we're doing this pyramid of doom because gamemaker has no string_execute_ext for methods
			switch(argument_count) {
				case  1: _struct.__init__(); break;
				case  2: _struct.__init__(_values); break;
				case  3: _struct.__init__(_values, argument[2]); break;
				case  4: _struct.__init__(_values, argument[2], argument[3]); break;
				case  5: _struct.__init__(_values, argument[2], argument[3], argument[4]); break;
				case  6: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5]); break;
				case  7: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6]); break;
				case  8: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]); break;
				case  9: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]); break;
				case 10: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]); break;
				case 11: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10]); break;
				case 12: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11]); break;
				case 13: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12]); break;
				case 14: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13]); break;
				case 15: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14]); break;
				case 16: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14], argument[15]); break;
				case 17: _struct.__init__(_values, argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14], argument[15], argument[16]); break;
				default: throw init(DunderExceptionBadArgument, "Init can't accept more than 16 extra arguments");
			}
			
			return _struct;
		}
		else {
			throw init(DunderExceptionResourceNotFound, "Could not find dunder struct constructor "+string(_type));
		}
	}
	
	static del = function(_struct) {
		__throw_if_not_struct_with_method(_struct, "__del__");
		_struct.__del__();
		delete _struct;
	}
	
	static clone = function(_struct) {
		__throw_if_not_struct_with_method(_struct, "__clone__");
		return _struct.__clone__();
	}
	
	// ******
	// ****** Convenience functions for constructing specific dunder structs
	// ******
	
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
	
	static range = function(_start=0, _stop, _step=1) {
		return init(DunderRange, _start, _stop, _step);
	}
	static reversed = function(_target) {
		return init(DunderReversed, _target);
	}
	static field = function(_default_value, _default_factory, _validator) {
		return init(DunderField, _default_value, _default_factory, _validator);	
	}
	
	static init_string  = function(_value) {
			// we're doing this pyramid of doom because gamemaker has no string_execute_ext for methods
			switch(argument_count) {
				case  1: return init(DunderString, _value);
				case  2: return init(DunderString, _value, argument[1]);
				case  3: return init(DunderString, _value, argument[1], argument[2]);
				case  4: return init(DunderString, _value, argument[1], argument[2], argument[3]);
				case  5: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4]);
				case  6: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5]);
				case  7: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6]);
				case  8: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]);
				case  9: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]);
				case 10: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]);
				case 11: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10]);
				case 12: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11]);
				case 13: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12]);
				case 14: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13]);
				case 15: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14]);
				case 16: return init(DunderString, _value, argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14], argument[15]);
				default: throw init(DunderExceptionBadArgument, "Init can't accept more than 16 arguments");
			}
	}
	
	static init_dict = function(_values, _copy=false) {
		return init(DunderDict, _values, _copy);
	}
	
	static init_list = function(_values, _copy=false) {
		return init(DunderList, _values, _copy);
	}
	
	// ******
	// ****** Representation and conversion to GML types
	// ******
		
	static repr = function(_struct) {
		if (is_struct_with_method(_struct, "__repr__")) {
			return _struct.__repr__();
		}
		return json_stringify(_struct);
	}
	
	static as_str = function(_struct) {
		if (is_struct_with_method(_struct, "__str__")) {
			return _struct.__str__();
		}
		return string(_struct);
	}
	
	static as_bool = function(_struct) {
		if (is_struct_with_method(_struct, "__bool__")) {
			return _struct.__bool__();
		}
		return bool(_struct);
	}
	
	static as_struct = function(_struct) {
		if (is_struct_with_method(_struct, "__struct__")) {
			return _struct.__struct__();
		}
		if (is_struct(_struct)) {
			return _struct;
		}
		throw init(DunderExceptionTypeError, "Can't coerse type "+typeof(_struct)+" to struct");
	}
	
	static as_array = function(_struct) {
		if (is_struct_with_method(_struct, "__array__")) {
			return _struct.__array__();
		}
		if (is_array(_struct)) {
			return _struct;
		}
		throw init(DunderExceptionTypeError, "Can't coerse type "+typeof(_struct)+" to array");
	}
	
	// ******
	// ****** Mathematical functions
	// ******
	
	static add = function(_struct_a, _struct_b) {
		if (is_struct_with_method(_struct_a, "__add__")) {
			return _struct_a.__add__(_struct_b);	
		}
		if (is_struct_with_method(_struct_b, "__add__")) {
			return _struct_b.__add__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Neither arguments have an __add__ method");
	}
	
	static mul = function(_struct_a, _struct_b) {
		if (is_struct_with_method(_struct_a, "__mul__")) {
			return _struct_a.__mul__(_struct_b);	
		}
		if (is_struct_with_method(_struct_b, "__mul__")) {
			return _struct_b.__mul__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Neither arguments have an __mul__ method");
	}
	
	static eq = function(_struct_a, _struct_b) {
		if (is_struct_with_method(_struct_a, "__eq__")) {
			return _struct_a.__eq__(_struct_b);	
		}
		if (is_struct_with_method(_struct_b, "__eq__")) {
			return _struct_b.__eq__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Neither arguments have an __eq__ method");
	}
	
	// ******
	// ****** Structure access
	// ******
	
	static len = function(_struct) {
		__throw_if_not_struct_with_method(_struct, "__len__");
		return _struct.__len__();
	}
	static contains = function(_struct, _value) {
		__throw_if_not_struct_with_method(_struct, "__contains__");
		return _struct.__contains__(_value);
	}
	static get = function(_struct, _index_or_key) {
		if (is_struct_with_method(_struct, "__getitem__")) {
			return _struct.__getitem__(_index_or_key);	
		}
		if (is_struct_with_method(_struct, "__getattr__")) {
			return _struct.__getattr__(_index_or_key);
		}
		throw init(DunderExceptionNoMethod, "Struct "+instanceof(_struct)+" does not have a __getitem__ or __getattr__ method");
	}
	static set = function(_struct, _index_or_key, _value) {
		if (is_struct_with_method(_struct, "__setitem__")) {
			return _struct.__setitem__(_index_or_key, _value);	
		}
		if (is_struct_with_method(_struct, "__setattr__")) {
			return _struct.__setattr__(_index_or_key, _value);
		}
		throw init(DunderExceptionNoMethod, "Struct "+instanceof(_struct)+" does not have a __setitem__ or __setattr__ method");
	}
	static has = function(_struct, _index_or_key) {
		if (is_struct_with_method(_struct, "__hasitem__")) {
			return _struct.__hasitem__(_index_or_key);	
		}
		if (is_struct_with_method(_struct, "__hasattr__")) {
			return _struct.__hasattr__(_index_or_key);
		}
		throw init(DunderExceptionNoMethod, "Struct "+instanceof(_struct)+" does not have a __hasitem__ or __hasattr__ method");
	}
	static remove = function(_struct, _index_or_key) {
		if (is_struct_with_method(_struct, "__removeitem__")) {
			return _struct.__removeitem__(_index_or_key);	
		}
		if (is_struct_with_method(_struct, "__removeattr__")) {
			return _struct.__removeattr__(_index_or_key);
		}
		throw init(DunderExceptionNoMethod, "Struct "+instanceof(_struct)+" does not have a __removeitem__ or __removeattr__ method");
	}

	
	// ******
	// ****** Iteration
	// ******
	
	static iter = function(_struct) {
		__throw_if_not_struct_with_method(_struct, "__iter__");
		return _struct.__iter__();
	}
	
	static next = function(_iterator) {
		__throw_if_not_struct_with_method(_iterator, "__next__");
		return _iterator.__next__();
	}
	
	static foreach = function(_struct, _func) {
		if (is_array(_struct)) {
			_struct = init(DunderList, _struct);
		}
		__throw_if_not_struct_with_method(_struct, "__iter__");
		var _iter = _struct.__iter__();
		__throw_if_not_struct_with_method(_iter, "__next__");
		
		while(true) {
			try {
				var _pair = _iter.__next__();
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return;
				}
				throw exception(_err)
			}
			
			_func(_pair[0], _pair[1]);
		}
	}
	
	static map = function(_struct, _func) {
		if (is_array(_struct)) {
			_struct = init(DunderList, _struct);
		}
		__throw_if_not_struct_with_method(_struct, "__iter__");
		var _iter = _struct.__iter__();
		__throw_if_not_struct_with_method(_iter, "__next__");
		
		var _array = [];
		while(true) {
			try {
				var _pair = _iter.__next__();
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return init_list(_array);
				}
				throw exception(_err)
			}
			
			array_push(_array, _func(_pair[0], _pair[1]));
		}
	}

	static filter = function(_struct, _func) {
		if (is_array(_struct)) {
			_struct = init(DunderList, _struct);
		}
		__throw_if_not_struct_with_method(_struct, "__iter__");
		var _iter = _struct.__iter__();
		__throw_if_not_struct_with_method(_iter, "__next__");
		
		var _array = [];
		while(true) {
			try {
				var _pair = _iter.__next__();
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return init_list(_array);
				}
				throw exception(_err)
			}
			
			if (_func(_pair[0], _pair[1])) {			
				array_push(_array, _pair[0]);
			}
		}
	}
	
	static all_ = function(_struct) {
		if (is_array(_struct)) {
			_struct = init(DunderList, _struct);
		}
		__throw_if_not_struct_with_method(_struct, "__iter__");
		var _iter = _struct.__iter__();
		__throw_if_not_struct_with_method(_iter, "__next__");
		
		while(true) {
			try {
				var _pair = _iter.__next__();
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return true;
				}
				throw exception(_err)
			}
			
			if (not as_bool(_pair[0])) {
				delete _iter;
				return false;
			}
		}
	}
	
	static any = function(_struct) {
		if (is_array(_struct)) {
			_struct = init(DunderList, _struct);
		}
		__throw_if_not_struct_with_method(_struct, "__iter__");
		var _iter = _struct.__iter__();
		__throw_if_not_struct_with_method(_iter, "__next__");
		
		while(true) {
			try {
				var _pair = _iter.__next__();
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return false;
				}
				throw exception(_err)
			}
			
			if (as_bool(_pair[0])) {
				delete _iter;
				return true;
			}
		}
	}
	
	// ******
	// ****** Type checking
	// ******
	
	static is_subtype = function(_struct, _type) {
		if (not is_struct_with_method(_struct, "__is_subtype__")) {
			return false;
		}
		
		return _struct.__is_subtype__(_type);
	}
	
	static is_type = function(_struct, _type) {
		if (not is_struct_with_method(_struct, "__is_type__")) {
			return false;
		}
		
		return _struct.__is_type__(_type);
	}
	
	static is_exception = function(_struct) {
		return is_subtype(_struct, DunderException)
	}
	
	static is_dunder_struct = function(_struct) {
		return is_subtype(_struct, DunderBaseStruct)
	}
	
	static is_same_type = function(_struct_a, _struct_b) {
		if (is_struct_with_method(_struct_a, "__is_same_type_as__")) {
			return _struct_a.__is_same_type_as__(_struct_b);	
		}
		if (is_struct_with_method(_struct_b, "__is_same_type_as__")) {
			return _struct_b.__is_same_type_as__(_struct_a);
		}
		return false;
	}
	
	static is_struct_with_method = function(_struct, _method) {
		return is_struct(_struct) and variable_struct_exists(_struct, _method)
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
