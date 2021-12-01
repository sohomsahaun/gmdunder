function ast_constant(_node, _ctx, _scope, _depth) {
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_constant", {line: _node.loc[0], depth: _depth})
		_logger.debug("Constant", {value: _node.value});
	}
	
	return _node.value;
}