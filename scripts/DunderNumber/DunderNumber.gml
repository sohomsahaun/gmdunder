function DunderNumber() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderNumber);
	// A number wrapper
	
	static __init__ = function(_input) {
		if (dunder.can_number(_input)) {
			__value = dunder.as_number(_input);
		}
		else {
			throw dunder.init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to dict");
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
		return string(__value);
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" value="+__string__()+">";
	}
	static __boolean__ = function() {
		return bool(__value);	
	}
	static __number__ = function() {
		return __value;
	}
	static toString = function() {
		return string(__value);	
	}
	static as_string = __string__;
	static as_boolean = __boolean__;
	static as_number = __number__;
	
	// Mathematical operators
	static __add__ = function(_other) {
		var _number = dunder.as_number(_other)
		return __clone__(__value + _number);
	}
	static __subtract__ = function(_other) {
		var _number = dunder.as_number(_other);
		return __clone__(__value - _number);
	}
	static __rsubtract__ = function(_other) {
		var _number = dunder.as_number(_other)
		return __clone__(_number - __value);
	}
	static __multiply__ = function(_other) {
		var _number = dunder.as_number(_other)
		return __clone__(__value * _number);
	}
	static __divide__ = function(_other) {
		var _number = dunder.as_number(_other)
		return __clone__(__value / _number);
	}
	static __rdivide__ = function(_other) {
		var _number = dunder.as_number(_other)
		return __clone__(_number / __value);
	}
	static __equals__ = function(_other) {
		if (not dunder.can_number(_other)) {
			return false;
		}
		return __value == dunder.as_number(_other);
	}
	static __radd__ = __add__;
	static __rmultiply__ = __multiply__;
	static add = __add__;
	static subtract = __subtract__;
	static multiply = __multiply__;
	static divide = __divide__;
	static equals = __equals__;
	
	// Type checking methods
	static __is_same_type_as__ = function(_other) {
		if (is_numeric(_other)) {
			return true;	
		}
		return __type__() == _other.__type__();
	}
	
	// Number functions
	static incr = function(_incr=1) {
		__value += _incr;
	}
	static incr_post = function() {
		return __value++;
	}
	static incr_pre = function() {
		return ++__value;
	}
}