function DunderEnv() : DunderDict() constructor {
	// Manages environmental variables
	__bases_add__(DunderEnv);
	
	static __init__ = function() {
		// Initialize: try to load local dotenv
		values = {}
		
	    var _project_dir = __get_project_dir();
	    if (_project_dir.is_dir()) {
			load_env_from_file(_project_dir.join(".env"));
	    }
	}

	// Env functions
	static load_env_from_file = function(_input) {
		var _path = __dunder__.as_string(_input);
		if (not file_exists(_path)) {
			throw __dunder__.init(DunderExceptionFileError, "Can't load file "+_path);
		}
		
		var _file = __dunder__.init(DunderFile, _path);
		foreach(_file, method(self, function(_line) {
			var _parts = _line.split("=", 1);
			if (array_length(_parts) == 2) {
				var _key_string = __dunder__.init(DunderString, _parts[0])
				var _value_string = __dunder__.init(DunderString, _parts[1]);
				
				var _key = _key_string.trim()
				var _value = _value_string.rtrim()
				
				show_debug_message("Env: Loaded " + _key + "=" + _value);
				self.set(_key, _value)
				
				delete _key_string;
				delete _value_string;
			}
		}));
	}
	
    static __get_project_dir = function() {
		// hack to try to get project directory
        var _build_win = parameter_string(2);
    	if (parameter_count() == 3 and parameter_string(1) == "-game" and _build_win != "") {
    		// find path of the build.bff file
    		var _path = __dunder__.init(DunderPath, _build_win).up().up();
    		var _build = _path.join("build.bff");
    		if (_build.is_file()) {
	    		var _struct = __dunder__.init(DunderDict).from_file(_build);
	    		var _project_dir = __dunder__.init(DunderPath, _struct.get("projectDir", ""));
	    		if (_project_dir.is_dir()) {
	                return _project_dir;
	    		}
    		}
			else {
    			show_debug_message("ENV: could not find build.bff");
			}	
    	}

    	return __dunder__.init(DunderPath);
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
		return __dunder__.init(DunderPath, _retval);
	}
}