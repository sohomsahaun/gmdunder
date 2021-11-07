function DunderRng() : DunderBaseStruct() constructor {
	// An LGC-based RNG. Current params are based on rand48
	__bases_add__(DunderRange);
	
	static __init__ = function(_seed=undefined, _multiplier=25214903917, _increment=11, _mask=0x7fffffff, _modulus=0x100000000) {
		
		multiplier = _multiplier;
		increment = _increment
		mask = _mask;
		modulus = _modulus;
		
		if (is_numeric(_seed)) {
			state = (_seed & mask) % modulus;
		}
		else {
			state = ((date_current_datetime() * 86400000) & mask) % modulus;
		}
		
	}
	
	static set_state = function(_state) {
		state = _state;
		return self;
	}
	
	static get_state = function() {
		return state;	
	}
	
	static rand_raw = function() {
		state = (state * multiplier + increment) % modulus;
		return state;
	}
	
	static rand_int = function(_a, _b=0) {
		var _max = max(floor(_a), floor(_b));
		var _min = min(ceil(_a), ceil(_b));
		
		var _range = _max - _min;
		
		if (_range <= 0) {
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