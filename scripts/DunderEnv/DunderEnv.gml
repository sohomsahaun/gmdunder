function DunderEnv() : DunderDict() constructor { REGISTER_SUBTYPE(DunderEnv);
	// Manages environmental variables
	
	static __init__ = function(_logger=undefined) {
		__values = {}
		logger = dunder.bind_named_logger("Env");
		
		try {
		    var _project_dir = get_project_dir();
			load_env_from_file(_project_dir.join(".env"));
		}
		catch (_err) {
			if (not dunder.is_subtype(_err, DunderExceptionFileError) and not dunder.is_subtype(_err, DunderExceptionValueError)) {
				dunder.rethrow(_err);
			}
		}
	}

	// Env functions
	static load_env_from_file = function(_path) {
		var _file = dunder.init(DunderFile, _path);
		dunder.foreach(_file, method(self, function(_line) {
			var _parts = _line.split("=", 1);
			
			if (_parts.len() == 2) {
				var _key = _parts.get(0).trim().as_string();
				var _value = _parts.get(1).rtrim().as_string();
				
				logger.debug("Found env", {key:_key, value:_value});
				set(_key, _value)
			}
		}));
	}
	
    static get_project_dir = function() {
		// hack to try to get project directory
		if (code_is_compiled()) {
			var _game_location = parameter_string(0);	
		}
		else if (parameter_count() == 3 and parameter_string(1) == "-game") {
			var _game_location = parameter_string(2);
		}
		else {
			var _game_location = "";	
		}
		
    	if (_game_location != "") {
    		// find path of the build.bff file
    		var _path = dunder.init(DunderPath, _game_location).up().up();
    		var _build = _path.join("build.bff");
    		if (_build.is_file()) {
	    		var _struct = dunder.init_dict().from_file(_build);
	    		var _project_dir = dunder.init(DunderPath, _struct.get("projectDir", ""));
	    		if (_project_dir.is_dir()) {
	                return _project_dir;
	    		}
    		}
			else {
				logger.debug("No build.bff found, not using local .env");
			}	
    	}

    	return dunder.init(DunderPath);
    }
	
	static get_env = function(_name, _default="") {
		if (has(_name)) {
			return get(_name);
		}
		var _retval = environment_get_variable(_name);
		if (_retval == "") {
			return _default;	
		}
		return _retval
	}
	
	static get_number = function(_name, _default=0) {
		var _retval = get_env(_name);
		if (_retval == "") {
			return _default;	
		}
		return real(_retval);
	}
	
	static get_boolean = function(_name, _default=false) {
		var _retval = get_env(_name);
		if (_retval == "") {
			return _default;	
		}
		return string_lower(_retval)== "true";
	}
	
	static get_json = function(_name, _default=undefined) {
		var _retval = get_env(_name);
		if (_retval == "") {
			return _default;
		}
		return json_parse(_retval);
	}
	
	static get_path = function(_name, _default="") {
		var _retval = get_env(_name, _default);
		return dunder.init(DunderPath, _retval);
	}
}