function ast_node(_node, _ctx, _scope, _depth) {
	
	var _children_value = _node[$ "children"];
	var _children = _children_value ?? [];
	var _len = array_length(_children);

	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_node", {line: _node.loc[0], depth: _depth})
		_logger.debug("Executing", {len: _len});
	}

	for (var _i=0; _i < _len; _i++) {
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Child", {idx: _i});
		}
			
		var _child = _children[_i];
		var _ast_node = asset_get_index(_child.type)
		var _retval = _ast_node(_child, _ctx, _scope, _depth+1);
		
		if (_ctx.is_breaking or _ctx.is_continuing or _ctx.is_returning) {
			return;	
		}
	}
}
