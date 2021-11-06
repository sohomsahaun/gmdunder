function foreach(_iterable, _binding=undefined, _callback){
	if (is_undefined(_binding)) {
		var _func = _callback;	
	}
	else {
		var _func = method(_binding, _callback);	
	}
	
	if (is_array(_iterable)) {
		var _len = array_length(_iterable);
		
		for (var _i=0; _i<_len; _i++) {
			_func(_i, _iterable[_i]);
		}
	}
	else if (is_struct(_iterable)) {
		var _keys = variable_struct_get_names(_iterable);
		var _len = array_length(_keys);
		
		for (var _i=0; _i<_len; _i++) {
			var _key = _keys[_i];
			_func(_key, _iterable[$ _key]);
		};
	}
	else if (is_string(_iterable)) {
		var _len = string_length(_iterable);
		for (var _i=0; _i<_len; _i++) {
			_func(_i, string_char_at(_iterable, _i+1));
		};
	}
}