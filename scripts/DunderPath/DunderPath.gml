//function Path(_string_path = undefined) constructor {
//	__dirs = []
	
//	has_path = function() {
//		return array_length(__dirs) > 0;	
//	}
	
//	exists = function() {
//		return is_file() or is_dir();
//	}
	
//	is_file = function() {
//		if (has_path()) {
//			return file_exists(to_string());
//		}
//		return false;
//	}
	
//	is_dir = function() {
//		if (has_path()) {
//			return directory_exists(to_string());
//		}
//		return false;
//	}
	
//	get_directory_array = function() {
//		return __dirs;
//	}
	
//	from_string = function(_string) {
//		__dirs = [];
//		var _fn = string_replace_all(_string, "\\", "/");
	
//		do {
//			// slashes
//			var _pos = string_pos("/", _fn);
//			if (_pos > 0) {
//				array_push(__dirs, string_copy(_fn, 1, _pos-1));
//				_fn = string_delete(_fn, 1, _pos);
//			} else {
//				array_push(__dirs, _fn);
//				_fn = "";
//			}
//		} until (string_length(_fn) == 0);
		
//		return self;
//	}
	
//	to_string = function(_separator = "/") {
//		var _str = "";
//		var _len = array_length(__dirs);
//		for (var _i=0; _i<_len; _i++) {
//			_str += __dirs[_i];
//			if (_i < _len-1) {
//				_str += _separator;
//			}
//		}
//		return _str;
//	}
	
//	get_parent = function() {
//		// return new Path with parent
//		if (array_length(__dirs) == 0) {
//			throw "Cannot go up"
//		}
		
//		var _parent = new Path();
//		array_copy(_parent.__dirs, 0, __dirs, 0, array_length(__dirs) - 1);
//		return _parent;
//	}
	
//	get_joined = function(_name) {
//		// return new Path with child
//		var _joined = new Path();
//		array_copy(_joined.__dirs, 0, __dirs, 0, array_length(__dirs));
//		return _joined.join(_name);
//	}
	
//	join = function(_name) {
//		// join in place
//		array_push(__dirs, _name);
//		return self;
//	}
	
//	up = function() {
//		// go up one, in place
//		if (array_length(__dirs) == 0) {
//			throw "Cannot go up"
//		}
		
//		array_pop(__dirs);
//		return self;
//	}
	
//	// initialize
//	if (not is_undefined(_string_path)) {
//		from_string(_string_path);
//	}
//}