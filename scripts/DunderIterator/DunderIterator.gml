function DunderIterator() : DunderBaseStruct() constructor {
	// An iterator iterator
	__bases_add__(DunderIterator);
	
	static __init__ = function(_getter, _keys_or_len) {
		if (__dunder__.can_array(_keys_or_len)) {
			__keys = __dunder__.as_array(_keys_or_len);
			__max_index = array_length(__keys);
			__advance = __advance_key;
		}
		else if (is_numeric(_keys_or_len)) {
			__max_index = _keys_or_len;
			__advance = __advance_index;
		}
		else {
			throw __dunder__.init(DunderExceptionTypeError, "Can't use "+instanceof(_keys_or_len)+" for keys or length");
		}
		
		__getter = _getter;
		index = 0;
	}
	
	// Iteration methods
	static __next__ = function() {
		if (index >= __max_index) {
			throw __dunder__.init(DunderExceptionStopIteration);
		}
		
		var _index_or_key = __advance();
		var _value = __getter(_index_or_key);
		return [_value, _index_or_key];
	}
	
	// Iterator methods
	static __advance_key = function() {
		return __keys[index++];
	}
	
	static __advance_index = function() {
		return index++;
	}
}