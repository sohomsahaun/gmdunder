function DunderSet() : DunderDict() constructor { REGISTER_SUBTYPE(DunderSet);
	// A set of objects (partial implementation)
	static __init__ = function(_input) {
		if (dunder.can_array(_input)) {
			var _incoming_list = dunder.as_array(_input);
		}
		else if (is_undefined(_input)) {
			var _incoming_list = [];	
		}
		else {
			throw dunder.init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to list");
		}
		
		__values = {};
		var _len = array_length(_incoming_list);
		for (var _i=0; _i<_len; _i++) {
			__values[$ _incoming_list[_i]] = true;
		}
	}	
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
		return dunder.init(self.__type__(), __array__(), true);
		}
		return dunder.init(self.__type__(), _input, true);
	}
	
	// Representation methods
	static __repr__ = function() {
		return 	"<dunder '"+instanceof(self)+"' length="+variable_struct_names_count(__values)+">";
	}
	static __array__ = function() {
		return variable_struct_get_names(__values);
	}
	static __bool__ = function() {
		return variable_struct_names_count(__values) > 0;
	}
	
	// Mathematical operators
	static __add__ = function(_other) {
		var _array = dunder.as_array(_other);
		var _new_set = __clone__();
		_new_set.update(_array)
		return _new_set;
	}
	
	// Structure methods
	static __len__ = function() {
		return variable_struct_names_count(__values);
	}
	static __contains__ = function(_value) {
		return variable_struct_exists(__values, _value);
	}
	static __getattr__ = function(_value) {
		if (variable_struct_exists(__values, _value)) {
			return _value;	
		}
		throw dunder.init(DunderExceptionKeyError);
	}
	static __setattr__ = function(_value) {
		variable_struct_set(__values, _value, true);
	}
	static __hasattr__ = function(_value) {
		return variable_struct_exists(__values, _value);
	}
	static __removeattr__ = function(_value) {
		if (variable_struct_exists(__values, _value)) {
			variable_struct_remove(__values, _value);
			return true;
		}
		throw dunder.init(DunderExceptionKeyError);
	}
	static len = __len__;
	static contains = __contains__;
	static get = __getattr__;
	static set = __setattr__;
	static has = __hasattr__;
	static remove = __removeattr__;
	
	// Iteration methods
	static __iter__ = function() {
		return dunder.init(DunderIterator, method(self, __getattr__), variable_struct_get_names(__values));
	}
	
	// Set methods
	static values = function() {
		return dunder.init(DunderList, variable_struct_get_names(__values));
	}
	static update = function(_input) {
		var _list = dunder.as_array(_input);
		var _len = array_length(_list);
		for (var _i=0; _i<_len; _i++) {
			__values[$ _list[_i]] = true;
		}
		return self;
	}
	static clear = function() {
		__values = {};	
	}
	
}