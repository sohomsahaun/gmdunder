//function Env() constructor {
//	// environment loader
//	loaded_envs = {}
	
//	get_env = function(_name, _default="") {
//		if (variable_struct_exists(loaded_envs, _name)) {
//			return loaded_envs[$ _name];	
//		}
//		var _retval = environment_get_variable(_name);
//		if (_retval == "") {
//			return _default;	
//		}
//		return _retval
//	}
	
//	get_number = function(_name, _default=0) {
//		var _retval = get_env(_name);
//		if (_retval == "") {
//			return _default;	
//		}
//		return real(_retval);
//	}
	
//	get_bool = function(_name, _default=false) {
//		var _retval = get_env(_name);
//		if (_retval == "") {
//			return _default;	
//		}
//		return string_lower(_retval)== "true";
//	}
	
//	get_json = function(_name, _default={}) {
//		var _retval = get_env(_name);
//		if (_retval == "") {
//			return _default;
//		}
//		return json_parse(_retval);
//	}
	
//	get_path = function(_name, _default="") {
//		var _retval = get_env(_name, _default);
//		return new Path(_retval);
//	}
	
//	load_env = function(_env_file) {
//		// Loads a .env file
		
//		var _fp = file_text_open_read(_env_file);
//		if (_fp < 0) {
//			show_debug_message("Env: Could not read env file " + _env_file);
//			return;
//		}
		
//		while(not file_text_eof(_fp)) {
//			var _line = file_text_readln(_fp);
//			var _pos = string_pos("=", _line);
//			if (_pos > 0) {
//				var _env_name = __trim(string_copy(_line, 1, _pos-1));
//				var _env_value = __rtrim(string_delete(_line, 1, _pos));
//				show_debug_message("Env: Loaded " + _env_name + "=" + _env_value);
//				loaded_envs[$ _env_name] = _env_value;
//			}
//		}
//		file_text_close(_fp);
//	}

//    get_project_dir = function() {
//        var _build_win = parameter_string(2);
//    	if (parameter_count() == 3 and parameter_string(1) == "-game" and _build_win != "") {
//    		// find path of the build.bff file
//    		var _path = new Path(_build_win).up().up();
//    		var _build = _path.join("build.bff");
//    		if (not _build.is_file()) {
//    			show_debug_message("ENV: could not find build.bff");
//    			return new NullPath();
//    		}
	
//    		// get project dir
//    		var _struct = json_parse_from_file(_build.to_string());
//    		var _project_dir = new Path(_struct[$ "projectDir"]);
//    		if (_project_dir.is_dir()) {
//                return _project_dir;
//    		}
//    	}

//        return new NullPath();
//    }
    
//    get_project_dir_as_string = function() {
//        return get_project_dir().to_string();
//    }

//	__is_whitespace = function(_char) {
//		return _char == " " or _char == "\t" or _char == "\r" or _char == "\n";
//	}

//	__ltrim = function(_string) {
//		var _len = string_length(_string);
//		for (var _i=0; _i<_len; _i++) {
//			if (not __is_whitespace(string_char_at(_string, _i+1))) {
//				break;
//			}
//		}
//		return string_delete(_string, 1, _i);
//	};
	
//	__rtrim = function(_string) {
//		var _len = string_length(_string);
//		for (var _i=_len-1; _i>=0; _i--) {
//			if (not __is_whitespace(string_char_at(_string, _i+1))) {
//				break;
//			}
//		}
//		return string_copy(_string, 1, _i+1);
//	}
	
//	__trim = function(_string) {
//		return __rtrim(__ltrim(_string));
//	}
	
//	// Initialize: try to load local dotenv
//    var _project_dir = get_project_dir();
//    if (_project_dir.is_dir()) {
//        var _dotenv_filename = _project_dir.join(".env").to_string();
//		load_env(_dotenv_filename);
//    }
//}