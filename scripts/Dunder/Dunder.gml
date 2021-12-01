function Dunder() constructor {

	static started = false;
	if (not started) {
		started = true;
		show_debug_message("Instantiating Dunder version " + DUNDER_VERSION);	
	}
	
	// ******
	// ****** Shared resources (lazy enitialize shared objects)
	// ******
	static shared = {
		logger: undefined,
		env: undefined,
		broker: undefined,
	};
	
	static get_shared_logger = function() {
		if (is_undefined(shared.logger)) {
			shared.logger = init(DunderLogger, "Root");
		}
		return shared.logger;
	}
	
	static bind_named_logger = function(_name, _extras) {
		return get_shared_logger().bind_named(_name, _extras);	
	}
	
	static get_shared_env = function() {
		if (is_undefined(shared.env)) {
			shared.env = init(DunderEnv);
		}
		return shared.env;
	}
	
	static get_shared_broker = function() {
		if (is_undefined(shared.broker)) {
			shared.broker = init(DunderMessageBroker);
		}
		return shared.broker;
	}
		
	static on_game_start = function(_first_room_callback) {
		// Inserts the callback object into the first room, which is responsible
		// for firing off the _first_room_callback when the first room is entered.
		// This is necessary because globally-registered objects may not do
		// certain room-related things until actually inside the room
		if (is_method(_first_room_callback)) {
			get_shared_logger().info("Registering function to run on game start");
			room_instance_add(room_first, 0, 0, __obj_dunder_init_room);	
			variable_global_set(DUNDER_FIRST_ROOM_GLOBAL, _first_room_callback);
		}
		
		return self;
	}
	
	// ******
	// ****** Creation
	// ******
	
	static init = function(_type, _values) {
		var _struct = new _type()
			
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
	
	static cleanup = function(_struct) {
		__throw_if_not_struct_with_method(_struct, "__cleanup__");
		_struct.__cleanup__();
		delete _struct;
	}
	
	static clone = function(_struct) {
		__throw_if_not_struct_with_method(_struct, "__clone__");
		return _struct.__clone__();
	}
	
	
	// ******
	// ****** Convenience functions for constructing specific dunder structs
	// ******

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
		
	static create_instance = function(_object, _xx=0, _yy=0, _depth=0, _layer=undefined, _init_args=undefined) {
		return init(DunderInstance, _object, _xx, _yy, _depth, _layer, _init_args);
	}
	
	static init_string  = function(_value) {
		// we're doing this pyramid of doom because gamemaker has no string_execute_ext for methods
		switch(argument_count) {
			case  0: return init(DunderString);
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
		
	static repr = function(_input) {
		if (is_struct_with_method(_input, "__repr__")) {
			return _input.__repr__();
		}
		return json_stringify(_input);
	}
	
	static as_string = function(_input) {
		if (is_string(_input)) {
			return _input;	
		}
		if (is_struct_with_method(_input, "__string__")) {
			return _input.__string__();
		}
		try {
			return string(_input);
		}
		catch(_err) {
			throw init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to string: " + _err.message);
		}
	}
	
	static as_boolean = function(_input) {
		if (is_bool(_input) or _input == true or _input == false) {
			return _input;	
		}
		if (is_struct_with_method(_input, "__boolean__")) {
			return _input.__boolean__();
		}
		throw init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to boolean");
	}
	
	static as_number = function(_input) {
		if (is_numeric(_input)) {
			return _input;	
		}
		if (is_struct_with_method(_input, "__number__")) {
			return _input.__number__();
		}
		throw init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to number");
	}
	
	static as_struct = function(_input) {
		if (is_struct_with_method(_input, "__struct__")) {
			return _input.__struct__();
		}
		if (not is_dunder_struct(_input) and is_struct(_input)) {
			return _input;
		}
		throw init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to struct");
	}
	
	static as_array = function(_input) {
		if (is_array(_input)) {
			return _input;
		}
		if (is_struct_with_method(_input, "__array__")) {
			return _input.__array__();
		}
		throw init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to array");
	}
		
	static can_string = function(_input) {
		return is_string(_input) or is_struct_with_method(_input, "__string__");
	}
	
	static can_boolean = function(_input) {
		return is_bool(_input) or _input == true or _input == false or is_struct_with_method(_input, "__boolean__");
	}
	
	static can_number = function(_input) {
		return is_numeric(_input) or is_struct_with_method(_input, "__number__");
	}
	
	static can_struct = function(_input) {
		return is_struct_with_method(_input, "__struct__") or (not is_dunder_struct(_input) and is_struct(_input));
	}
	
	static can_array = function(_input) {
		return is_array(_input) or is_struct_with_method(_input, "__array__");
	}
	
	
	// ******
	// ****** Mathematical functions
	// ******
	
	static add = function(_struct_a, _struct_b) {
		if (is_struct_with_method(_struct_a, "__add__")) {
			return _struct_a.__add__(_struct_b);	
		}
		if (is_struct_with_method(_struct_b, "__radd__")) {
			return _struct_b.__radd__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Arguments don't have needed __add__ or __radd__ methods");
	}
	
	static subtract = function(_struct_a, _struct_b) {
		if (is_struct_with_method(_struct_a, "__subtract__")) {
			return _struct_a.__subtract__(_struct_b);	
		}
		if (is_struct_with_method(_struct_b, "__rsubtract__")) {
			return _struct_b.__rsubtract__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Arguments don't have needed __subtract__ or __rsubtract__ methods");
	}
	
	static multiply = function(_struct_a, _struct_b) {
		if (is_struct_with_method(_struct_a, "__multiply__")) {
			return _struct_a.__multiply__(_struct_b);	
		}
		if (is_struct_with_method(_struct_b, "__rmultiply__")) {
			return _struct_b.__rmultiply__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Arguments don't have needed __multiply__ or __rmultiply__ methods");
	}
		
	static divide = function(_struct_a, _struct_b) {
		if (is_struct_with_method(_struct_a, "__divide__")) {
			return _struct_a.__divide__(_struct_b);	
		}
		if (is_struct_with_method(_struct_b, "__rdivide__")) {
			return _struct_b.__rdivide__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Arguments don't have needed __divide__ or __rdivide__ methods");
	}
	
	static equals = function(_struct_a, _struct_b) {
		if (is_struct_with_method(_struct_a, "__equals__")) {
			return _struct_a.__equals__(_struct_b);	
		}
		if (is_struct_with_method(_struct_b, "__equals__")) {
			return _struct_b.__equals__(_struct_a);
		}
		throw init(DunderExceptionNoMethod, "Neither arguments have an __equals__ method");
	}
	
	
	// ******
	// ****** Structure access
	// ******
	
	static len = function(_struct) {
		return _struct.__len__();
	}
	static contains = function(_struct, _value) {
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
	
	static iter = function(_input) {
		if (is_struct_with_method(_input, "__iter__")) {
			var _struct = _input;
		}
		else if (is_struct(_input)) {
			var _struct = init(DunderDict, _input);	
		}
		else if (is_array(_input)) {
			var _struct = init(DunderList, _input);
		}
		else {
			throw init(DunderExceptionNoMethod, "Struct "+instanceof(_struct)+" does not have a __removeitem__ or __removeattr__ method");	
		}
		
		var _iter = _struct.__iter__();
		__throw_if_not_struct_with_method(_iter, "__next__");
		return _iter;
	}
	
	static next = function(_iterator) {
		return _iterator.__next__();
	}
	
	static foreach = function(_input, _func) {
		var _iter = iter(_input);
		
		while(true) {
			try {
				var _pair = _iter.__next__();
				_func(_pair[0], _pair[1]);
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return;
				}
				rethrow(_err)
			}
		}
	}
	
		
	static foreach_zip = function(_input_a, _input_b, _func) {
		var _iter_a = iter(_input_a);
		var _iter_b = iter(_input_b);
		
		while(true) {
			try {
				var _pair_a = _iter_a.__next__();
				var _pair_b = _iter_b.__next__();
				_func(_pair_a[0], _pair_b[0], _pair_a[1], _pair_b[1]);
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter_a;
					delete _iter_b;
					return;
				}
				rethrow(_err)
			}
		}
	}
	
	static map = function(_input, _func) {
		var _iter = iter(_input);
		
		var _array = [];
		while(true) {
			try {
				var _pair = _iter.__next__();
				array_push(_array, _func(_pair[0], _pair[1]));
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return init_list(_array);
				}
				rethrow(_err)
			}
		}
	}
	
	static map_struct = function(_input, _func) {
		var _iter = iter(_input);
		
		var _struct = {};
		while(true) {
			try {
				var _pair = _iter.__next__();
				var _result = _func(_pair[0], _pair[1]);
				
				if (is_array(_result)) {
					_struct[$ _result[0]] = _result[1];
				}
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return _struct;
				}
				rethrow(_err)
			}
		}
	}

	static filter = function(_input, _func) {
		var _iter = iter(_input);
		
		var _array = [];
		while(true) {
			try {
				var _pair = _iter.__next__();
				if (_func(_pair[0], _pair[1])) {			
					array_push(_array, _pair[0]);
				}
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return init_list(_array);
				}
				rethrow(_err)
			}
		}
	}
	
	static reduce = function(_input, _value, _func) {
		var _iter = iter(_input);
		
		while(true) {
			try {
				var _pair = _iter.__next__();
				_value = _func(_value, _pair[0], _pair[1]);
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return _value;
				}
				rethrow(_err)
			}	
		}
	}
	
	
	static all_ = function(_input) {
		var _iter = iter(_input);
		
		while(true) {
			try {
				var _pair = _iter.__next__();
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return true;
				}
				rethrow(_err)
			}
			
			if (not as_boolean(_pair[0])) {
				delete _iter;
				return false;
			}
		}
	}
	
	static any = function(_input) {
		var _iter = iter(_input);
		
		while(true) {
			try {
				var _pair = _iter.__next__();
			}
			catch (_err) {
				if (is_type(_err, DunderExceptionStopIteration)) {
					delete _iter;
					return false;
				}
				rethrow(_err)
			}
			
			if (as_boolean(_pair[0])) {
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
	
	static rethrow = function(_err) {
		throw exception(_err)
	}
	
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
