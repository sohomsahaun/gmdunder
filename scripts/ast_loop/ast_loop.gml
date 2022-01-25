function ast_loop(_node, _ctx, _scope, _depth) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_loop", {line: _node.loc[0], depth: _depth})
		_logger.debug("Executing");
	}
	
	// Initialize
	if (is_struct(_node.init)) {
		var _ast_node = asset_get_index(_node.init.type)
		_ast_node(_node.init, _ctx, _scope, _depth+1);
	}
	
	while (true) {
		// evaluate
		var _ast_node = asset_get_index(_node.cond.type)
		var _cond = _ast_node(_node.cond, _ctx, _scope, _depth+1);
		if (not _cond) break;
	
		var _ast_node = asset_get_index(_node.node.type)
		_ast_node(_node.node, _ctx, _scope, _depth+1);
		
		if (_ctx.is_breaking) {
			_ctx.is_breaking = false;
			return;
		}
		if (_ctx.is_continuing) {
			_ctx.is_continuing = false;	
		}
		if (_ctx.is_returning) {
			return;	
		}

		if (is_struct(_node.post)) {
			var _ast_node = asset_get_index(_node.post.type)
			_ast_node(_node.post, _ctx, _scope, _depth+1);
		}
	}

	return;
}