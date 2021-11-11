function DunderIterator() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderIterator);
	// An iterator iterator
	
	static __init__ = function(_getter, _keys_or_len) {
		if (dunder.can_array(_keys_or_len)) {
			__keys = dunder.as_array(_keys_or_len);
			__max_index = array_length(__keys);
			__advance = __advance_key;
		}
		else if (is_numeric(_keys_or_len)) {
			__max_index = _keys_or_len;
			__advance = __advance_index;
		}
		else {
			throw dunder.init(DunderExceptionTypeError, "Can't use "+instanceof(_keys_or_len)+" for keys or length");
		}
		
		__getter = _getter;
		index = 0;
	}
	
	// Iteration methods
	static __next__ = function() {
		if (index >= __max_index) {
			throw dunder.init(DunderExceptionStopIteration);
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