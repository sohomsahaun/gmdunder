function DunderIteratorDict() : DunderBaseStruct() constructor {
	// An iterator for a dict-like thing
	__bases_add__(DunderIteratorDict);
	
	static __init__ = function(_struct, _keys) {
		struct = _struct;
		keys = _keys
		max_index = array_length(keys);
		next_index = 0;
	}
	
	static __next__ = function() {
		if (next_index >= max_index) {
			throw __dunder__.init(DunderExceptionStopIteration);
		}
		
		var _key = keys[next_index];
		next_index += 1;
		return [_key, struct[$ _key]];
	}
}