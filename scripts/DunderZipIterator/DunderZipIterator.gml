function DunderZipIterator() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderZipIterator);
	// A combination of iterators
	static __init__ = function(_iterator_array) {
		__iterators = dunder.init_list(_iterator_array);
		__counter = 0;
	}
	
	// Representation methods
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" members="+string(__iterators.len())+">";
	}
	
	// Iteration methods
	static __next__ = function() {
		var _len = __iterators.len();
		var _values = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			_values[_i] = __iterators.get(_i).__next__()[0];	
		}
		return [_values, __counter++];
	}
}
