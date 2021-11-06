function struct_update(_from, _to, _exclude_privates=false){
	// shallow copy of struct
	var _keys = variable_struct_get_names(_from);
	var _len = array_length(_keys);
	for (var _i=0; _i<_len; _i++) {
		var _key = _keys[_i];
		if (_exclude_privates and string_pos("__", _key) == 1) {
			continue;
		}
		
		_to[$ _key] = _from[$ _key];
	}
}