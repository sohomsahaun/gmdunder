function DunderPath() : DunderBaseStruct() constructor {
	// A path manager
	__bases_add__(DunderPath);
	
	static separator = "/";
	
	static __init__ = function(_input) {
		if (__dunder__.is_struct_with_method(_input, "__array__")) {
			var _array = _input.__array__();
			var _len = array_length(_array);
			path_parts = array_create(_len);
			array_copy(path_parts, 0, _array, 0, _len);
		}
		else if (is_array(_input)) {
			var _len = array_length(_input);
			path_parts = array_create(_len);
			array_copy(path_parts, 0, _input, 0, _len);
		}
		else if (__dunder__.is_struct_with_method(_input, "__str__")) {
			path_parts = [];
			join(_input.__str__());
		}
		else if (is_string(_input)) {
			path_parts = [];
			join(_input);
		}
		else if (__dunder__.is_dunder_struct(_input)) {
			throw __dunder__.init(DunderExceptionTypeError, "Can't coerse type "+instanceof(_input)+" to Path");
		}
		else if (is_undefined(_input)) {
			path_parts = []
		}
	}
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
			_input = path_parts;
		}
		return __dunder__.init(self.__type__(), _input);
	}
	// Representation methods
	static __str__ = function() {
		var _str = "";
		var _len = array_length(path_parts);
		for (var _i=0; _i<_len; _i+=1) {
			if (_i == 0) {
				_str += path_parts[_i];	
			}
			else {
				_str += separator + path_parts[_i];
			}
		}
		return _str;
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" value='"+__str__()+"'>";
	}
	static __bool__ = function() {
		return array_length(path_parts) > 0;	
	}
	static __array__ = function() {
		return path_parts;	
	}
	static toString = function() {
		return __str__();	
	}
	
	// Path functions
	static join = function(_string) {
		_string = string_replace_all(_string, "\\", separator);
		_string = string_replace_all(_string, "/", separator);

		var _len = string_length(_string);
		var _last_pos = 1;
		do {
			// slashes
			var _pos = string_pos_ext(separator, _string, _last_pos);
			if (_pos == 0) {
				_pos = _len+1;
			}
			array_push(path_parts, string_copy(_string, _last_pos, _pos-_last_pos));
			_last_pos = _pos+1;
		} until (_last_pos >= _len);
		
		return self;
	}
	exists = function() {
		return is_file() or is_dir();
	}
	
	is_file = function() {
		if (__bool__()) {
			return file_exists(__str__());
		}
		return false;
	}
	
	is_dir = function() {
		if (__bool__()) {
			return directory_exists(__str__());
		}
		return false;
	}
	
	get_parent = function() {
		// return new Path with parent
		var _len_up = array_length(path_parts) - 1;
		
		if (_len_up < 0) {
			throw __dunder__.init(DunderExceptionValueError, "Can't go up in path");
		}
		
		var _array = array_create(_len_up);
		array_copy(_array, 0, path_parts, 0, _len_up);
		return __clone__(_array);
	}
		
	get_joined = function(_name) {
		// return new Path with child
		var _child = __clone__()
		_child.join(_name);
		return _child;
	}

	up = function() {
		// go up one, in place
		if (array_length(path_parts) == 0) {
			throw "Cannot go up"
		}
		
		array_pop(path_parts);
		return self;
	}
}