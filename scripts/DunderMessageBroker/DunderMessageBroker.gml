function DunderMessageBroker() : DunderDict() constructor { REGISTER_SUBTYPE(DunderMessageBroker);
	// A collection of message busses. Also inherits from DunderDict to provide global state store
	
	static __init__ = function() {
		channels = dunder.init(DunderDefaultDict, DunderMessageBus);
		
		var _super = __super__(DunderMessageBroker);
		_super();
	}
	
	static publish = function(_channel_name, _message, _latch=false) {
		var _channel = channels.get(_channel_name);
		_channel.publish(_message, _latch);
	}
	
	static subscribe = function(_channel_name, _callback) {
		var _channel = channels.get(_channel_name);
		return _channel.subscribe(_callback);
	}
	
	static unsubscribe = function(_channel_name, _id) {
		var _channel = channels.get(_channel_name);
		_channel.unsubscribe(_id);
	}
	
	static message_bus = function(_channel_name) {
		return channels.get(_channel_name);
	}
}
