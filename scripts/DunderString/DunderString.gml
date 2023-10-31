function DunderString() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderString);
	// A string wrapper

	static __init__ = function() {
		__value = "";
		for (var _i=0; _i<argument_count; _i++) {
			var _input = argument[_i];
			if (dunder.is_struct_with_method(_input, "__string__")) {
				__value += _input.__string__();
			}
			else if (is_string(argument[_i])) {
				__value += argument[_i];
			}
			else if (not is_undefined(argument[_i])) {
				__value += string(argument[_i]);
			}
		}
	}	
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
			return dunder.init(self.__type__(), __value);
		}
		return dunder.init(self.__type__(), _input);
	}

	// Representation methods
	static __string__ = function() {
		return __value;
	}
	static __number__ = function() {
		return real(__value);	
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" value='"+__value+"'>";
	}
	static __boolean__ = function() {
		return bool(__len__() > 0);	
	}
	static __array__ = function() {
		var _array = array_create(string_length(__value));
		var _len = string_length(__value);
		for (var _i=0; _i<_len; _i++) {
			_array[_i] = string_char_at(__value, _index+1);
		}
	}
	static toString = function() {
		return __value;	
	}
	static as_string = __string__;
	static as_number = __number__;
	static as_boolean = __boolean__;
	static as_array = __array__;
	
	// Mathematical operators
	static __add__ = function(_other) {
		var _string = dunder.as_string(_other)
		return __clone__(__value + _string);
	}
	static __radd__ = function(_other) {
		var _string = dunder.as_string(_other)
		return __clone__(_string + __value);
	}
	static __multiply__ = function(_other) {
		var _number = dunder.as_number(_other);
		return __clone__(string_repeat(__value, _number));
	}
	static __equals__ = function(_other) {
		if (not dunder.can_string(_other)) {
			return false;
		}
		return __value == dunder.as_string(_other);
	}
	
	static __rmultiply__ = __multiply__;
	static add = __add__;
	static multiply = __multiply__;
	static equals = __equals__;
	
	// Structure access
	static __len__ = function() {
		return string_length(__value);
	}
	static __contains__ = function(_value) {
		return string_pos(_value, __value) > 0;
	}
	static __getitem__ = function(_index) {
		var _len = string_length(__value);
		if (_len == 0) {
			throw dunder.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (string is empty)");
		}
		if (_index <= -_len or _index >= _len) {
			throw dunder.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = __wrap_index(_index);
		return string_char_at(__value, _index+1);
	}
	static __setitem__ = function(_index, _value) {
		var _len = string_length(__value);
		if (_index < -_len or _index > _len) {
			throw dunder.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = __wrap_index(_index);
		return string_insert(_value, __value, _index+1);
	}
	static __hasitem__ = function(_index) {
		var _len = string_length(__value);
		if (_len == 0) {
			return false;	
		}
		_index = __wrap_index(_index);
		return _index >= 0 and _index < _len;
	}
	static __removeitem__ = function(_index) {
		var _len = string_length(__value);
		if (_index <= -_len or _index >= _len) {
			throw dunder.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = __wrap_index(_index);
		__value = string_delete(__value, _index+1, 1);
	}
	static len = __len__;
	static contains = __contains__;
	static get = __getitem__;
	static set = __setitem__;
	static has = __hasitem__;
	static remove = __removeitem__;

	// Iteration methods
	static __iter__ = function() {
		return dunder.init(DunderIterator, method(self, __getitem__),  __len__());
	}
	
	// Type checking methods
	static __is_same_type_as__ = function(_other) {
		if (is_string(_other)) {
			return true;	
		}
		return __type__() == _other.__type__();
	}
	
	// Gamemaker string functions
	static byte_at = function(_index) { return string_byte_at(__value, _index+1); }
	static byte_length = function() { return string_byte_length(__value); }
	static set_byte_at = function(_pos, _byte) { return string_set_byte_at(__value, _pos+1, _byte); }
	static char_at = function(_index) { return string_char_at(__value, _index+1); }
	static ord_at = function(_index) { return string_ord_at(__value, _index+1); }
	static copy = function(_index, _count) { return __clone__(string_copy(__value, _index+1, _count)); }
	static count = function(_substr) { return string_count(__value, _substr); }
	static delete_ = function(_index, _count) { return  __clone__(string_delete(__value, _index+1, _count)); }
	static digits = function() { return  __clone__(string_digits(__value)); }
	static format = function(_tot, _dec) { return  __clone__(string_format(__value, _tot, _dec)); }
	static insert = function(_substr, _index) { return  __clone__(string_insert(_substr, __value, _index+1)); }
	static letters = function() { return __clone__(string_letters(__value)); }
	static lettersdigits = function() { return __clone__(string_lettersdigits(__value)); }
	static lower = function() { return __clone__(string_lower(__value)); }
	static pos = function(_substr) { return string_pos(_substr, __value)-1; }
	static pos_ext = function(_substr, _start_pos) { return string_pos_ext(_substr, __value, _start_pos+1)-1; }
	static last_pos = function(_substr) { return string_last_pos(_substr, __value)-1; }
	static last_pos_ext = function(_substr, _start_pos) { return string_last_pos_ext(_substr, __value, _start_pos+1)-1; }
	static repeat_ = function(_count) { return __clone__(string_repeat(__value, _count)); }
	static replace = function(_substr, _newstr) { return __clone__(string_replace(__value, _substr, _newstr)); }
	static replace_all = function(_substr, _newstr) { return __clone__(string_replace_all(__value, _substr, _newstr)); }
	static upper = function() { return __clone__(string_upper(__value)); }
	static height = function() { return string_height(__value); }
	static height_ext = function(_sep, _w) { return string_height_ext(__value, _sep, _w); }
	static width = function() { return string_width(__value); }
	static width_ext = function(_sep, _w) { return string_width_ext(__value, _sep, _w); }
	
	// String functions
	static replace_all_in_place = function(_substr, _newstr) {
		__value = string_replace_all(__value, _substr, _newstr);
		return __value
	}
	static replace_in_place = function(_substr, _newstr) {
		__value = string_replace(__value, _substr, _newstr);
		return __value
	}
	static delete_in_place = function(_index, _count) {
		__value = string_delete(__value, _index+1, _count);
	}
	static insert_in_place = function(_substr, _index) {
		__value = string_insert(_substr, __value, _index+1);
	}
	static append = function(_str) {
		__value += dunder.as_string(_str);	
	}
	
	static split = function(_seperator, _max_times=undefined) {
		var _list = dunder.init_list();
		var _len = string_length(__value);
		var _last_pos = 0;
		var _separator_len = string_length(_seperator);
		for (var _i=0; _last_pos < _len and (is_undefined(_max_times) or _i<_max_times); _i++) {
			var _pos = pos_ext(_seperator, _last_pos);
			if (_pos < 0) {
				break;
			}
			_list.push(copy(_last_pos, _pos-_last_pos));	
			_last_pos = _pos+_separator_len;
		}
		_list.push(copy(_last_pos, _len-_last_pos));	
		return _list;
	}
	
	static slice = function(_start=0, _stop=-1, _step=1) {
		_start = __wrap_index(_start);
		_stop = __wrap_index(_stop);
		
		if (not is_numeric(_start)) {
			throw dunder.init(DunderExceptionValueError, "Start must be numeric");	
		}
		if (not is_numeric(_stop)) {
			throw dunder.init(DunderExceptionValueError, "Stop must be numeric");	
		}
		if (not is_numeric(_step)) {
			throw dunder.init(DunderExceptionValueError, "Step must be numeric");	
		}

		var _range = dunder.init(DunderRange, _start, _stop, _step);
		return dunder.map(_range, method(self, __getitem__));
	}
	
	static __wrap_index = function(_index) {
		var _len = string_length(__value);
		return (_index % _len + _len) % _len;
	}
	
	static __is_whitespace = function(_char) {
		return _char == " " or _char == "\t" or _char == "\r" or _char == "\n";
	}
	
	static trim = function() {
		var _copy = __clone__();
		_copy.trim_in_place();
		return _copy;
	}
	
	static ltrim = function() {
		var _copy = __clone__();
		_copy.ltrim_in_place();
		return _copy;
	}
		
	static rtrim = function() {
		var _copy = __clone__();
		_copy.rtrim_in_place();
		return _copy;
	}
	
	static trim_in_place = function() {
		ltrim_in_place();
		rtrim_in_place();
		return self;
	}
	
	static ltrim_in_place = function() {
		var _len = string_length(__value);
		for (var _i=0; _i<_len; _i++) {
			if (not __is_whitespace(string_char_at(__value, _i+1))) {
				break;
			}
		}
		__value = string_delete(__value, 1, _i);
		return self;
	}
	
	static rtrim_in_place = function() {
		var _len = string_length(__value);
		for (var _i=_len-1; _i>=0; _i--) {
			if (not __is_whitespace(string_char_at(__value, _i+1))) {
				break;
			}
		}
		__value = string_copy(__value, 1, _i+1);
		return self;
	}

	static from_file = function(_input) {
		var _path = dunder.as_string(_input);
		if (not file_exists(_path)) {
			throw dunder.init(DunderExceptionFileError, "Can't load file "+typeof(_path));
		}
			
		var _buff = buffer_load(_path);
		var _str = buffer_read(_buff, buffer_text);
		buffer_delete(_buff);
		
		__value = _str;
		return self;
	}
}