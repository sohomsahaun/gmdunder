function ast_switch(_node, _ctx, _scope, _depth) {
	var _len = array_length(_node.node.children);
	
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_switch", {line: _node.loc[0], depth: _depth})
		_logger.debug("Switch", {len: _len});
	}

	var _ast_node = asset_get_index(_node.value.type)
	var _value = _ast_node(_node.value, _ctx, _scope, _depth+1);
	
	if (_node.node.type != "ast_node") {
		var _ast_node = asset_get_index(_child.type)
		_ast_node(_child, _ctx, _scope, _depth+1);
	}
	
	// find the right jump target
	var _default_index = undefined;
	var _jump_index = undefined;
	
	for (var _i=0; _i < _len; _i++) {
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Scan", {idx: _i});
		}

		var _child = _node.node.children[_i];
		if (_child.type == "ast_label") {
			if (_child.label == _value) {
				_jump_index = _i;
				break;
			}
			if (not is_undefined(_child.label) and not is_ptr(_child.label)) {
				_default_index = _i;	
			}
		}
	}
	
	if (not is_undefined(_jump_index)) {
		var _i = _jump_index;
	}
	else if (not is_undefined(_default_index)) {
		var _i = _default_index;	
	}
	else {
		return;	
	}
	
	for (; _i < _len; _i++) {
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Child", {idx: _i});
		}
			
		var _child = _node.node.children[_i];
		var _ast_node = asset_get_index(_child.type)
		_ast_node(_child, _ctx, _scope, _depth+1);
		
		if (_ctx.is_breaking) {
			_ctx.is_breaking = false;
			return;
		}
		if (_ctx.is_continuing or _ctx.is_returning) {
			return;
		}
	}
}
