function ast_struct_literal(_node, _ctx, _scope, _depth) {
	var _len = array_length(_node.values)
	
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_struct_literal", {line: _node.loc[0], depth: _depth})
		_logger.debug("Creating", {len: _len});
	}
	
	var _struct = {};
	
	for (var _i=0; _i < _len; _i++) {
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Element", {idx: _i});
		}
			
		var _child = _node.values[_i];
		var _key = _child[0];
		var _value = _child[1];
		var _ast_node = asset_get_index(_value.type)
		_struct[$ _key] = _ast_node(_value, _ctx, _scope, _depth+1);
	}
	
	return _struct;
}