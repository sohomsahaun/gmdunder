function ast_assignment(_node, _ctx, _scope, _depth) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_assignment", {line: _node.loc[0], depth: _depth})
		_logger.debug("Executing");
	}
		
	// get value
	var _ast_node = asset_get_index(_node.value.type);
	var _value = _ast_node(_node.value, _ctx, _scope, _depth+1);
	if (not is_undefined(_ctx.logger)) {
		_logger.debug("Got assignment value", {value: _value});
	}
	
	// get target, and make assignment
	var _ast_node = asset_get_index(_node.target.type);
	var _target_ref = _ast_node(_node.target, _ctx, _scope, _depth+1, _node.op, _value);
}
