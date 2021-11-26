function DunderFilePointer() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderFilePointer);
	// An file iterator that reads line by line
	static __init__ = function(_input, _mode="r") {
		if (_mode != "r" and _mode != "w" and _mode != "a") {
			throw dunder.init(DunderExceptionValueError, "mode "+string(_mode)+" unsupported");
		}
		mode = _mode
		
		path = dunder.as_string(_input);
		if (not file_exists(path)) {
			throw dunder.init(DunderExceptionFileError, "File "+path+" doesn't exist");
		}
		
		__fp = -1;
		open();

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
			throw dunder.init(DunderExceptionStopIteration);
		}
		
		var _line = file_text_readln(__fp);
		last_line = dunder.init_string(_line);
		return [last_line, index++];
	}
	
	
	// File methods
	static open = function() {
		if (__fp < 0) {
			switch(mode) {
				default:
				case "r": __fp = file_text_open_read(path); break;
				case "a": __fp = file_text_open_append(path); break;
				case "w": __fp = file_text_open_write(path); break;
			}
			if (__fp < 0) {
				throw dunder.init(DunderExceptionFileError, "Could not read "+path);
				return;
			}
		}
	}
	
	static close = function() {
		// close an open text-mode file handle
		if (__fp >= 0) {
			file_text_close(__file_handle);
		}	
	}
	
	static flush = function() {
		// flush an open file handle to disk
		if (__fp >= 0) {
			file_text_close(__fp);
			__fp = file_text_open_append(path);
		}
	}
	
	static write_line = function(_input) {
		// write a line in text-mode
		if (__fp < 0) {
			throw dunder.init(DunderExceptionFileError, "Can't write, file handle not open");
		}
		var _string = dunder.as_string(_input);
		file_text_write_string(__fp, _string);
		file_text_writeln(__fp);
	}
}