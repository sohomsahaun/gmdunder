function DunderPath() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderPath);
	// A path manager
	static separator = "/";
	
	static __init__ = function(_input) {
		if (__dunder__.can_array(_input)) {
			path_parts = __dunder__.init(DunderList, __dunder__.as_array(_input))
		}
		else if (__dunder__.can_string(_input)) {
			var _string = __dunder__.as_string(_input);
			path_parts = __dunder__.init(DunderList);
			join(_string);
		}
		else if (is_undefined(_input)) {
			path_parts = __dunder__.init(DunderList);
		}
		else {
			throw __dunder__.init(DunderExceptionTypeError, "Can't coerse type "+typeof(_struct)+" to "+__type_name__);
		}
	}
	static __clone__ = function(_input=undefined) {
		if (is_undefined(_input)) {
			return __dunder__.init(self.__type__(), path_parts);
		}
		return __dunder__.init(self.__type__(), _input);
	}
	
	// Representation methods
	static __string__ = function() {
		return path_parts.join(separator);
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" path='"+path_parts.__string__()+"'>";
	}
	static __boolean__ = function() {
		return path_parts.__bool__();	
	}
	static __array__ = function() {
		return path_parts.__array__();
	}
	static toString = function() {
		return __string__();	
	}
	
	// Path functions
	static join = function(_path) {
		var _string = __dunder__.init(DunderString, _path);
		_string.replace_all_in_place("\\", separator);
		_string.replace_all_in_place("/", separator);
		
		var _array = _string.split(separator);
		delete(_string);
		path_parts.extend(_array);
		return self;
	}
	
	exists = function() {
		return is_file() or is_dir();
	}
	
	is_file = function() {
		if (__boolean__()) {
			return file_exists(__string__());
		}
		return false;
	}
	
	is_dir = function() {
		if (__boolean__()) {
			return directory_exists(__string__());
		}
		return false;
	}
	
	get_parent = function() {
		// return new Path with parent
		if (path_parts.__len__() == 0) {
			throw __dunder__.init(DunderExceptionValueError, "Can't go up in path");
		}
		
		var _parent = __clone__()
		_parent.up()
		return _parent;
	}
		
	get_joined = function(_name) {
		// return new Path with child
		var _child = __clone__()
		_child.join(_name);
		return _child;
	}

	up = function() {
		// go up one, in place
		if (path_parts.__len__() == 0) {
			throw __dunder__.init(DunderExceptionValueError, "Can't go up in path");
		}
		
		path_parts.pop();
		return self;
	}
}