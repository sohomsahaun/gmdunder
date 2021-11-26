function DunderMessageBus() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderMessageBus);
	// An internal pub/sub message broker
	
	static __init__ = function() {
		subscribers = dunder.init_dict();
		latched_value = undefined;
		has_latched_value = false;
		id_counter = 0;
	}
	
	static next_id = function() {
		return id_counter++;
	}
	
	static set_latched = function(_message) {
		latched_value = _message;
		has_latched_value = true;
	}
	
	static clear_latched = function() {
		latched_value = undefined;
		has_latched_value = false;
	}
	
	static publish = function(_message, _latch=false) {
		dunder.foreach(subscribers, method({message: _message}, function(_callback) {
			_callback(message);
		}));
		
		if (_latch == true) {
			set_latched(_message);	
		}
	}
	
	static subscribe = function(_callback) {
		var _id = next_id();
		subscribers.set(_id, _callback);
		
		if (has_latched_value) {
			_callback(latched_value);
		}
		
		return _id;
	}
	
	static unsubscribe = function(_id) {
		subscribers.clear(_id);
	}
}
