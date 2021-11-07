function DunderRange() : DunderBaseStruct() constructor {
	// A range of values
	__bases_add__(DunderRange);
	
	static __init__ = function(_start=0, _stop=undefined, _step=1) {
		start = _start;
		stop = _stop;
		step = _step;
		
		if (step == 0) {
			throw __dunder__.init(DunderExceptionValueError, "Step can't be zero");	
		}
		if (sign(stop-start) != sign(step)) {
			throw __dunder__.init(DunderExceptionValueError, "Start and stop value doesn't match step");	
		}
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" start="+string(start)+" stop="+string(stop)+" step="+string(step)+">";
	}
	
	static __array__ = function() {
		var _len = __len__();
		var _array = array_create(_len);
		for (var _i=0; _i<_len; _i++) {
			_array[_i] = __getitem__(_i);
		}
		return _array;
	}
	
	static __iter__ = function() {
		return __dunder__.init(DunderIterator, method(self, __getitem__), __len__());
	}
	
	static __len__ = function() {
		return ceil((stop - start)/step);
	}
	
	static __getitem__ = function(_index) {
		return start + _index*step;
	}
}