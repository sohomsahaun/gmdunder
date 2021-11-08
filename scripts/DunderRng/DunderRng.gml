function DunderRng() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderRange);
	// An LGC-based RNG. Current params are based on rand48
	static __init__ = function(_seed=undefined, _multiplier=25214903917, _increment=11, _modulus=0x1000000000000, _shift=16, _mask=0xffffffff) {
		multiplier = _multiplier;
		increment = _increment
		modulus = _modulus;
		shift = _shift
		mask = _mask;
		
		if (is_numeric(_seed)) {
			state = _seed % modulus;
		}
		else {
			state = (date_current_datetime() * 86400000) % modulus;
		}
	}
	
	// RNG functions
	static set_state = function(_state) {
		state = _state;
		return self;
	}
	static get_state = function() {
		return state;	
	}
	static rand_raw = function() {
		state = (state * multiplier + increment) % modulus;
		return (state >> shift) & mask;
	}
	static rand_int = function(_a, _b=0) {
		var _max = max(floor(_a), floor(_b));
		var _min = min(ceil(_a), ceil(_b));
		
		var _range = _max - _min + 1;
		
		if (_range <= 1) {
			throw init(DunderExceptionValueError, "Invalid range values");
		}
		if (_range > modulus) {
			throw init(DunderExceptionValueError, "Range is too large for this RNG");
		}
		
		return _min + (rand_raw() % _range);
	}
	static rand_range = function(_a, _b=0) {
		var _max = max(_a, _b);
		var _min = min(_a, _b);
		
		var _range = _max - _min;
		
		if (_range <= 0) {
			throw init(DunderExceptionValueError, "Invalid range values");
		}
		
		return _min + (rand_raw()/modulus) * _range;
	}
}