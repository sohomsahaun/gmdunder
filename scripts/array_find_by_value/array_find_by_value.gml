function array_find_by_value(_array, _value) {
	var _len = array_length(_array);
	for (var _i=0; _i<_len; _i++) {
		if (_array[_i] == _value) {
			return _i;
		}
	}
	return -1;
}