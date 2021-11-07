function DunderString() : DunderBaseStruct() constructor {
	// A string wrapper
	__bases_add__(DunderString);
	
	static __init__ = function() {
		value = "";
		for (var _i=0; _i<argument_count; _i++) {
			var _input = argument[_i];
			if (__dunder__.is_struct_with_method(_input, "__str__")) {
				value += _input.__str__();
			}
			else {
				value += string(argument[_i]);
			}
		}
	}	
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
			_input = value;
		}
		return __dunder__.init(self.__type__(), _input);
	}

	// Representation methods
	static __str__ = function() {
		return value;
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" value='"+value+"'>";
	}
	static __bool__ = function() {
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
		if (is_string(_other)) {
			return value + _other;	
		}
		__dunder__.__throw_if_not_struct_with_method(_other, "__str__");
		return __clone__(value + _other.__str__());
	}
	static __mul__ = function(_other) {
		if (not is_numeric(_other)) {
			throw __dunder__.init(DunderExceptionTypeError, "Expected numerical type");	
		}
		return __clone__(string_repeat(value, _other));
	}
	static __eq__ = function(_other) {
		if (is_string(_other)) {
			return value == _other;
		}
		__dunder__.__throw_if_not_struct_with_method(_other, "__str__");
		return value == _other.__str__();
	}
	static __radd__ = __add__;
	static __rmul__ = __mul__;
	static add = __add__;
	static mul = __mul__;
	static eq = __eq__;
	
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
		_index = (_index % _len + _len) % _len;
		return string_char_at(value, _index+1);
	}
	static __setitem__ = function(_index, _value) {
		var _len = string_length(value);
		if (_index < -_len or _index > _len) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = (_index % _len + _len) % _len;
		return string_insert(_value, value, _index+1);
	}
	static __hasitem__ = function(_index) {
		var _len = string_length(value);
		if (_len == 0) {
			return false;	
		}
		_index = (_index % _len + _len) % _len;
		return _index >= 0 and _index < _len;
	}
	static __removeitem__ = function(_index) {
		var _len = string_length(value);
		if (_index <= -_len or _index >= _len) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
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
	
	
}