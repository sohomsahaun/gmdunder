function ast_increment(_node, _ctx, _scope, _depth) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_increment", {line: _node.loc[0], depth: _depth})
		_logger.debug("Executing", {op: _node.op, pre: _node.pre});
	}
	
	// get target, and make assignment
	var _ast_node = asset_get_index(_node.target.type);
	return _ast_node(_node.target, _ctx, _scope, _depth+1, "+=", (_node.op == "--" ? -1 : 1), _node.pre);
}
