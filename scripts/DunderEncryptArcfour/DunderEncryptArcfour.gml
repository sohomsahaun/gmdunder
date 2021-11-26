function DunderEncryptArcfour() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderEncryptArcfour);
	static state_size = 256;
	
	// An LGC-based RNG. Current params are based on rand48
	static __init__ = function(_cypher_key) {
		
		// create cypher key
		
		var _key_len = string_byte_length(_cypher_key)

		state = array_create(state_size);
		for (var _i=0; _i<state_size; _i++) {
			state[_i] = _i;
		}

		var _j = 0;
		var _k;
		for (var _i=0; _i<state_size; _i++) {
			_j = (_j + state[_i] + string_byte_at(_cypher_key, (_i % _key_len)+1)) % state_size;
			_k = state[_i];
			state[_i] = state[_j];
			state[_j] = _k;
		}

	}
	
	static encrypt_buffer = function(_buffer) {
		var _buffer_len = buffer_get_size(_buffer);
		var _temp_buff = buffer_create(_buffer_len, buffer_fixed, 1);
		buffer_seek(_buffer, buffer_seek_start, 0);

		var _j = 0;
		for (var _n=1; _n<=_buffer_len; _n++) {
			var _i = _n % state_size;
			_j = (_j + state[_i]) % state_size

			var _k = state[_i];
			state[_i] = state[_j];
			state[_j] = _k;
	
			var _key = state[(state[_i] + state[_j]) % state_size];
			var in_byte = buffer_read(_buffer, buffer_u8);
			buffer_write(_temp_buff, buffer_u8, _key ^ in_byte);
		}

		return _temp_buff;
	}
	
	static decrypt_buffer = encrypt_buffer; // surprise! arcdour is symmetric
}