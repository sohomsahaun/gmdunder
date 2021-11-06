function DunderBaseStruct() constructor {
	// Base struct for all Dunder structs to inherit from
	
	// Tracks inheritence
	__bases__ = [DunderBaseStruct]
	__bases_len__ = 1;
	
	// Overridable methods
	static __init__ = function() {}
	static __del__ = function() {}
	static __str__ = function() {
		return json_stringify(self);
	}
	static __repr__ = function() {
		return 	"<dunder '"+instanceof(self)+"'>";
	}
	
	// Mathematical operators
	static __add__ = function() {
		throw init(DunderExceptionNotImplemented, "__add__ was not implemented");
	}
	static __mul__ = function() {
		throw init(DunderExceptionNotImplemented, "__mul__ was not implemented");
	}
	
	// Type checking methods
	
	static __type__ = function() {
		return __bases__[0];	
	}
	static __is_subtype__ = function(_type) {
		// checks if this constructor is in my ancestors
		var _len = array_length(__bases__);
		for (var _i=0; _i<_len; _i++) {
			if (__bases__ == _type) {
				return true;
			}
		}
		return false;
	}
	static __is_type__ = function(_type) {
		// checks if I was constructed by
		return __bases__[0] == _type;
	}
	static __is_same_type_as__ = function(_other) {
		// Checks if I am the same as the other guy	
		__dunder__.__throw_if_not_struct_with_method(_other, "__type__");
		return __type__() == _other.__type__();
	}
	
	// My personal copy of dunder, so I can run these myself
	static __dunder__ = new Dunder()
	
	// Internal mechanisms
	static __bases_add__ = function(_constructor) {
		// Constructs the inheritance array __bases__
		array_insert(__bases__, 0, _constructor);
		__bases_len__ += 1;
	}
}