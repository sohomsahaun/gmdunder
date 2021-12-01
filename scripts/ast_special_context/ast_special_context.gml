function ast_special_context(_node, _ctx, _scope, _depth) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_special_context", {line: _node.loc[0], depth: _depth})
		_logger.debug("Entering");
	}
	
	// run context start
	var _ast_node = asset_get_index(_node.special.type)
	var _close = _ast_node(_node.special, _ctx, _scope, _depth+1);
	
	// Run remaining nodes
	var _ast_node = asset_get_index(_node.node.type)
	var _retval = _ast_node(_node.node, _ctx, _scope, _depth+1);

	// run context close
	if (is_method(_close)) {
		with (method_get_self(_close)) {
			script_execute(method_get_index(_close));
		}
	}
	
	
	return _retval;
}