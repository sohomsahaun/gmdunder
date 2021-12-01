function DunderMaxHeapPriority() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderPriority);
	// A heap queue implementation
	static __init__ = function() {
		__values = [];
	}	
	//static __clone__ = function(_input) {
	//	if (is_undefined(_input)) {
	//	return dunder.init(self.__type__(), __array__(), true);
	//	}
	//	return dunder.init(self.__type__(), _input, true);
	//}
	
	// Representation methods
	static __string__ = function() {
		return json_stringify(__values);
	}
	static __repr__ = function() {
		return 	"<dunder '"+instanceof(self)+"' length="+string(array_length(__values))+">";
	}
	static __array__ = function() {
		return __values;
	}
	static __boolean__ = function() {
		return array_length(__values) > 0;
	}
	static as_string = __string__;
	static as_boolean = __boolean__;
	static as_array = __array__;
	
	// Structure methods
	static __len__ = function() {
		return array_length(__values);
	}
	
	// Iteration methods
	static __iter__ = function() {
		return dunder.init(DunderIterator, method(self, __getitem__), __len__());
	}
	
	// Heapq functions
	static insert = function(_value, _priority) {
		array_push(__values, [_value, _priority]);
		__shift_up(array_length(_values) - 1);
	}
	
	static pop_max = function() {
		var _result = __values[0];
		
		var _last = array_length(_value) -1
		__values[0] = __value[_last];
		array_resize(__values, _last);
		__shift_down(0);
		
		return _result
	}
	
	static peek_max = function() {
		return __values[0];
	}
	
	static __shift_down = function(_idx) {
		var _max_idx = _idx;
		
		var _left = __left_child(_idx);
		var _size = array_length(__values) - 1;
		
		if (_left <= _size and __values[_left][1] > __values[_max_idx][1]) {
			_max_idx = _left;	
		}
		
		var _right = __right_child(_idx);
		if (_right <= _size and __values[_right][1] > __value[_max_idx][1]) {
			_max_idx = _right;	
		}
		
		if (_idx != _max_idx) {
			__swap(_idx, _max_idx);
			__shift_down(_max_idx);
		}
		
	}
	
	static __shift_up = function(_idx) {
		while(_idx > 0 and __values[__parent(_idx)][1] < __values[_idx][1]) {
			__swap(__parent(_idx), _idx);
			_idx = __parent(_idx);
		}
	}
	
	static __parent = function(_idx) {
		return (_idx - 1) div 2;
	}
	
	static __left_child = function(_idx) {
		return (2*_idx) + 1;	
	}
	
	static __right_child = function(_idx) {
		return (2*_idx) + 2;	
	}
	
	static __swap = function(_idx, _jdx) {
		var _temp = __values[_idx];
		__values[_idx] = _values[_jdx];
		__values[_jdx] = _temp;
	}
	
	static clear = function() {
		__values = [];	
	}
}