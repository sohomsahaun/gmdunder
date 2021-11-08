function DunderList() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderList);
	// A list wrapper
	static __rng = __dunder__.init(DunderRng);

	// Initializer
	static __init__ = function(_input, _copy=false) {
		if (__dunder__.can_array(_input)) {
			var _incoming_list = __dunder__.as_array(_input);
		}
		else if (is_undefined(_input)) {
			var _incoming_list = [];
		}
		else {
			throw __dunder__.init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to list");
		}
		
		if (_copy) {
			values = [];
			array_copy(values, 0, _incoming_list, 0, array_length(_incoming_list));
		}
		else {
			values = _incoming_list;
		}
	}	
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
		return __dunder__.init(self.__type__(), __array__(), true);
		}
		return __dunder__.init(self.__type__(), _input, true);
	}
	
	// Mathematical operators
	static __add__ = function(_other) {
		var _array = __dunder__.as_array(_other)
		var _other_len = array_length(_other);
		
		var _len = array_length(values);
		var _new_array = array_create(_len + _other_len);
		array_copy(_array, 0, values, 0, _len);
		array_copy(_array, _len, _other, 0, _other_len);
		
		return __clone__(_new_array)
	}
	static __multiply__ = function(_other) {
		var _number = ceil(__dunder__.as_number(_other));

		var _len = array_length(values);
		var _new_array = array_create(_number * _len);
		for (var _i=0; _i<_number; _i++) {
			array_copy(_new_array, _i*_len, values, 0, _len);
		}
		return __clone__(_new_array);
	}
	static __equals__ = function(_other) {
		if (not __dunder__.can_array(_other)) {
			return false;	
		}
		return array_equals(values, __dunder__.as_array(_other));
	}
	static __radd__ = __add__;
	static __rmultiply__ = __multiply__;
	static add = __add__;
	static multiply = __multiply__;
	static equals = __equals__;
	
	// Representation methods
	static __repr__ = function() {
		return 	"<dunder '"+instanceof(self)+"' length="+string(array_length(values))+">";
	}
	static __array__ = function() {
		return values;
	}
	static __bool__ = function() {
		return array_length(values) > 0;
	}
	
	// Structure methods
	static __len__ = function() {
		return array_length(values);
	}
	static __contains__ = function(_value) {
		var _len = array_length(values);
		for (var _i=0; _i<_len; _i++) {
			if (values[_i] == _value) {
				return true;
			}
		}
		return false;
	}
	static __getitem__ = function(_index) {
		var _len = array_length(values);
		if (_len == 0) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (string is empty)");
		}
		if (_index <= -_len or _index >= _len) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = __wrap_index(_index);
		return array_get(values, _index);
	}
	static __setitem__ = function(_index, _value) {
		var _len = array_length(values);
		if (_index < -_len or _index > _len) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = __wrap_index(_index);
		array_set(values, _index, _value);
	}
	static __hasitem__ = function(_index) {
		var _len = array_length(values);
		if (_len == 0) {
			return false;
		}
		_index = __wrap_index(_index);
		return _index >= 0 and _index < _len;
	}
	static __removeitem__ = function(_index) {
		var _len = array_length(values);
		if (_index <= -_len or _index >= _len) {
			throw __dunder__.init(DunderExceptionIndexError, "Index "+string(_index)+" out of range (0-"+string(_len-1)+")");
		}
		_index = __wrap_index(_index);
		array_delete(values, _index+1, 1);
	}
	static len = __len__;
	static contains = __contains__;
	static get = __getitem__;
	static set = __setitem__;
	static has = __hasitem__;
	static remove = __removeitem__;

	// Iteration methods
	static __iter__ = function() {
		return __dunder__.init(DunderIterator, method(self, __getitem__), __len__());
	}
	
	// Gamemaker array functions
	static equals = __equals__;
	static push = function(_value) { array_push(values, _value); }
	static pop = function(_value) { return array_pop(values); }
	static insert = function(_index, _value) { return array_insert(values, _index, _value); }
	static delete_ = function(_index, _number) { return array_delete(values, _index, _number); }
	static sort = function(_func=true) { return array_sort(values, _func); }
	static resize = function(_new_size) { return array_resize(values, _new_size); }
	
	// List functions
	static append = function(_value) {
		array_push(values, _value)
		for (var _i=1; _i<argument_count; _i++) {
			array_push(values, argument[_i]);	
		}
	}
	static clear = function() {
		array_resize(values, 0);	
	}
	static count = function(_value) {
		var _count = 0;
		var _len = array_length(values);
		for (var _i=0; _i<_len; _i++) {
			if (values[_i] == _value) {
				_count += 1;
			}
		}
		return _count;
	}
	static extend = function(_other) {
		var _array = __dunder__.as_array(_other)
		array_copy(values, array_length(values), _array, 0, array_length(_array));
	}
	static index = function(_value) {
		var _len = array_length(values);
		for (var _i=0; _i<_len; _i++) {
			if (values[_i] == _value) {
				return _i;
			}
		}
		throw __dunder__.init(DunderExceptionValueError, "Can't find value "+string(_value));	
	}
	static remove_value = function(_value) {
		var _index = index(_value);
		array_delete(values, _index, 1);	
	}
	static reverse = function(_value) {
		var _len = array_length(values);
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			_array[_len-_i-1] = values[_i];
		}
		values = _array;
	}
	static shuffle = function() {
		var _len = array_length(values);
		for (var _i=0; _i<_len; _i++) {
			var _j = __rng.rand_int(_i, _len-1);
			var _left = values[_i];
			values[@ _i] = values[_j];
			values[@ _j] = _left;
		}
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
		var _result = __dunder__.map(_range, method(self, __getitem__));
		delete _range;
		return _result;
	}
	static join = function(_separator=",") {
		var _str = "";
		var _len = array_length(values);
		for (var _i=0; _i<_len; _i+=1) {
			if (_i == 0) {
				_str += values[_i];	
			}
			else {
				_str += _separator + values[_i];
			}
		}
		return _str;	
	}
	
	static __wrap_index = function(_index) {
		var _len = array_length(values);
		return (_index % _len + _len) % _len;
	}
}