function DunderSocket() : DunderBaseStruct() constructor {
	// A list wrapper
	__bases_add__(DunderSocket);
	
	static __init__ = function(_socket_type, _host, _port, _raw=true) {
		socket_type = _socket_type;
		host = _host;
		port = _port;
		raw = _raw;
		
		packet_callback = undefined;
		connect_callback = undefined;
		disconnect_callback = undefined;
		step_callback = undefined;
		
		socket = undefined;
		__connected = false;
		__disconnected_time = 0;
		__should_be_connected = false
		__listener_instance = __dunder__.init(DunderInstance, __obj_dunder_socket_listener, 0, 0, 0, undefined,
			[method(self, __step_handler), method(self, __async_networking_handler)]
		);
	}
	
	static __del__ = function() {
		disconnect();
		__listener_instance.__del__();
		delete __listener_instance;
	}
	
	static __bool__ = function() {
		return __connected;	
	}
	
	// Socket functions
	is_connected = function() {
		return __connected;	
	}
	static set_packet_callback = function(_func) {
		packet_callback = _func;
		return self;
	}
	static set_connect_callback = function(_func) {
		connect_callback = _func;
		return self;
	}
	static set_disconnect_callback = function(_func) {
		disconnect_callback = _func;
		return self;
	}
	static set_step_callback = function(_func) {
		step_callback = _func;
		return self;
	}
	
	static connect = function() {
		if (not is_undefined(socket)) {
			return;
		}
		socket = network_create_socket(socket_type);
		network_set_config(network_config_connect_timeout, 1500);
		network_set_config(network_config_use_non_blocking_socket, 1);
		if (raw) {
			network_connect_raw(socket, host, port);
		}
		else {
			network_connect(socket, host, port);
		}
		__should_be_connected = true;
		__disconnected_time = 0;
	}

	static disconnect = function() {
		if (is_undefined(socket)) {
			return;
		}
		
		network_destroy(socket);
		socket = undefined;
		__should_be_connected = false;
		__connected = false;
	}
	
	static send_buffer = function(_buff, _size) {
		if (not is_undefined(socket)) {
			if (raw) {
				return network_send_raw(socket, _buff, _size);
			}
			else {
				return network_send_packet(socket, _buff, _size);
			}
		}
		return 0;
	}
	
	static send_string = function(_input) {
		var _string = __dunder__.as_string(_input);
		var _len = string_byte_length(_string);
		var _buff = buffer_create(_len, buffer_fixed, 1);
		buffer_write(_buff, buffer_text, _string);
		
		var _result = send_buffer(_buff, _len);
		buffer_delete(_buff);
		return _result;
	}
	
	static __async_networking_handler = function(_async_load) {
		if (_async_load[? "id"] != socket) {
			return
		}
		var _type = _async_load[? "type"];
		
		switch (_type) {
			case network_type_non_blocking_connect:
				// There seems to be a bug where a non-blocking connect will fire an async event that says "succeeded"
				// 
				if (_async_load[? "succeeded"]) {
					__connected = true;				
					__disconnected_time = 0;
					show_debug_message("Socket Client connected to " + string(host) + " port " + string(port))
					if (is_method(connect_callback)) {
						connect_callback();
					}
				}
				else {
					__connected = false;	
				}
				break

			case network_type_disconnect:
				__connected = false;
				show_debug_message("Socket Client disconnected")
				if (is_method(disconnect_callback)) {
					disconnect_callback();
				}
				connect();
				break;
				
			case network_type_data:
				var _buffer = _async_load[? "buffer"];
				var _size = _async_load[? "size"];
				if (is_method(packet_callback)) {
					packet_callback(_buffer, _size);
				}
				break;
		}
	}
	
	static __step_handler = function() {
		if (not __connected and __should_be_connected) {
			__disconnected_time += 1;
			if (__disconnected_time > game_get_speed(gamespeed_fps) * 2) {
				__disconnected_time = 0;
				show_debug_message("Socket Client connection stale")
				connect();
			}
		}
		if (is_method(step_callback)) {
			step_callback();	
		}
	}
}