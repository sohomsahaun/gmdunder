function DunderIterator() : DunderBaseStruct() constructor {
	// An iterator iterator
	__bases_add__(DunderIterator);
	
	static __init__ = function(_getter, _keys_or_len) {
		if (is_array(_keys_or_len)) {
			keys = _keys_or_len
			max_index = array_length(keys);
			advance = function() { return keys[index++]; };
			index = 0;
		}
		else {
			max_index = _keys_or_len;
			advance = function() { return index++; };
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
		return [_index_or_key, _value];
	}
}