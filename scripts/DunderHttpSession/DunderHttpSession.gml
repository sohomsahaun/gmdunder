function DunderHttpSession() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderHttpSession);
	// An HTTP connection session state machine, using SnowState to provide state machine
	
	static __init__ = function(_client_socket, _router, _logger, _catch_errors) {
	
		line_buffer = dunder.init(DunderLineBuffer);
		closed = false;
		catch_errors = _catch_errors;
	
		request = {
			method: "",
			path: "",
			headers: {},
			data: undefined,
			parameters : {}
		};
		
		response = undefined;
		router = _router;
		client_socket = _client_socket;
		
		logger = _logger.bind({socket_id: _client_socket});
		logger.info("Client connected");

		fsm = new SnowState("request");
		fsm.add("request", {
			handle_data: function(_line_buffer) {
				// read first line of request
				var _str = _line_buffer.read_line();
			
				if (is_undefined(_str) or dunder.as_boolean(_str) == false) {
					logger.warning("Not HTTP session, closing");
					close();
					return;
				}
			
				var tokens = _str.split(" ");
				if (array_length(tokens) < 3) {
					logger.warning("Malformed HTTP request, closing");
					close();
					return;
				}
			
				if (not tokens.get(2).equals("HTTP/1.1")) {
					logger.warning("Unsupported HTTP request, closing");
					close();
					return;
				}
			
				request.method = tokens.get(0).as_string();
				request.path = tokens.get(1); // note! not casting to string here
				fsm.change("headers");
			}
		})
		.add("headers", {
			handle_data: function(_line_buffer) {
				// read a header
				var _str = _line_buffer.read_line();
			
				if (is_undefined(_str)) return;
			
				if (_str.equals("")) {
					// empty line means end of headers
					if (variable_struct_exists(request.headers, "content-length") and request.headers[$ "content-length"] != "0") {
						fsm.change("data");
					}
					else {
						fsm.change("dispatch");
					}
					return;
				}
			
				var tokens = _str.split(": ");
				request.headers[$ tokens.get(0).lower().as_string()] = tokens.get(1).as_string();
			}
		})
		.add("data", {
			handle_data: function(_line_buffer) {
				request.data = _line_buffer.read_length_to_buffer(real(request.headers[$ "content-length"]));
				if (!is_undefined(request.data)) {
					fsm.change("dispatch");	
				}
			}
		})
		.add("dispatch", {
			enter: function() {
				logger.info("Received request", {method: request.method, path: request.path});
				var _header_only = (request.method == "HEAD" or request.method == "OPTIONS")
				response = dunder.init(DunderHttpResponse, _header_only);
			
				if (catch_errors) {
					try {
						router.run_handler_for_path(request, response);
					}
					catch (_err) {
						logger.exception(_err);
						response.set_status(500).send_string("Internal error");
					}
				}
				else {
					router.run_handler_for_path(request, response);
				}
			
				var _buffer = response.get_send_buffer();
				var _size =  response.get_send_size();
				network_send_raw(client_socket, _buffer, _size);
				
				logger.info("Sent response", {response_code: response.status_code, size: _size});
				response.cleanup();
				if (not is_undefined(request.data)) {
					buffer_delete(request.data);	
				}
				close();
				fsm.change("finished");
			}
		})
		.add("finished", {
			handle_data: function() { return }
		});
	}

	static __cleanup__ = function() {
		if (not is_undefined(request.data)) {
			buffer_delete(request.data);	
		}
		line_buffer.cleanup();
		close();
	};
	static cleanup = __cleanup__;
	
	static handle_data = function(_incoming_buffer, _incoming_size) {
		line_buffer.concatenate(_incoming_buffer, _incoming_size);
		while(closed == false and line_buffer.has_data()) {
			fsm.handle_data(line_buffer);
		}
	};
	
	static close = function() {
		closed = true;
	};
}