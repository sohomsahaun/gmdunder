function ast_special(_node, _ctx, _scope, _depth) {
	var _args_len = array_length(_node.args);
	
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_special", {line: _node.loc[0], depth: _depth})
		_logger.debug("Executing", {ident: _node.ident, args_len: _args_len});
	}
	
	// check if special is available
	if (not variable_struct_exists(_ctx.specials, _node.ident)) {
		throw "No special found";
	}

	// Args
	var _args = array_create(_args_len);
	for (var _i=0; _i < _args_len; _i++) {
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Arg", {idx: _i});
		}
			
		var _child = _node.args[_i];
		var _ast_node = asset_get_index(_child.type)
		_args[_i] = _ast_node(_child, _ctx, _scope, _depth+1);
	}
	
	if (not is_undefined(_ctx.logger)) {
		_logger.debug("Got args", {args: _args});
	}
	
	// fetch special
	var _special = _ctx.specials[$ _node.ident];
	
	with (method_get_self(_special)) {
		return script_execute_ext(method_get_index(_special), _args);
	}
}