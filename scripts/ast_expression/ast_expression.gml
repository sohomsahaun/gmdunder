function ast_expression(_node, _ctx, _scope, _depth) {
	var _ops_len = array_length(_node.ops);
	
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_expression", {line: _node.loc[0], depth: _depth})
		_logger.debug("Evaluating", {ops_len: _ops_len});
	}
	
	var _ast_node = asset_get_index(_node.value.type)
	var _value = _ast_node(_node.value, _ctx, _scope, _depth+1);
	
	for (var _i=0; _i < _ops_len; _i++) {
		var _op_child_pair = _node.ops[_i];
		var _op = _op_child_pair[0];
		var _child = _op_child_pair[1];
		
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Op", {op: _op});
		}
		
		var _ast_node = asset_get_index(_child.type)
		var _child_value = _ast_node(_child, _ctx, _scope, _depth+1);
		
		switch(_op) {
			case "*": _value *= _child_value; break;
			case "/": _value /= _child_value; break;
			case "%": _value %= _child_value; break;
			case "+": _value += _child_value; break;
			case "-": _value -= _child_value; break;
			case "<<": _value = _value << _child_value; break;
			case ">>": _value = _value >> _child_value; break;
			case "<=": _value = _value <= _child_value; break;
			case ">=": _value = _value >= _child_value; break;
			case "<": _value = _value < _child_value; break;
			case ">": _value = _value > _child_value; break;
			case "==": _value = _value == _child_value; break;
			case "!=": _value = _value != _child_value; break;
			case "&": _value = _value & _child_value; break;
			case "^": _value = _value ^ _child_value; break;
			case "|": _value = _value | _child_value; break;
			case "&&": _value = _value && _child_value; break;
			case "||": _value = _value || _child_value; break;
			default: throw "Unrecognized op in expression: " + string(_op);
		}
	}
	
	return _value;
}