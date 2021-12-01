function ast_repeat(_node, _ctx, _scope, _depth) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_repeat", {line: _node.loc[0], depth: _depth})
		_logger.debug("Executing");
	}
	
	// Amount
	var _ast_node = asset_get_index(_node.value.type)
	var _value = _ast_node(_node.value, _ctx, _scope, _depth+1);
	_logger.debug("Loop amount", {value: _value});
	
	repeat(_value) {
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
	}
	
	return;
}