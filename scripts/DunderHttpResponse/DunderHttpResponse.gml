function DunderHttpResponse() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderHttpResponse);
	// Handles an HTTP response
	
	static __init__ = function(_header_only=false) {
		headers = {};
		response_data_buffer = undefined;
		network_buffer = undefined;
		status_code = 200;
		dirty = true;
		header_only = _header_only;
	}
	
	static __cleanup__ = function() {
		if (!is_undefined(response_data_buffer)) {
			buffer_delete(response_data_buffer);	
		}
		if (!is_undefined(network_buffer)) {
			buffer_delete(network_buffer);	
		}
	}
	static cleanup = __cleanup__;
	
	static set_status = function(_status) {
		status_code = _status
		dirty = true;
		return self;
	}
	
	static set_header = function(_header, _value) {
		headers[$ _header] = _value;
		dirty = true;
	}
	
	static send_buffer = function(_buffer) {
		if (!is_undefined(response_data_buffer)) {
			throw "HttpResponse already has data, can't add another buffer";	
		}
		headers[$ "Content-Length"] = buffer_get_size(_buffer);
		response_data_buffer = _buffer;
		dirty = true;
		return self;
	}
	
	static send_string = function(_str) {
		if (!is_undefined(response_data_buffer)) {
			throw "HttpResponse already has data, can't add another buffer";	
		}
		_str = string(_str);
		var _buff = buffer_create(string_byte_length(_str), buffer_fixed, 1);
		buffer_write(_buff, buffer_text, _str);
		return send_buffer(_buff);
	}
	
	static send_struct_as_json = function(_struct) {
		if (!is_struct(_struct)) {
			throw "Not a struct";
		}
		headers[$ "Content-Type"] = "application/json";
		return send_string(json_stringify(_struct))
	}
	
	static get_send_buffer = function() {
		if (dirty == false) {
			return network_buffer;	
		}
		
		if (!is_undefined(network_buffer)) {
			buffer_delete(network_buffer);	
		}
		
		var _top_matter = "HTTP/1.1 " + string(status_code) + " " + __lookup_code(status_code) + "\r\n" + 
			"Date: " + ___rfc_date_now() + "\r\n" +
			"Server: " + game_display_name + " " + GM_version + " (GameMaker/" + GM_runtime_version + ")\r\n"
		;
		var _header_names = variable_struct_get_names(headers)
		for (var _i=0; _i<array_length(_header_names); _i++) {
			_top_matter += _header_names[_i] + ": " + string(headers[$ _header_names[_i]]) + "\r\n";
		}
		_top_matter += "\r\n";
		
		if (is_undefined(response_data_buffer) or header_only) {
			network_buffer = buffer_create(string_byte_length(_top_matter), buffer_fixed, 1);
			buffer_write(network_buffer, buffer_text, _top_matter);
		}
		else {
			network_buffer = buffer_create(string_byte_length(_top_matter) + buffer_get_size(response_data_buffer), buffer_fixed, 1);
			buffer_write(network_buffer, buffer_text, _top_matter);
			buffer_copy(response_data_buffer, 0, buffer_get_size(response_data_buffer), network_buffer, string_byte_length(_top_matter));
		}
		
		dirty = false;
		return network_buffer;
	}
	
	static get_send_size = function() {
		return buffer_get_size(get_send_buffer());
	}
	
	static __lookup_code = function(_code) {
		switch(_code) {
			case 100: return "Continue";
			case 101: return "Switching Protocols";
			case 102: return "Processing";
			case 200: return "OK";
			case 201: return "Created";
			case 202: return "Accepted";
			case 203: return "Non-authoritative Information";
			case 204: return "No Content";
			case 205: return "Reset Content";
			case 206: return "Partial Content";
			case 207: return "Multi-Status";
			case 208: return "Already Reported";
			case 226: return "IM Used";
			case 300: return "Multiple Choices";
			case 301: return "Moved Permanently";
			case 302: return "Found";
			case 303: return "See Other";
			case 304: return "Not Modified";
			case 305: return "Use Proxy";
			case 307: return "Temporary Redirect";
			case 308: return "Permanent Redirect";
			case 400: return "Bad Request";
			case 401: return "Unauthorized";
			case 402: return "Payment Required";
			case 403: return "Forbidden";
			case 404: return "Not Found";
			case 405: return "Method Not Allowed";
			case 406: return "Not Acceptable";
			case 407: return "Proxy Authentication Required";
			case 408: return "Request Timeout";
			case 409: return "Conflict";
			case 410: return "Gone";
			case 411: return "Length Required";
			case 412: return "Precondition Failed";
			case 413: return "Payload Too Large";
			case 414: return "Request-URI Too Long";
			case 415: return "Unsupported Media Type";
			case 416: return "Requested Range Not Satisfiable";
			case 417: return "Expectation Failed";
			case 418: return "I'm a teapot";
			case 421: return "Misdirected Request";
			case 422: return "Unprocessable Entity";
			case 423: return "Locked";
			case 424: return "Failed Dependency";
			case 426: return "Upgrade Required";
			case 428: return "Precondition Required";
			case 429: return "Too Many Requests";
			case 431: return "Request Header Fields Too Large";
			case 444: return "Connection Closed Without Response";
			case 451: return "Unavailable For Legal Reasons";
			case 499: return "Client Closed Request";
			case 500: return "Internal Server Error";
			case 501: return "Not Implemented";
			case 502: return "Bad Gateway";
			case 503: return "Service Unavailable";
			case 504: return "Gateway Timeout";
			case 505: return "HTTP Version Not Supported";
			case 506: return "Variant Also Negotiates";
			case 507: return "Insufficient Storage";
			case 508: return "Loop Detected";
			case 510: return "Not Extended";
			case 511: return "Network Authentication Required";
			case 599: return "Network Connect Timeout Error";
			default:
				if (100 >= _code and _code < 200) return "Informational";
				if (200 >= _code and _code < 300) return "Success";
				if (300 >= _code and _code < 400) return "Redirection";
				if (400 >= _code and _code < 500) return "Client Error";
				return "Server Error";
		}
	}
	
	static ___rfc_date_now = function() {
		var _prev_timezone = date_get_timezone();
		date_set_timezone(timezone_utc);
		
		var _str = __rfc_date(date_current_datetime());
		
		date_set_timezone(_prev_timezone);
		return _str;
	}
	
	static __rfc_date = function(_datetime) {	
		switch(date_get_weekday(_datetime)) {
			case 0: var _weekday = "Sun"; break;
			case 1: var _weekday = "Mon"; break;
			case 2: var _weekday = "Tue"; break;
			case 3: var _weekday = "Wed"; break;
			case 4: var _weekday = "Thu"; break;
			case 5: var _weekday = "Fri"; break;
			case 6: var _weekday = "Sat"; break;
		}
		
		var _day = __zero_pad_string(date_get_day(_datetime), 2);
		
		switch(date_get_month(_datetime)) {
			case 1: var _month = "Jan"; break;
			case 2: var _month = "Feb"; break;
			case 3: var _month = "Mar"; break;
			case 4: var _month = "Apr"; break;
			case 5: var _month = "May"; break;
			case 6: var _month = "Jun"; break;
			case 7: var _month = "Jul"; break;
			case 8: var _month = "Aug"; break;
			case 9: var _month = "Sep"; break;
			case 10: var _month = "Oct"; break;
			case 11: var _month = "Nov"; break;
			case 12: var _month = "Dec"; break;
		}
		
		var _year = string(date_get_year(_datetime));
		var _hours = __zero_pad_string(date_get_hour(_datetime), 2);
		var _minutes = __zero_pad_string(date_get_minute(_datetime), 2);
		var _seconds = __zero_pad_string(date_get_second(_datetime), 2);
		
		return _weekday + ", " + _day + " " + _month + " " + _year + " " + _hours + ":" + _minutes + ":" + _seconds + " GMT";
	}
	
	static __zero_pad_string = function(_number, _places) {
		return string_replace(string_format(_number, _places, 0), " ", "0");
	}
}
