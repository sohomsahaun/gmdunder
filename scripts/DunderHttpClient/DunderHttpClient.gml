function DunderHttpClient() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderHttpClient);
	// Manages HTTP connections

	static __init__ = function(_base_url="", _headers={}, _logger_name="HttpClient") {
		self.logger = self.dunder.bind_named_logger(_logger_name, {base_url: _base_url});
		self.base_url = _base_url;
		self.header_map = self.__make_header_map(_headers);
		self.listener_instance = undefined;
		
		self.requests = self.dunder.init(DunderDict);
		self.timeouts = self.dunder.init(DunderMinHeap);
	}
	
	static __cleanup__ = function() {
		ds_map_destroy(self.header_map);
		if (not is_undefined(self.listener_instance)) {
			self.listener_instance.__cleanup__();
		}
	}
	static cleanup = __cleanup__;
	
	static set_headers = function(_headers={}) {
		ds_map_destroy(self.header_map);
		self.header_map = self.__make_header_map(_headers);
	}
	
	static request = function(_method, _url, _body, _callback, _errback=undefined, _timeout=15) {
		var _req_id = http_request(self.base_url+_url, _method, self.header_map, _body);
		self.logger.info("Making request", {method: _method, url: _url, req_id: _req_id})
		
		var _expiry = get_timer() + _timeout*1000000;
		self.requests.set(_req_id, {
			method: _method,
			url: _url,
			callback: _callback,
			errback: _errback,
			expiry: _expiry,
		})
		if (_timeout > 0) {
			self.timeouts.insert(_req_id, _expiry);
		}
		
		if (is_undefined(self.listener_instance)) {
			self.listener_instance = self.dunder.create_instance(__obj_dunder_http_client, 0, 0, 0, undefined,
				[method(self, self.__step_handler), method(self, self.__async_http_handler)]
			);	
		}
		return _req_id;
	}
	
	static get = function(_url, _callback, _errback=undefined, _timeout=15) {
		return self.request("GET", _url, "", _callback, _errback, _timeout);	
	}
	
	static post = function(_url, _body, _callback, _errback=undefined, _timeout=15) {
		return self.request("POST", _url, _body, _callback, _errback, _timeout);	
	}

	static __make_header_map = function(_headers) {
		return json_decode(json_stringify(_headers));
	}
	
	static __step_handler = function() {
		while (self.timeouts.len()) {
			var _min_item = self.timeouts.peek_min()
			if(_min_item[0] > get_timer()) {
				break;
			}
			self.timeouts.pop_min();
			
			var _req_id = _min_item[1];
			if (self.requests.has(_req_id)) {
				var _request = self.requests.get(_req_id);
				self.logger.warning("Request timed out", {method: _request.method, url: _request.url, req_id: _req_id})
				if (is_method(_request.errback)) {
					_request.errback();	
				}
				self.requests.remove(_req_id);
			}
		}
	}
	
	static __async_http_handler = function(_async_load) {
		if (_async_load[? "status"] == 1) { // content still being downloaded
			return;	
		}
		var _req_id = _async_load[? "id"];
		if (self.requests.has(_req_id)) {
			var _request = self.requests.get(_req_id);
			
			if (_async_load[? "status"] < 0) {
				self.logger.warning("Request failed", {method: _request.method, url: _request.url, req_id: _req_id})
				if (is_method(_request.errback)) {
					_request.errback();	
				}
			}
			else {
				self.logger.warning("Request succeeded", {method: _request.method, url: _request.url, req_id: _req_id, http_status: _async_load[? "http_status"]})
				if (is_method(_request.callback)) {
					_request.callback(_async_load[? "result"], _async_load[? "http_status"]);	
				}
			}
			
			self.requests.remove(_req_id);
		}
	}
}