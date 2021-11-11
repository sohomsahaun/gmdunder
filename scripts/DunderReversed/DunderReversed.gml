function DunderReversed() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderReversed);
	// An object that reverses another object
	static __init__ = function(_target) {
		if (dunder.is_struct_with_method(_target, "__getitem__") and
			dunder.is_struct_with_method(_target, "__len__")) {
			target = _target;
			__target_len = target.__len__()
		}
		else {
			throw dunder.init(DunderExceptionTypeError, "Provided struct does not have __getitem__ and __len__");	
		}
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" target="+instanceof(target)+">";
	}
	
	static __iter__ = function() {
		return dunder.init(DunderIterator, method(self, __getitem__), __target_len);
	}
	
	static __len__ = function() {
		return __target_len;
	}
	
	static __getitem__ = function(_index) {
		return target.__getitem__(__target_len - _index - 1);
	}
}