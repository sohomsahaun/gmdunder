function DunderNumber() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderNumber);
	// A number wrapper
	
	static __init__ = function(_input) {
		if (__dunder__.can_number(_input)) {
			value = __dunder__.as_number(_input);
		}
		else {
			throw __dunder__.init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to dict");
		}
	}	
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
			return __dunder__.init(self.__type__(), value);
		}
		return __dunder__.init(self.__type__(), _input);
	}

	// Representation methods
	static __string__ = function() {
		return string(value);
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" value="+__string__()+">";
	}
	static __boolean__ = function() {
		return bool(value);	
	}
	static __number__ = function() {
		return value;
	}
	static toString = function() {
		return string(value);	
	}
	
	// Mathematical operators
	static __add__ = function(_other) {
		var _number = __dunder__.as_number(_other)
		return __clone__(value + _number);
	}
	static __subtract__ = function(_other) {
		var _number = __dunder__.as_number(_other);
		return __clone__(value - _number);
	}
	static __rsubtract__ = function(_other) {
		var _number = __dunder__.as_number(_other)
		return __clone__(_number - value);
	}
	static __multiply__ = function(_other) {
		var _number = __dunder__.as_number(_other)
		return __clone__(value * _number);
	}
	static __divide__ = function(_other) {
		var _number = __dunder__.as_number(_other)
		return __clone__(value / _number);
	}
	static __rdivide__ = function(_other) {
		var _number = __dunder__.as_number(_other)
		return __clone__(_number / value);
	}
	static __equals__ = function(_other) {
		if (not __dunder__.can_number(_other)) {
			return false;
		}
		return value == __dunder__.as_number(_other);
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
		value += _incr;
	}
	static incr_post = function() {
		return value++;
	}
	static incr_pre = function() {
		return ++value;
	}
}