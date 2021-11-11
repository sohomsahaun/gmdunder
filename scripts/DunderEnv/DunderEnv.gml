function DunderEnv() : DunderDict() constructor { REGISTER_SUBTYPE(DunderEnv);
	// Manages environmental variables
	
	static __init__ = function(_logger=undefined) {
		__values = {}
		logger = __get_shared_logger__().bind_named("Env");
		
		try {
		    var _project_dir = get_project_dir();
			load_env_from_file(_project_dir.join(".env"));
		}
		catch (_err) {
			if (not dunder.is_subtype(_err, DunderExceptionFileError)) {
				throw dunder.exception(_err);
			}
		}
	}

	// Env functions
	static load_env_from_file = function(_path) {
		var _file = dunder.init(DunderFile, _path);
		dunder.foreach(_file, method(self, function(_line) {
			var _parts = _line.split("=", 1);
			
			if (_parts.len() == 2) {
				var _key = dunder.as_string(_parts.get(0).trim());
				var _value = dunder.as_string(_parts.get(1).rtrim());
				
				logger.debug("Found env", {key:_key, value:_value});
				set(_key, _value)
			}
		}));
	}
	
    static get_project_dir = function() {
		// hack to try to get project directory
        var _build_win = parameter_string(2);
    	if (parameter_count() == 3 and parameter_string(1) == "-game" and _build_win != "") {
    		// find path of the build.bff file
    		var _path = dunder.init(DunderPath, _build_win).up().up();
    		var _build = _path.join("build.bff");
    		if (_build.is_file()) {
	    		var _struct = dunder.init(DunderDict).from_file(_build);
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