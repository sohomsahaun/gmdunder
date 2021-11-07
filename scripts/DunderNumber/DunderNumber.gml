function DunderNumber() : DunderBaseStruct() constructor {
	// A number wrapper
	__bases_add__(DunderNumber);
	
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
	static __sub__ = function(_other) {
		var _number = __dunder__.as_number(_other);
		return __clone__(value - _number);
	}
	static __rsub__ = function(_other) {
		var _number = __dunder__.as_number(_other)
		return __clone__(_number - value);
	}
	static __mul__ = function(_other) {
		var _number = __dunder__.as_number(_other)
		return __clone__(value * _number);
	}
	static __div__ = function(_other) {
		var _number = __dunder__.as_number(_other)
		return __clone__(value / _number);
	}
	static __rdiv__ = function(_other) {
		var _number = __dunder__.as_number(_other)
		return __clone__(_number / value);
	}
	static __eq__ = function(_other) {
		if (not __dunder__.can_number(_other)) {
			return false;
		}
		return value == __dunder__.as_number(_other);
	}
	static __radd__ = __add__;
	static __rmul__ = __mul__;
	static add = __add__;
	static sub = __sub__;
	static mul = __mul__;
	static div_ = __div__;
	static eq = __eq__;
	
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