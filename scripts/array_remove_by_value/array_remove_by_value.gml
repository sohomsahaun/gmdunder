function array_remove_by_value(_array, _value) {
	var _idx = array_find_by_value(_array, _value)
	if (_idx != -1) {
		array_delete(_array, _idx, 1);	
	}
	return _idx;
}