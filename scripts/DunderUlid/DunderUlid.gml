function DunderUlid() : DunderBaseStruct() constructor {
	// A range of values
	__bases_add__(DunderUlid);
	
	static __rng = __dunder__.init(DunderRng);
	static __crockford_alphabet = [
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A",
		"B", "C", "D", "E", "F", "G", "H", "J", "K", "M", "N",
		"P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z"
	]
	
	static __init__ = function(_input=undefined) {
		static __prev_unix = undefined;
		static __rand80_low40 = 0;
		static __rand80_high40 = 0;
	
		if (__dunder__.can_array(_input)) {
			var _array = __dunder__.as_array(_input);
			var _len = array_length(_array);
			if (_len < 3) {
				throw __dunder__.init(DunderExceptionValueError, "Can't coerse array to Ulid, not enough values");
			}
			
			if (_array[0] < 0 or _array[0] > 0xffffffff or
				_array[1] < 0 or _array[1] > 0xffffffff or
				_array[2] < 0 or _array[2] > 0xffffffffff) {
				throw __dunder__.init(DunderExceptionValueError, "Can't coerse array to Ulid, format incorrect");
			}
			values = _input;
		}
		else if (__dunder__.can_string(_input)) {
			var _string = __dunder__.as_string(_input);
			if (string_length(_string) == 26) {
				values = [
					__convert_crockford_base32_to_int(string_copy(_string, 19, 8)),
					__convert_crockford_base32_to_int(string_copy(_string, 11, 8)),
					__convert_crockford_base32_to_int(string_copy(_string, 1, 10)),
				];
			}
			// TODO: support UUID
			else {
				throw __dunder__.init(DunderExceptionValueError, "Can't coerse string to Ulid, format incorrect");
			}
		}
		else if (not is_undefined(_input)) {
			throw __dunder__.init(DunderExceptionTypeError, "Can't coerse type "+typeof(_input)+" to Ulid");
		}
		else {
			// get time
			var _prev_timezone = date_get_timezone()
			date_set_timezone(timezone_utc);
			var _unix = floor((date_current_datetime() - 25569) * 86400000);

			// If in the same millisecond, increment, rather than generate new random
			if (__prev_unix == _unix) {
				// increment
				__rand80_low40 += 1;
				if (__rand80_low40 > 0xffffffffff) {
					__rand80_high40 += 1;
					__rand80_low40 -= 0xffffffffff;
			
					if (__rand80_high40 > 0xffffffffff) {
						// see spec: https://github.com/ulid/spec
						throw __dunder__.init(DunderException, "ULID exceeds max generations");
					}
				}
			}
			else {
				// reroll
				__rand80_low40 = ((__rng.rand_raw() & 0xffffffff) << 8) | (__rng.rand_raw() & 0xff);
				__rand80_high40 = ((__rng.rand_raw() & 0xffffffff) << 8) | (__rng.rand_raw() & 0xff);
			}
	
			// convert into 32-bit values
			values = [__rand80_low40, __rand80_high40, _unix];

			// rest timezone
			date_set_timezone(_prev_timezone);
			__prev_unix = _unix;
		}
	}
	
	static __clone__ = function(_input) {
		if (is_undefined(_input)) {
			_input = value;
		}
		return __dunder__.init(self.__type__(), _input);
	}
	
	// Representation methods
	static __string__ = function() {
		return __convert_int_to_crockford_base32(values[2], 10) +
				__convert_int_to_crockford_base32(values[1], 8) +
				__convert_int_to_crockford_base32(values[0], 8);
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" value=`"+__string__()+"`>";
	}
	static toString = function() {
		return __string__();
	}
	
	// Mathematical operators
	static __eq__ = function(_other) {
		if (__dunder__.can_string(_other)) {
			return __string__() == __dunder__.as_string(_other);
		}
		if (__dunder__.is_type(_other, DunderUlid)) {
			return array_equals(values, _other.values);
		}
		return false;
	}
	
	// ULID methods
	static __convert_int_to_crockford_base32 = function(_value, _length) {
		var _str = "";
		for (var _i=(_length-1)*5; _i>=0; _i-=5) {
			var _bits = (_value >> _i) & 0x1f;
			_str += __crockford_alphabet[_bits]
		}
	
		return _str;
	}
	static __convert_crockford_base32_to_int = function(_string) {	
		static __crockford_lookup = undefined;
		
		if (is_undefined(__crockford_lookup)) {
			show_debug_message("generate lookup");
			__crockford_lookup = {}
			for (var _i=0; _i<32; _i++) {
				__crockford_lookup[$ __crockford_alphabet[_i]] = _i;
			}
		}
		
		var _value = 0;
		var _len = string_length(_string);
		for (var _i=0; _i<_len; _i+=1) {
			var _char = string_char_at(_string, _i+1);
			var _bits = __crockford_lookup[$ _char];
			if (is_undefined(_bits)) {
				throw __dunder__.init(DunderExceptionValueError, "Can't convert string to Ulid, bad character "+string(_char));
			}
			_value = (_value << 5) | _bits;
		}
		return _value;
	}
	static get_timestamp = function() {
		return values[2]/1000;	
	}
}