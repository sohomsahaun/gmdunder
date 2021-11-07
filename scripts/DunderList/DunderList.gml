function DunderList() : DunderBaseStruct() constructor {
	// A list wrapper
	__bases_add__(DunderList);

	// Initializer
	static __init__ = function(_input, _copy=false) {
		if (__dunder__.is_struct_with_method(_input, "__array__")) {
			var _incoming_list = _input.__array__();
		}
		else if (__dunder__.is_dunder_struct(_input)) {
			throw __dunder__.init(DunderExceptionTypeError, "Can't coerse type "+instanceof(_input)+" to list");
		}
		else if (is_array(_input)) {
			var _incoming_list = _input;
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
			_input = __array__();
		}
		return __dunder__.init(self.__type__(), _input, true);
	}
	
	static __add__ = function(_other) {
		if (is_array(_other)) {
			var _input = _other;
		}
		else if (__dunder__.is_struct_with_method(_input, "__array__")) {
			var _input = _other.__array__();
		}
		else {
			throw __dunder__.init(DunderExceptionTypeError, "Expected array type");	
		}
		
		var _len = array_length(values);
		var _input_len = array_length(_input);
		var _array = array_create(_len + _input_len);
		array_copy(_array, 0, values, 0, _len);
		array_copy(_array, _len, _input, 0, _input_len);
		
		return __clone__(_array)
	}
	static __mul__ = function(_other) {
		if (not is_numeric(_other) or _other < 0) {
			throw __dunder__.init(DunderExceptionTypeError, "Expected numeric type");
		}
		
		_other = ceil(_other);
		var _len = array_length(values);
		var _array = array_create(_other * _len);
		for (var _i=0; _i<_other; _i++) {
			array_copy(_array, _i*_len, values, 0, _len);
		}
		return __clone__(_array);
	}
	static __eq__ = function(_other) {
		if (is_array(_other)) {
			var _input = _other;	
		}
		else if (__dunder__.is_struct_with_method(_input, "__array__")) {
			var _input = _other.__array__();
		}
		else {
			throw __dunder__.init(DunderExceptionTypeError, "Expected array type");	
		}
		return array_equals(values, _input);
	}
	static __radd__ = __add__;
	static __rmul__ = __mul__;
	static add = __add__;
	static mul = __mul__;
	static eq = __eq__;
	
	// Representation methods
	static __repr__ = function() {
		return 	"<dunder '"+instanceof(self)+"' length="+string(array_length(values))+">";
	}
	static __array__ = function() {
		return values;
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
	static equals = __eq__;
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
		if (__dunder__.is_struct_with_method(_other, "__array__")) {
			var _input = _other.__array__()
		}
		else if (is_array(_other)) {
			var _input = _other; 
		}
		else {
			throw __dunder__.init(DunderExceptionTypeError, "Expected numerical type");	
		}
		array_copy(values, array_length(values), _input, 0, array_length(_input));
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
			var _j = irandom_range(_i, _len-1);
			var _left = values[_i];
			values[@ _i] = values[_j];
			values[@ _j] = _left;
		}
	}
	static slice = function(_start=0, _stop=undefined, _step=1) {
		_start = _start ?? 0;
		_stop = _stop ?? array_length(values);
		var _range = __dunder__.init(DunderRange, _start, _stop, _step);
		return __dunder__.map(_range, method(self, __getitem__));
	}
	
	static __wrap_index = function(_index) {
		var _len = array_length(values);
		return (_index % _len + _len) % _len;
	}
}