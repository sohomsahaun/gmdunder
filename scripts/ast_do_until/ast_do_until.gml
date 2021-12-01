function ast_do_until(_node, _ctx, _scope, _depth) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_do_until", {line: _node.loc[0], depth: _depth})
		_logger.debug("Executing");
	}

	while (true) {
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
		
		// evaluate until
		var _ast_node = asset_get_index(_node.cond.type)
		var _cond = _ast_node(_node.cond, _ctx, _scope, _depth+1);
		if (_cond) break;
	}

	return;
}