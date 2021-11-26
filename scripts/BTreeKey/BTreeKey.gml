function BTreeKey(_key) constructor {
	key = _key;
	__values = {};
	
	static has = function(_value) {
		return variable_struct_exists(__values, _value);	
	}
	static set = function(_value) {
		variable_struct_set(__values, _value, true);
	}
	static remove = function(_value) {
		variable_struct_remove(__values, _value);
	}
	static length = function() {
		return variable_struct_names_count(__values);	
	}
	static values = function() {
		return variable_struct_get_names(__values);	
	}
}