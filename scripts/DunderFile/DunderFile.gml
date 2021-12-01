function DunderFile() : DunderDict() constructor { REGISTER_SUBTYPE(DunderFile);
	// Handles a file
	static __init__ = function(_input) {
		path = dunder.as_string(_input);
	}
	static __cleanup__ = function() {
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
		// read entire file as string
		var _buff = buffer_load(path);
		if (_buff < 0) {
			throw dunder.init(DunderExceptionFileError, "Could not read "+path);
			return;
		}
		var _str = buffer_read(_buff, buffer_text);
		buffer_delete(_buff);
		return dunder.init(DunderString(_str));
	}
	static __array__ = function() {
		// read entire file as an array of strings
		var _fp = file_text_open_read(path);
		if (_fp < 0) {
			throw dunder.init(DunderExceptionFileError, "Could not read "+path);
			return;
		}
		
		var _list = dunder.init_list();
		while(not file_text_eof(_fp)) {
			var _line = file_text_readln(_fp);
			_list.append(dunder.init_string(_line));
		}
		file_text_close(_fp);
		
		return _list;
	}
	static as_string = __string__;
	static as_boolean = __boolean__;
	static as_array = __array__;
	
	// Iteration methods
	static __iter__ = function() {
		// create a line-reading file iterator
		return dunder.init(DunderFilePointer, path, "r");
	}
	
	// file methods
	static open = function(_mode) {
		// returns an open file handler	
		return dunder.init(DunderFilePointer, path, _mode);
	}
	
	static read_buffer = function(_decompress=false) {
		var _buffer = buffer_load(path);
		if (_decompress) {
			var _decompressed = buffer_decompress(_buffer);
			buffer_delete(_buffer);
			return _decompressed;
		}
		else {
			return _buffer;
		}
	}
	
	static read_buffer_encrypted = function(_cypher_key, _decompress=false) {
		var _buffer = read_buffer(_decompress);
		var _decrypted = dunder.init(DunderEncryptArcfour, _cypher_key).decrypt_buffer(_buffer);
		buffer_delete(_buffer);
		return _decrypted;
	}
	
	static read_string = function(_decompress=false) {
		var _buffer = read_buffer(_decompress);
		var _str = buffer_read(_buffer, buffer_text);
		buffer_delete(_buffer);
		return dunder.init_string(_str);
	}
	
	static read_json_as_struct = function(_decompress=false) {
		var _buffer = read_buffer(_decompress);
		var _str = buffer_read(_buffer, buffer_text);
		buffer_delete(_buffer);
		return json_parse(_str);
	}
	
	static read_json_as_dict = function(_decompress=false) {
		return dunder.init_dict(read_json_as_struct(_decompress));	
	}
	
	static read_string_encrypted = function(_cypher_key, _decompress=false) {
		var _buffer = read_buffer_encrypted(_cypher_key, _decompress);
		var _str = buffer_read(_buffer, buffer_text);
		buffer_delete(_buffer);
		return dunder.init_string(_str);
	}
	
	static write_buffer = function(_buffer, _compress=false) {
		if (_compress) {
			var _compressed = buffer_compress(_buffer, 0, buffer_get_size(_buffer));
			buffer_save(_compressed, path);
			buffer_delete(_compressed);
		}
		else {
			buffer_save(_buffer, path);
		}
	}
	
	static write_buffer_encrypted = function(_buffer, _cypher_key, _compress=false) {
		var _encrypted = dunder.init(DunderEncryptArcfour, _cypher_key).encrypt_buffer(_buffer);
		write_buffer(_encrypted, _compress);
		buffer_delete(_encrypted);
	}
	
	static write_string = function(_input, _compress) {
		var _string = dunder.as_string(_input);
		var _buff = buffer_create(string_byte_length(_string), buffer_fixed, 1);
		buffer_write(_buff, buffer_text, _string);
		write_buffer(_buff, _compress)
		buffer_delete(_buff);
	}
	
	static write_string_encrypted = function(_input, _cypher_key, _compress=false) {
		var _string = dunder.as_string(_input);
		var _buff = buffer_create(string_byte_length(_string), buffer_fixed, 1);
		buffer_write(_buff, buffer_text, _string);
		write_buffer_encrypted(_buff, _cypher_key, _compress);
		buffer_delete(_buff);
	}
}