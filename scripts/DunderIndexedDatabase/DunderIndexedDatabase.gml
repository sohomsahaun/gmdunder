function DunderIndexedDatabase() : DunderDict() constructor { REGISTER_SUBTYPE(DunderIndexedDatabase);
	// A dict wrapper with extra indexes
	static __init__ = function(_input_data, _input_indexes, _copy=false) {
		var _super = __super__(DunderIndexedDatabase);
		_super(_input_data, _copy);
		
		__indexes = {};
		
		//if (not is_undefined(_input_indexes)) {
		//	import_indexes(_input_indexes);	
		//}
		//rebuild_index();
	}
	
	static __setattr__ = function(_key, _input) {
		if (not dunder.can_struct(_input)) {
			throw dunder.init(DunderExceptionValueError, "Value must be struct-like");
		}
		
		var _struct = dunder.as_struct(_input);
		
		// update indexes
		var _index_names = variable_struct_get_names(__indexes);
		var _len = variable_struct_names_count(__indexes);
		for (var _i=0; _i<_len; _i++) {
			var _index_name = _index_names[_i];
			if (variable_struct_exists(_struct, _index_name)) {

				// former value		
				if (variable_struct_exists(__values, _key) and variable_struct_exists(__values[$ _key], _index_name)) {
					__indexes[$ _index_name].insert(__values[$ _key][$ _index_name], _key);
				}
				__indexes[$ _index_name].insert(_struct[$ _index_name], _key);
			}
		}
		
		variable_struct_set(__values, _key, _input);
	}
	static __removeattr__ = function(_key) {
		if (variable_struct_exists(__values, _key)) {
			// update indexes
			var _index_names = variable_struct_get_names(__indexes);
			var _len = variable_struct_names_count(__indexes);
			for (var _i=0; _i<_len; _i++) {
				var _index_name = _index_names[_i];
				if (variable_struct_exists(__values[$ _key], _index_name)) {
					__indexes[$ _index_name].remove(__values[$ _key][$ _index_name], _key);
				}
			}
			
			variable_struct_remove(__values, _key);
			
			return true;
		}
		throw dunder.init(DunderExceptionKeyError, "Value doesn't exist");
	}
	static set = __setattr__;
	static remove = __removeattr__;
	
	// Iteration methods
	//static __iter__ = function() {
	//	return dunder.init(DunderIterator, method(self, __getattr_no_create), keys());
	//}
	
	// Indexed Dict methods
	static add_index_numeric = function(_key_name) {
		var _index = new BTree(__compare_numeric);
		__indexes[$ _key_name] = _index;
		
		var _keys = variable_struct_get_names(__values);
		var _len = variable_struct_names_count(__values);
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			var _entry = __values[$ _key];
			if (variable_struct_exists(_entry, _key_name)) {
				_index.insert(_entry[$ _key_name], _key);
			}
		}
	}
	
	static find = function(_search) {
		var _search_fields = variable_struct_get_names(_search);
		var _search_fields_len = variable_struct_names_count(_search);
		
		var _matches = undefined;
		for (var _i=0; _i<_search_fields_len; _i++) {
			var _key_name = _search_fields[_i];
			if (not variable_struct_exists(__indexes, _key_name)) {
				throw dunder.init(DunderExceptionKeyError, "Database doesn't have that index") 	
			}
		
			var _value = _search[$ _key_name];
			var _index = __indexes[$ _key_name];
			var _results = dunder.init(DunderSet, _index.get_key_values(_value));

			if (_i == 0) {
				_matches = _results;
			}
			else {
				_matches = 	_matches.intersection(_results);
			}
			
			if (_matches.len() == 0) {
				break;	
			}
		}
		
		var _keys = _matches.as_array();
		var _len = array_length(_keys);
		
		var _records = {};
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			_records[$ _key] = __values[$ _key];
		}
		return _records;
	}
	
	static __compare_numeric = function(_a, _b) {
		return sign(_a - _b); 
	}
	
	//static export_indexes = function() {
		
	//}
	//static import_indexes = function(_input) {
		
	//}
}