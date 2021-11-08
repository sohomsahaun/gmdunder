function DunderFileIterator() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderFileIterator);
	// An file iterator that reads line by line
	static __init__ = function(_input) {
		var _path = __dunder__.as_string(_input);
		if (not file_exists(_path)) {
			throw __dunder__.init(DunderExceptionFileError, "File "+_path+" doesn't exist");
		}
		
		__fp = file_text_open_read(_path);
		if (__fp < 0) {
			throw __dunder__.init(DunderExceptionFileError, "Could not read "+path);
			return;
		}
		index = 0;
		last_line = undefined;
	}
	
	// Iteration methods
	static __next__ = function() {
		if (not is_undefined(last_line)) {
			delete last_line;	
		}
		
		if (file_text_eof(__fp)) {
			file_text_close(__fp);
			throw __dunder__.init(DunderExceptionStopIteration);
		}
		
		var _line = file_text_readln(__fp);
		last_line = __dunder__.init(DunderString, _line);
		return [last_line, index++];
	}
}