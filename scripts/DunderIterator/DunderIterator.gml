function DunderIterator() : DunderBaseStruct() constructor {
	// An iterator iterator
	__bases_add__(DunderIterator);
	
	static __init__ = function(_getter, _keys_or_len) {
		if (__dunder__.is_struct_with_method(_keys_or_len, "__array__")) {
			keys = _keys_or_len.__array__();
			max_index = _keys_or_len.__len__();
			advance = advance_key;
		}
		else if (is_array(_keys_or_len)) {
			keys = _keys_or_len
			max_index = array_length(keys);
			advance = advance_key;
		}
		else {
			max_index = _keys_or_len;
			advance = advance_index;
		}
		
		getter = _getter;
		index = 0;
	}
	
	static __next__ = function() {
		if (index >= max_index) {
			throw __dunder__.init(DunderExceptionStopIteration);
		}
		
		var _index_or_key = advance();
		var _value = getter(_index_or_key);
		return [_value, _index_or_key];
	}
	
	static advance_key = function() {
		return keys[index++];
	}
	
	static advance_index = function() {
		return index++;
	}
}