function DunderUnleashClient() : DunderHttpClient() constructor { REGISTER_SUBTYPE(DunderUnleashClient);
	// Wraps a gamemaker object instance, to make it managable as a Dunder Struct

	static __init__ = function(_url, _authorization) {
		var _super = self.__super__(DunderUnleashClient);
		_super(_url, {Authorization: _authorization}, "UnleashClient");
		
		self.user_id = undefined;
		self.toggles = {};
	}
	
	static set_user_id = function(_user_id=undefined) {
		self.user_id = _user_id;	
	}
	
	static refresh = function() {
		var _url = "";
		if (is_string(self.user_id)) {
			_url = "?userId=" + self.user_id;
		}
		
		self.get(_url, method(self, self.__request_callback));
	}
	
	static is_enabled = function(_toggle_name) {
		return variable_struct_exists(self.toggles, _toggle_name) and self.toggles[$ _toggle_name] == true;
	}
	
	static __request_callback = function(_body, _http_status_code) {
		if (_http_status_code != 200) {
			return;	
		}
		
		try {
			var _json = json_parse(_body);
		}
		catch (_err) {
			self.logger.error("Json parse error", {body: _body, err: _err});
			return;
		}
		
		self.toggles = {};
		self.dunder.foreach(_json.toggles, function(_toggle) {
			self.toggles[$ _toggle.name] = _toggle.enabled;
		});
		self.logger.info("Toggles refreshed");
	}
}