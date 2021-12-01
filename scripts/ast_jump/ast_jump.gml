function ast_jump(_node, _ctx, _scope, _depth) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_jump", {line: _node.loc[0], depth: _depth})
		_logger.debug("Jumping", {op: _node.op});
	}
	
	switch (_node.op) {
		case "break":
			_ctx.is_breaking = true;
			return;
		case "return":
			var _ast_node = asset_get_index(_node.value.type)
			var _value = _ast_node(_node.value, _ctx, _scope, _depth+1);
			_ctx.return_value = _value;
			_ctx.is_returning = true;
			return;
		case "continue":
			_ctx.is_continuing = true;
			return;
	}
}