function DunderHttpServer() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderHttpServer);
	// An HTTP server
	
	static __init__ = function(_port, _logger=undefined) {
		port = _port;
		socket = undefined;
		
		listener_instance = noone;
		clients = dunder.init_dict();
		
		if (is_undefined(_logger)) {
			logger = dunder.init(DunderLogger, "HttpServer", {port:port})
		}
		else {
			logger = _logger;
		}
		router = dunder.init(DunderHttpRouter, logger);
	}
	
	static add_path = function(_path, _callback) {
		return router.add_path(_path, _callback);
	}
	
	static __cleanup__ = function() {
		stop();
		listener_instance.__cleanup__();
		delete listener_instance;
	}
	
	static start = function() {
		if (not is_undefined(socket)) {
			return;
		}
		socket = network_create_server_raw(network_socket_tcp, port, 20);
		if (socket < 0) {
			logger.error("Server port not available");
		}
		
		if (listener_instance == noone) {
			listener_instance = dunder.create_instance(__obj_dunder_socket_listener, 0, 0, 0, undefined,
				[undefined, method(self, async_networking_handler)]
			);	
		}
	}
	
	static stop = function() {
		dunder.foreach(clients, function(_client) {
			_client.cleanup();
		});
		if (socket >= 0) {
			network_destroy(socket);
			socket = -1;
		}
	}
	
	static async_networking_handler = function(_async_load) {
		var _type = _async_load[? "type"];
		var _async_id = _async_load[? "id"];
		switch (_type) {
			case network_type_connect: 
			case network_type_non_blocking_connect:
				if (_async_id == socket) {
					handle_connect(_async_load)
				}
				break;
				
			case network_type_disconnect:
				if (_async_id == socket) {
					handle_disconnect(_async_load);
				}
				break;
				
			case network_type_data:
				if (clients.has(_async_id)) {
					handle_data(_async_load)
				}
				break;
		}
	}
	
	static handle_connect = function(_async_load) {
		var _client_socket = _async_load[? "socket"];
		clients.set(_client_socket, dunder.init(DunderHttpSession, _client_socket, router, logger));
	}
	
	static handle_disconnect = function(_async_load) {
		var _client_socket = _async_load[? "socket"];
		logger.info("Client disconnected", {socket_id: _client_socket})  
		if (clients.has(_client_socket)) {
			clients.get(_client_socket).cleanup();
			clients.remove(_client_socket);	
		}
	}
	
	static handle_data = function(_async_load) {
		var _client_socket = _async_load[? "id"];
		var _buffer = _async_load[? "buffer"];
		var _size = _async_load[? "size"];
		
		var _client = clients.get(_client_socket);
		_client.handle_data(_buffer, _size);
		
		if (_client.closed) {
			clients.get(_client_socket).cleanup();
			clients.remove(_client_socket);	
			network_destroy(_client_socket);	
			logger.info("Closed client", {socket_id: _client_socket})  
		}
	}
}