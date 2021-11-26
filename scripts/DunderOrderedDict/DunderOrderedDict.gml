function DunderOrderedDict() : DunderDict() constructor { REGISTER_SUBTYPE(DunderOrderedDict);
	// A dict that maintains order
	
	static __init__ = function(_input) {
		__values = {};
		__order = [];
		
		if (not is_undefined(_input)) {
			update(_input);
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
		return 	"<dunder '"+instanceof(self)+"' ordered="+string(__order)+">";
	}
	static __array__ = function() {
		var _len = array_length(__order);
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			var _key = __order[_i];
			_array[_i] = [_key, __values[$ _key]];
		}
		return _array;
	}
	static as_array = __array__;

	// Mathematical operators
	static __add__ = function(_other) {
		var _new_ordered_dict = __clone__();
		return _new_ordered_dict.update(_other);
	}
	
	// Structure methods
	static __remove_from_order = function(_key) {
		var _len = array_length(__order);
		for (var _i=_len-1; _i>=0; _i--) {
			if (__order[_i] == _key) {
				array_delete(__order, _i, 1);
			}
		}
	}
	static __setattr__ = function(_key, _value) {
		if (variable_struct_exists(__values, _key)) {
			__remove_from_order(_key)
		}
		variable_struct_set(__values, _key, _value);
		array_push(__order, _key);
	}
	static __removeattr__ = function(_key) {
		if (variable_struct_exists(__values, _key)) {
			__remove_from_order(_key);
			variable_struct_remove(__values, _key);
			return true;
		}
		throw dunder.init(DunderExceptionKeyError);
	}
	static set = __setattr__;
	static remove = __removeattr__;
	
	// Iteration methods
	static __iter__ = function() {
		return dunder.init(DunderIterator, method(self, __getattr__), __order);
	}
	
	// Dict methods
	static keys = function() {
		return dunder.init_list(__order);
	}
	static items = function() {
		return dunder.init_list(__array__);	
	}
	static values = function() {
		var _len = array_length(__order);
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			_array[_i] = __values[$ __order[_i]];
		}
		return dunder.init_list(_array);
	}
	static update = function(_input) {
		if (__is_same_type_as__(_input)) {
			var _len = array_length(_input.__order);
			for (var _i=0; _i<_len; _i++) {
				var _key = __order[_i];
			
				if (variable_struct_exists(__values, _key)) {
					__remove_from_order(_key);
				}
			
				variable_struct_set(__values, _key,_input.__values[$ _key]);
				array_push(__order, _key);
			}
		}
		else if (dunder.can_array(_input)) {
			var _array = dunder.as_array(_input);
			var _len = array_length(_array);
			for (var _i=0; _i<_len; _i++) {
				var _pair = _array[_i];
				if (not is_array(_pair) or array_length(_pair) != 2) {
					throw dunder.init(DunderExceptionTypeError, "Can't coerse array, incorrect inner dimensions (must be [key, value])");
				}
				__values[$ _pair[0]] = _pair[1];
				array_push(__order, _pair[0]);
			}
		}
		else {
			throw dunder.init(DunderExceptionTypeError, "Can't update ordered dict with "+typeof(_input));	
		}
		
		return self;
	}
	
	static clear = function() {
		__values = {};
		__order = [];
	}
}