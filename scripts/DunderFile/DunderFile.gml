function DunderFile() : DunderDict() constructor {
	// Handles a file
	__bases_add__(DunderFile);
	
	static __init__ = function(_input) {
		path = __dunder__.as_string(_input);
	}
	
	// Representation methods
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" path='"+path+"'>";
	}
	static __boolean__ = function() {
		return file_exists(path);
	}
	static __string__ = function() {
		var _buff = buffer_load(path);
		if (_buff < 0) {
			throw __dunder__.init(DunderExceptionFileError, "Could not read "+path);
			return;
		}
		var _str = buffer_read(_buff, buffer_text);
		buffer_delete(_buff);
		return _str;
	}
	static __array__ = function() {
		var _fp = file_text_open_read(path);
		if (_fp < 0) {
			throw __dunder__.init(DunderExceptionFileError, "Could not read "+path);
			return;
		}
		
		var _array = [];
		while(not file_text_eof(_fp)) {
			var _line = file_text_readln(_fp);
			array_push(_array, _line);
		}
		file_text_close(_fp);
		
		return _array;
	}
	
	// Iteration methods
	static __iter__ = function() {
		return __dunder__.init(DunderFileIterator, path);
	}
}