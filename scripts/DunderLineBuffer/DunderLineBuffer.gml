function DunderLineBuffer() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderLineBuffer);
	// A buffer that can return one line of string at a time
	
	static __init__ = function(_existing_buffer=undefined, _copy=false) {
		buffer = _existing_buffer
		
		if (_copy == true) {
			var _len = buffer_get_size(_existing_buffer);
			buffer = buffer_create(_len, buffer_fixed, 1);
			buffer_copy(_existign_buffer, 0, _len, buffer, 0);
		}
		else {
			buffer = _existing_buffer;	
		}
	}
	
	static concatenate = function(_incoming_buffer, _incoming_size) {
		if (is_undefined(buffer)) {
			var _new_size = _incoming_size;
			buffer = buffer_create(_new_size, buffer_fast, 1);
			buffer_copy(_incoming_buffer, 0, _incoming_size, buffer, 0);
		} else {
			var _old_size = buffer_get_size(buffer)
			var _new_size = _old_size + _incoming_size;
			buffer_resize(buffer, _new_size);
			buffer_copy(_incoming_buffer, 0, _incoming_size, buffer, _old_size);
		}
	}
	
	static has_data = function() {
		if (is_undefined(buffer)) {
			return false;	
		}
		return buffer_tell(buffer) < buffer_get_size(buffer);	
	}
	
	static __boolean__ = function() {
		return has_data();	
	}
	static as_boolean = __boolean__;
	
	static __cleanup__ = function() {
		if (!is_undefined(buffer)) {
			buffer_delete(buffer);
		}
	}
	
	static read_line = function() {
		var _original_position = buffer_tell(buffer);
		var _read_len = buffer_get_size(buffer) - _original_position;
		var _last_byte = undefined;
		
		for (var _i=0; _i<_read_len; _i++) {
			var _byte = buffer_read(buffer, buffer_u8);
			if (_byte == 0 or (_last_byte == 13 and _byte == 10)) {
				var _len = _i - 1;
				if (_len <= 0) return dunder.init_string("");
				
				// copy buffer to temp buffer to read all of it into a string
				var _temp_buff = buffer_create(_len, buffer_fixed, 1);
				buffer_copy(buffer, _original_position, _len, _temp_buff, 0);
				var _str = buffer_read(_temp_buff, buffer_string);
				buffer_delete(_temp_buff);
				
				return dunder.init_string(_str);
			}
			_last_byte = _byte;
		}
		
		// no return, return to original position
		buffer_seek(buffer, buffer_seek_start, _original_position);
		return undefined;
	}
	
	static read_length_to_buffer = function(_read_len) {
		if (buffer_get_size(buffer) < buffer_tell(buffer) + _read_len) return undefined;
		
		var _original_position = buffer_tell(buffer);
		var _out_buffer = buffer_create(_read_len, buffer_fixed, 1);
		buffer_copy(buffer, _original_position, _read_len, _out_buffer,0);
		buffer_seek(buffer, buffer_seek_start, _original_position + _read_len);
		
		return _out_buffer;
	}
}