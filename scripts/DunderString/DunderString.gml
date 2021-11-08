function DunderString() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderString);
	// A string wrapper

	static __init__ = function() {
		value = "";
		for (var _i=0; _i<argument_count; _i++) {
			var _input = argument[_i];
			if (__dunder__.is_struct_with_method(_input, "__string__")) {
				value += _input.__string__();
			}
			else {
				value += string(argument[_i]);
			}
		}
	}	
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
			return __dunder__.init(self.__type__(), values);
		}
		return __dunder__.init(self.__type__(), _input);
	}

	// Representation methods
	static __string__ = function() {
		return value;
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" value='"+value+"'>";
	}
	static __boolean__ = function() {
		return bool(__len__() > 0);	
	}
	static __array__ = function() {
		var _array = array_create(string_length(value));
		var _len = string_length(value);
		for (var _i=0; _i<_len; _i++) {
			_array[_i] = string_char_at(value, _index+1);
		}
	}
	static toString = function() {
		return value;	
	}
	
	// Mathematical operators
	static __add__ = function(_other) {
		var _string = __dunder__.as_string(_other)
		return __clone__(value + _string);
	}
	static __multiply__ = function(_other) {
		var _number = __dunder__.as_number(_other);
		return __clone__(string_repeat(value, _number));
	}
	static __equals__ = function(_other) {
		if (not __dunder__.can_string(_other)) {
			return false;
		}
		return value == __dunder__.as_string(_other);
	}
	
	static __radd__ = __add__;
	static __rmultiply__ = __multiply__;
	static add = __add__;
	static multiply = __multiply__;
	static equals = __equals__;
	
	// Structure access
	static __len__ = function() {
		return string_length(value);
	}
	static __contains__ = function(_value) {
		return string_pos(_value, value) > 0;
	}
	static __getitem__ = function(_index) {
		var _len = string_length(value);
		if (_len == 0) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (string is empty)");
		}
		if (_index <= -_len or _index >= _len) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = __wrap_index(_index);
		return string_char_at(value, _index+1);
	}
	static __setitem__ = function(_index, _value) {
		var _len = string_length(value);
		if (_index < -_len or _index > _len) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = __wrap_index(_index);
		return string_insert(_value, value, _index+1);
	}
	static __hasitem__ = function(_index) {
		var _len = string_length(value);
		if (_len == 0) {
			return false;	
		}
		_index = __wrap_index(_index);
		return _index >= 0 and _index < _len;
	}
	static __removeitem__ = function(_index) {
		var _len = string_length(value);
		if (_index <= -_len or _index >= _len) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = __wrap_index(_index);
		value = string_delete(value, _index+1, 1);
	}
	static len = __len__;
	static contains = __contains__;
	static get = __getitem__;
	static set = __setitem__;
	static has = __hasitem__;
	static remove = __removeitem__;

	// Iteration methods
	static __iter__ = function() {
		return __dunder__.init(DunderIterator, method(self, __getitem__),  __len__());
	}
	
	// Type checking methods
	static __is_same_type_as__ = function(_other) {
		if (is_string(_other)) {
			return true;	
		}
		return __type__() == _other.__type__();
	}
	
	// Gamemaker string functions
	static byte_at = function(_index) { return string_byte_at(value, _index+1); }
	static byte_length = function() { return string_byte_length(value); }
	static set_byte_at = function(_pos, _byte) { return string_set_byte_at(value, _pos+1, _byte); }
	static char_at = function(_index) { return string_char_at(value, _index+1); }
	static ord_at = function(_index) { return string_ord_at(value, _index+1); }
	static copy = function(_index, _count) { return __clone__(string_copy(value, _index+1, _count)); }
	static count = function(_substr) { return string_count(value, _substr); }
	static delete_ = function(_index, _count) { return  __clone__(string_delete(value, _index+1, _count)); }
	static digits = function() { return  __clone__(string_digits(value)); }
	static format = function(_tot, _dec) { return  __clone__(string_format(value, _tot, _dec)); }
	static insert = function(_substr, _index) { return  __clone__(string_insert(_substr, value, _index+1)); }
	static letters = function() { return __clone__(string_letters(value)); }
	static lettersdigits = function() { return __clone__(string_lettersdigits(value)); }
	static lower = function() { return __clone__(string_lower(value)); }
	static pos = function(_substr) { return string_pos(_substr, value)-1; }
	static pos_ext = function(_substr, _start_pos) { return string_pos_ext(_substr, value, _start_pos)-1; }
	static last_pos = function(_substr) { return string_last_pos(_substr, value)-1; }
	static last_pos_ext = function(_substr, _start_pos) { return string_last_pos_ext(_substr, value, _start_pos)-1; }
	static repeat_ = function(_count) { return __clone__(string_repeat(value, _count)); }
	static replace = function(_substr, _newstr) { return __clone__(string_replace(value, _substr, _newstr)); }
	static replace_all = function(_substr, _newstr) { return __clone__(string_replace_all(value, _substr, _newstr)); }
	static upper = function() { return __clone__(string_upper(value)); }
	
	// String functions
	static replace_all_in_place = function(_substr, _newstr) {
		value = string_replace_all(value, _substr, _newstr);
		return value
	}
	
	static split = function(_seperator, _max_times=undefined) {
		var _array = [];
		var _len = string_length(value);
		var _last_pos = 1;
		var _separator_len = string_length(_seperator);
		for (var _i=0; _last_pos < _len and (is_undefined(_max_times) or _i<_max_times); _i++) {
			var _pos = string_pos_ext(_seperator, value, _last_pos);
			if (_pos == 0) {
				break;
			}
			array_push(_array, string_copy(value, _last_pos, _pos-_last_pos));	
			_last_pos = _pos+_separator_len;
		}
		array_push(_array, string_copy(value, _last_pos, _len-_last_pos+1));	
		return _array;
	}
	
	static slice = function(_start=0, _stop=-1, _step=1) {
		_start = __wrap_index(_start);
		_stop = __wrap_index(_stop);
		
		if (not is_numeric(_start)) {
			throw __dunder__.init(DunderExceptionValueError, "Start must be numeric");	
		}
		if (not is_numeric(_stop)) {
			throw __dunder__.init(DunderExceptionValueError, "Stop must be numeric");	
		}
		if (not is_numeric(_step)) {
			throw __dunder__.init(DunderExceptionValueError, "Step must be numeric");	
		}

		var _range = __dunder__.init(DunderRange, _start, _stop, _step);
		return __dunder__.map(_range, method(self, __getitem__));
	}
	
	static __wrap_index = function(_index) {
		var _len = string_length(value);
		return (_index % _len + _len) % _len;
	}
	
	static __is_whitespace = function(_char) {
		return _char == " " or _char == "\t" or _char == "\r" or _char == "\n";
	}
	
	static trim = function() {
		var _str = ltrim();
		var _len = string_length(_str);
		for (var _i=_len-1; _i>=0; _i--) {
			if (not __is_whitespace(string_char_at(_str, _i+1))) {
				break;
			}
		}
		return string_copy(_str, 1, _i+1);
	}
	
	static ltrim = function() {
		var _len = string_length(value);
		for (var _i=0; _i<_len; _i++) {
			if (not __is_whitespace(string_char_at(value, _i+1))) {
				break;
			}
		}
		return string_delete(value, 1, _i);
	}
	
	static rtrim = function() {
		var _len = string_length(value);
		for (var _i=_len-1; _i>=0; _i--) {
			if (not __is_whitespace(string_char_at(value, _i+1))) {
				break;
			}
		}
		return string_copy(value, 1, _i+1);
	}

	static from_file = function(_input) {
		var _path = __dunder__.as_string(_input);
		if (not file_exists(_path)) {
			throw __dunder__.init(DunderExceptionFileError, "Can't load file "+typeof(_path));
		}
			
		var _buff = buffer_load(_path);
		var _str = buffer_read(_buff, buffer_text);
		buffer_delete(_buff);
		
		value = _str;
		return self;
	}
}