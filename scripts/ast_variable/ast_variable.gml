function ast_variable(_node, _ctx, _scope, _depth, _op, _value, _pre=false) {
	
	if (_scope == global) {
		var _current_value = variable_global_get(_node.ident);
	}
	else {
		var _current_value = variable_struct_get(_scope, _node.ident);
	}
	
	var _subscript_len = array_length(_node.subscripts);
	
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_variable", {line: _node.loc[0], depth: _depth})
		_logger.debug("Resolving Variable", {ident: _node.ident, subscript_len: _subscript_len});
	}
	
	
	for (var _i=0; _i<_subscript_len; _i++) {
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Subscript", {idx: _i});
		}
			
		var _subscript = _node.subscripts[_i];
		
		var _ast_node = asset_get_index(_subscript.value.type);
		var _key = _ast_node(_subscript.value, _ctx, _depth+1);
		
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Resolving Subscript", {accessor: _subscript.accessor, key: _key});
		}
	
		var _sub_parent = _current_value;
		var _sub_key = _key;
		var _sub_accessor = _subscript.accessor;
		switch (_subscript.accessor) {
			case "$": _current_value = _current_value[$ _key]; break;
			case "?": _current_value = _current_value[? _key]; break;
			default:
				_current_value = _current_value[_key];
		}
	}
	
	if (not is_undefined(_ctx.logger)) {
		_logger.debug("Resolved Variable", {value: _current_value});
	}
	
	// setting variable
	var _new_value = _current_value;
	if (not is_undefined(_op)) {
		switch (_op) {
			case "=": _new_value = _value; break;
			case "*=": _new_value = _current_value * _value; break;
			case "/=": _new_value = _current_value / _value; break;
			case "%=": _new_value = _current_value % _value; break;
			case "+=": _new_value = _current_value + _value; break;
			case "-=": _new_value = _current_value - _value; break;
			case "<<=": _new_value =  _current_value << _value; break;
			case ">>=": _new_value =  _current_value >> _value; break;
			case "&=": _new_value = _current_value & _value; break;
			case "^=": _new_value = _current_value ^ _value; break;
			case "|=": _new_value = _current_value | _value; break;
			default: throw "Invalid Op for assignment: " + string(_op);
		}
		
		if (not is_undefined(_ctx.logger)) {
			_logger.debug("Assigning value", {op: "\""+_op+"\"", new_value: _new_value});
		}
		
		if (_subscript_len == 0) {
			if (_scope == global) {
				variable_global_set(_node.ident, _new_value);	
			}
			else {
				variable_struct_set(_scope, _node.ident, _new_value);
			}
		}
		else {
			switch (_sub_accessor) {
				case "$": _sub_parent[$ _sub_key] = _new_value; break;
				case "?": _sub_parent[? _sub_key] = _new_value; break;
				default:
					_sub_parent[@ _sub_key] = _new_value;
			}
		}
	}
	
	if (_pre) {
		return _new_value;
	}
	return _current_value;
}