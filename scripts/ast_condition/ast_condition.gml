function ast_condition(_node, _ctx, _scope, _depth) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_condition", {line: _node.loc[0], depth: _depth})
		_logger.debug("Executing");
	}
	
	// Evaluate expression
	var _ast_node = asset_get_index(_node.cond.type)
	var _cond = _ast_node(_node.cond, _ctx, _scope, _depth+1);
	_logger.debug("Result value", {cond: _cond});
	
	if (_cond) {
		var _ast_node = asset_get_index(_node.trueNode.type)
		return _ast_node(_node.trueNode, _ctx, _scope, _depth+1);
	}
	else if (is_struct(_node.falseNode)) {
		var _ast_node = asset_get_index(_node.falseNode.type)
		return _ast_node(_node.falseNode, _ctx, _scope, _depth+1);
	}
	
	return;
}