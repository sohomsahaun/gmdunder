function ast_variable_chain(_node, _ctx, _scope, _depth, _op, _value, _pre) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_variable_chain", {line: _node.loc[0], depth: _depth})
		_logger.debug("Assignment", {op: _op, value: _value});
	}
	
	// resolve parent scope
	var _parent_len = array_length(_node.parents);
	for (var _i = 0; _i<_parent_len; _i++) {		
		var _parent = _node.parents[_i];
		
		if (_parent.ident == "global" and _i == 0) {
			_scope = global;
		}
		else {
			var _ast_node = asset_get_index(_parent.type);
			_scope = _ast_node(_parent, _ctx, _scope, _depth+1);
		}
	}
	
	// resolve variable
	var _ast_node = asset_get_index(_node.target.type);
	return _ast_node(_node.target, _ctx, _scope, _depth+1, _op, _value, _pre);
}