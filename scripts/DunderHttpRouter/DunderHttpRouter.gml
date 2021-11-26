function DunderHttpRouter() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderHttpRouter);
	// A router for Http server, deals with parsing paths and running callbacks
	
	static __init__ = function(_logger) {
		handlers = dunder.init_list();
		logger = _logger;
	}
	
	static add_path = function(_pattern_string, _callback) {
		var _pattern = dunder.init_string(_pattern_string)
		// trim first "/"
		if (_pattern.get(0) == "/") {
			_pattern.replace_in_place("/", "");
		}
		
		// validate paths
		var _parts = _pattern.split("/");
		
		dunder.foreach(_parts, function(_part) {
			var _left = _part.count("{");
			var _right = _part.count("}");
			var _stars = _part.count("*");
			
			if (_left != _right or _left > 1 or _right > 1 or _stars > 1) {
				throw dunder.init(DunderExceptionValueError, "Path part format incorrect '"+string(_part)+"'");
			}
			
			if (_stars == 1 and not _part.equals("*")) {
				throw dunder.init(DunderExceptionValueError, "Path part must be exactly a wildard '*' if at all: '"+string(_part)+"'");
			}
		});
		
		handlers.append({
			pattern_parts: _parts,
			callback: _callback
		});
	}
	
	static run_handler_for_path = function(_request, _response) {
		var _len = handlers.len();
		for (var _i=0; _i<_len; _i++) {
			var _handler = handlers.get(_i);
			
			var _params_or_false = path_match(_handler.pattern_parts, _request.path);
			if (_params_or_false != false) {
				_request.parameters = _params_or_false;
				_handler.callback(_request, _response, logger);
				return;
			}
		}
		
		default_not_found_handler(_request, _response);
	}

	
	static path_match = function(_pattern_parts, _raw_path) {
		var _raw_path_string = dunder.init_string(_raw_path);
		
		if (_raw_path_string.contains("?")) {
			var _pos = _raw_path_string.pos("?");
			var _path_params_string = _raw_path_string.copy(_pos+1, _raw_path_string.len() - _pos);
			var _path_string = _raw_path_string.copy(0, _pos);
		}
		else {
			var _path_params_string = dunder.init_string();
			var _path_string = _raw_path_string;
		}
		
		
		if (_path_string.get(0) == "/") { // trim first "/"
			_path_string.replace_in_place("/", "");
		}
		
		var _param_struct = {}
		var _paths = _path_string.split("/");
		var _paths_len = _paths.len();
		
		var _patterns_len = _pattern_parts.len()
		if (_paths_len < _patterns_len) return false; // path can't be smaller than pattern
		if (_paths_len > _patterns_len and not _pattern_parts.get(-1).equals("*")) return false; // if path is longer, pattern can't not end in wildcard
		
		for (var _i=0; _i<_patterns_len; _i++) {
			var _pattern = _pattern_parts.get(_i);
			
			// check for wildcard
			if (_pattern.equals("*")) {
				_param_struct[$ "*"] = _paths.slice(_i, undefined).join("/").as_string();
				return _param_struct;
			}
			
			// check for exact match
			var _path = _paths.get(_i);
			var _before_pos = _pattern.pos("{");
			if (_before_pos == -1 and _pattern.equals(_path)) {
				continue;
			}
			
			// Match part before {
			if (_before_pos > 0) {
				if (not _path.copy(0, _before_pos).equals(_pattern.copy(0, _before_pos))) {
					return false;
				}
			}
			
			// Match part after }
			var _path_len = _path.len();
			var _after_pos = _pattern.pos("}");
			var _after_len = _pattern.len()-1 - _after_pos;
			if (_after_len > 0) {
				if (not _path.copy(_path_len-_after_len, _after_len).equals(_pattern.copy(_after_pos, _after_len))) {
					return false;
				}
			}
			
			// it's a match! extract the param
			var _param_name = _pattern.copy(_before_pos+1, _after_pos-_before_pos-1);
			var _match = _path.copy(_before_pos, _path_len-_after_len-_before_pos);
			
			_param_struct[$ _param_name.as_string()] = _match.as_string();
		}
		
		// decode path params
		if (_path_params_string.len() > 0) {
			var _path_params = _path_params_string.split("&");
			var _path_params_len = _path_params.len();
			for (var _i=0; _i<_path_params_len; _i++) {
				var _path_params_pair = _path_params.get(_i).split("=");
				var _key = _path_params_pair.get(0).as_string();
				
				if (string_length(_key) > 0) {
					var _value = _path_params_pair.get(1).as_string();
					
					if (variable_struct_exists(_param_struct, _key)) {
						if (not is_array(_param_struct[$ _key])) {
							_param_struct[$ _key] = [ _param_struct[$ _key] ];	
						}
						
						array_push(_param_struct[$ _key], _value);
					}
					else {
						_param_struct[$ _key] = _value;	
					}
				}
			}
		}
		return _param_struct;
	}
	
	static default_not_found_handler = function(_req, _res) {
		_res.set_status(404).send_string("Not Found");	
	}
}
