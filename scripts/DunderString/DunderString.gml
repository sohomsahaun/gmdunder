function DunderString() : DunderBaseStruct() constructor {
	// A string wrapper
	__bases_add__(DunderString);
	
	static __init__ = function() {
		value = "";
		for (var _i=0; _i<argument_count; _i++) {
			show_debug_message(argument[_i]);
			value += string(argument[_i]);	
		}
	}
	
	static __add__ = function(_other) {
		if (is_string(_other)) {
			return value + _other;	
		}
		
		__dunder__.__throw_if_not_struct_with_method(_other, "__str__");
		return value + _other.__str__();
	}
	
	static __mul__ = function(_other) {
		if (not is_numeric(_other)) {
			throw init(DunderExceptionBadType, "__mul__ expected numerical type");	
		}
		
		var _str = ""
		for (var _i=0; _i<_other; _i++) {
			_str += value;
		}
		return _str;
	}
	
	static __str__ = function() {
		return value;
	}
	
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" value='"+value+"'>";
	}
	
	static __is_same_type_as__ = function(_other) {
		if (is_string(_other)) {
			return true;	
		}
		return __type__() == _other.__type__();
	}
}