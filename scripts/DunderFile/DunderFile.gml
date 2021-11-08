function DunderFile() : DunderDict() constructor {
	// Handles a file
	__bases_add__(DunderFile);
	
	static __init__ = function(_input) {
		path = __dunder__.as_string(_input);
		__file_handle = -1;
	}
	static __del__ = function() {
		close();	
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
	
	static flush = function() {
		if (__file_handle >= 0) {
			file_text_close(__file_handle);
			file_text_open_append(path);
		}
	}
	
	static open_append = function() {
		if (__file_handle < 0) {
			__file_handle = file_text_open_append(path);
			if (__file_handle == -1) {
				throw __dunder__.init(DunderExceptionFileError, "Could not open for writing "+path);
			}
		}
	}
	
	static close = function() {
		if (__file_handle >= 0) {
			file_text_close(__file_handle);
		}	
	}
	
	static write_line = function(_input) {
		if (__file_handle < 0) {
			throw __dunder__.init(DunderExceptionFileError, "Can't write, file handle not open");
		}
		var _string = __dunder__.as_string(_input);
		file_text_write_string(__file_handle, _string);
		file_text_writeln(__file_handle);
	}
}