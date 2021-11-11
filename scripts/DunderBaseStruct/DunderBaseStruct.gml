function DunderBaseStruct() constructor {
	// Base struct for all Dunder structs to inherit from
	static __super_method_lookup__ = {}
	
	// Tracks inheritence
	static __bases__ = [DunderBaseStruct]
	static __bases_add__ = function(_constructor) {
		// Constructs the inheritance array __bases__
		var _new_base = [_constructor]
		array_copy(_new_base, 1, __bases__, 0, array_length(__bases__));
		__super_method_lookup__[$ _constructor] = {
			__init__:__init__,
			__cleanup__:__cleanup__,
		}
		return _new_base;
	}
	
	static __super__= function(_constructor, _method="__init__") {
		return __super_method_lookup__[$ _constructor][$ _method];
	}
	
	// My personal copy of dunder, so I can run these myself
	static dunder = new Dunder()
	static __get_shared_logger__ = function() {
		return dunder.get_shared_logger();
	}
	static __get_shared_env__ = function() {
		return dunder.get_sared_env();
	}
	
	// Creation methods
	static __init__ = function() {}
	static __cleanup__ = function() {}
	static __clone__ = function() {
		var _clone = dunder.init(self.__type__())
		var _keys = variable_struct_get_names(self);
		var _len = variable_struct_names_count(self);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			_clone[$ _key] = self[$ _key];
		}
		return _clone;
	}
	
	// Representation methods
	static __string__ = function() {
		return json_stringify(self);
	}
	static __repr__ = function() {
		return 	"<dunder '"+instanceof(self)+"'>";
	}
	static __boolean__ = function() {
		return bool(true);
	}
	// static __number__ = function()
	// static __dict__ = function()
	// static __array__ = function()
	
	
	// Mathematical methods
	//static __add__ = function(_other)
	//static __radd__ = function(_other)
	//static __subtract__ = function(_other)
	//static __rsubtract__ = function(_other)
	//static __multiply__ = function(_other)
	//static __rmultiply__ = function(_other)
	//static __divide__ = function(_other)
	//static __rdivide__ = function(_other)
	//static __equals__ = function(_other);
	
	// Structure methods
	//static __len__ = function()
	//static __contains__ = function(_value)
	//static __getitem__ = function(_index)
	//static __setitem__ = function(_index, _value)
	//static __hasitem__ = function(_index)
	//static __removeitem__ = function(_index)
	//static __getattr__ = function(_key)
	//static __setattr__ = function(_key, _value)
	//static __hasattr__ = function(_key)
	//static __removeattr__ = function(_key)
	
	// Iteration methods
	// static __iter__ = function()
	// static __next__ = function()
	
	// Type checking methods
	static __type__ = function() {
		return __bases__[0];
	}
	static __type_name__ = function() {
		return script_get_name(__bases__[0]);
	}
	static __is_subtype__ = function(_type) {
		// checks if this constructor is in my ancestors
		var _len = array_length(__bases__);
		for (var _i=0; _i<_len; _i++) {
			if (__bases__[_i] == _type) {
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
		if (not is_struct(_other)) return false;
		
		dunder.__throw_if_not_struct_with_method(_other, "__type__");
		return __type__() == _other.__type__();
	}
}