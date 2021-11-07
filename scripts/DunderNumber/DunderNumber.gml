function DunderNumber() : DunderBaseStruct() constructor {
	// A number wrapper
	__bases_add__(DunderNumber);
	
	static __init__ = function(_input) {
		if (__dunder__.is_struct_with_method(_input, "__number__")) {
			value = _input.__number__();
		}
		else if (__dunder__.is_dunder_struct(_input)) {
			throw __dunder__.init(DunderExceptionTypeError, "Can't coerse type "+instanceof(_input)+" to number");
		}
		else if (is_numeric(_input)) {
			value = _input;
		}
		else {
			throw __dunder__.init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to dict");
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
		return string(value);
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" value="+__str__()+">";
	}
	static __bool__ = function() {
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
		if (is_numeric(_other)) {
			return value + _other;	
		}
		__dunder__.__throw_if_not_struct_with_method(_other, "__number__");
		return __clone__(value + _other.__number__());
	}
	static __sub__ = function(_other) {
		if (is_numeric(_other)) {
			return value - _other;	
		}
		__dunder__.__throw_if_not_struct_with_method(_other, "__number__");
		return __clone__(value - _other.__number__());
	}
	static __rsub__ = function(_other) {
		if (is_numeric(_other)) {
			return _other - value;	
		}
		__dunder__.__throw_if_not_struct_with_method(_other, "__number__");
		return __clone__(_other.__number__() - value);
	}
	static __mul__ = function(_other) {
		if (is_numeric(_other)) {
			return value * _other;
		}
		__dunder__.__throw_if_not_struct_with_method(_other, "__number__");
		return __clone__(value * _other);
	}
	static __div__ = function(_other) {
		if (is_numeric(_other)) {
			return value / _other;
		}
		__dunder__.__throw_if_not_struct_with_method(_other, "__number__");
		return __clone__(value / _other);
	}
	static __rdiv__ = function(_other) {
		if (is_numeric(_other)) {
			return _other / value;
		}
		__dunder__.__throw_if_not_struct_with_method(_other, "__number__");
		return __clone__(_other / value);
	}
	static __eq__ = function(_other) {
		if (is_numeric(_other)) {
			return value == _other
		}
		__dunder__.__throw_if_not_struct_with_method(_other, "__number__");
		return value == _other.__number__();
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