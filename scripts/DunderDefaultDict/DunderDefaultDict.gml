function DunderDefaultDict() : DunderDict() constructor { REGISTER_SUBTYPE(DunderDefaultDict);
	// A dict wrapper
	static __init__ = function(_default_dunder_or_factory, _default_value=undefined) {
		if (script_exists(_default_dunder_or_factory)) { // Note: probably needs better way to check this is a Dunder subtype. Maybe try instantiating?
			default_dunder = _default_dunder_or_factory;
			default_factory = undefined;
		}
		else if (is_method(_default_dunder_or_factory)) {
			default_dunder = undefined;
			default_factory = _default_dunder_or_factory;
		}
		else if (not is_undefined(_default_dunder_or_factory)) {
			throw dunder.init(DunderExceptionTypeError, "Must set default dunder/factory to method or dunder type");
		}
		default_dunder_or_factory = _default_dunder_or_factory;
		default_value = _default_value;

		var _super = __super__(DunderDefaultDict);
		_super();
		
	}	
	static __clone__ = function(_input, _default_value, _default_value_or_factory) {
		if (is_undefined(_input)) {
		return dunder.init(self.__type__(), __struct__(), default_value, default_dunder_or_factory, true);
		}
		return dunder.init(self.__type__(), _input, _default_value, _default_value_or_factory, true);
	}
	
	static __make_default = function() {
		if (not is_undefined(default_dunder)) {
			return dunder.init(default_dunder);
		}
		else if (not is_undefined(default_factory)) {
			return default_factory();
		}
		else {
			return default_value;	
		}
	}

	static __getattr__ = function(_key) {
		if (variable_struct_exists(__values, _key)) {
			return variable_struct_get(__values, _key);
		}
		var _default = __make_default();
		variable_struct_set(__values, _key, _default);
		return _default
	}
	static __hasattr__ = function(_key) {
		return variable_struct_exists(__values, _key);
	}
	static __getattr_no_create = function(_key) {
		if (variable_struct_exists(__values, _key)) {
			return variable_struct_get(__values, _key);
		}
		if (argument_count>1) { // default value
			return argument[1];
		}
		throw dunder.init(DunderExceptionKeyError);
	}
	static __hasattr__ = function(_key) {
		return true;
	}
	static get = __getattr__;
	static has = __hasattr__;
	
	// Iteration methods
	static __iter__ = function() {
		return dunder.init(DunderIterator, method(self, __getattr_no_create), keys());
	}
}