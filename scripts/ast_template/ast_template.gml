function ast_template(_node, _ctx, _scope, _depth) {
	var _children_len = array_length(_node.children);
	
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_template", {line: _node.loc[0], depth: _depth})
		_logger.debug("Evaluating", {children_len: _children_len});
	}
	
	var _str = "";
	for (var _i=0; _i < _children_len; _i++) {
		var _child = _node.children[_i];
		var _ast_node = asset_get_index(_child.type)
		var _val = _ast_node(_child, _ctx, _scope, _depth+1);
		_str += string(_val);
	}
	
	return _str;
}