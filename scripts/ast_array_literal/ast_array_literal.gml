function ast_array_literal(_node, _ctx, _scope, _depth) {
	var _len = array_length(_node.values)
	
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_array_literal", {line: _node.loc[0], depth: _depth})
		_logger.debug("Creating", {len: _len});
	}
	
	var _array = array_create(_len);
	
	for (var _i=0; _i < _len; _i++) {
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Element", {idx: _i});
		}
			
		var _child = _node.values[_i];
		var _ast_node = asset_get_index(_child.type)
		_array[_i] = _ast_node(_child, _ctx, _scope, _depth+1);
	}
	
	return _array;
}