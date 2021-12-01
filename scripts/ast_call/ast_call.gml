function ast_call(_node, _ctx, _scope, _depth) {
	var _args_len = array_length(_node.args);
	
	if (not is_undefined(_ctx.logger)) {
		var _logger = _ctx.logger.bind_named("ast_call", {line: _node.loc[0], depth: _depth})
		_logger.debug("Executing", {args_len: _args_len});
	}
	
	// Target
	var _ast_node = asset_get_index(_node.target.type)
	var _func = _ast_node(_node.target, _ctx, _scope, _depth+1);
	
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
		_logger.debug("Calling with args", {func: _func, args: _args});
	}
	
	if (is_undefined(_func)) {	
		// If scope has no value, try a script
		if (_node.target.type == "ast_variable" and asset_get_type(_node.target.ident) == asset_script) {
			var _func = asset_get_index(_node.target.ident);
			with (_scope) {
				return script_execute_ext(_func, _args);	
			}
		}
		
		// Otherwise try a builtin
		var _func = ast_builtins(_node.target.ident);
		if (not is_undefined(_func)) {
			with (_scope) {
				// we're doing this pyramid of doom because gamemaker strugles to string_execute_ext for builtins
				switch(_args_len) {
					case  0: return _func();
					case  1: return _func(_args[0]);
					case  2: return _func(_args[0], _args[1]);
					case  3: return _func(_args[0], _args[1], _args[2]);
					case  4: return _func(_args[0], _args[1], _args[2], _args[3]);
					case  5: return _func(_args[0], _args[1], _args[2], _args[3], _args[4]);
					case  6: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5]);
					case  7: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6]);
					case  8: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7]);
					case  9: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8]);
					case 10: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9]);
					case 11: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10]);
					case 12: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11]);
					case 13: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12]);
					case 14: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13]);
					case 15: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14]);
					case 16: return _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14], _args[15]);
					default: throw "Can't accept more than 16 _argss";
				}
			}
		}
		
		throw "No function found";	
	}
	else {
		with (method_get_self(_func)) {
		  return script_execute_ext(method_get_index(_func), _args);
		}
	}
}