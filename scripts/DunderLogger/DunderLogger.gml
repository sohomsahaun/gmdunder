
function DunderLogger() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderLogger);
	// A Logger
	static __init__ = function(_name="logger", _bound_values=undefined, _root_logger=undefined) {
		name = dunder.as_string(_name);
		bound_values = dunder.init_dict(_bound_values, true);
		
		__json_logging = false;
		__file = undefined;
		__auto_flush = false;
	
		__root_logger = _root_logger;
		__sentry = undefined;
		__sentry_send_errors = false;
		
		__enable_fatal = true
		__enable_error = true;
		__enable_warning = true;
		__enable_info = true;
		__enable_debug = true;
	}
	
	
	static logger = function(_level, _message, _extras=undefined, _type=undefined, _stacktrace=undefined) {
		// Create a log message
		
		if (LOGGING_DISABLED) return;
		
		if (!(_level == LOG_FATAL and __enable_fatal) and 
			!(_level == LOG_ERROR and __enable_error) and
			!(_level == LOG_WARNING and __enable_warning) and
			!(_level == LOG_INFO and __enable_info) and
			!(_level == LOG_DEBUG and __enable_debug)){
			return;
		}
		
		if (is_struct(_extras)) {
			var _combined = bound_values.__clone__();
			_combined.update(_extras);
		}
		else {
			var _combined = bound_values;
		}
		
		if (__json_logging) {
			var _datetime = dunder.init(DunderDateTime);
			var _struct = {
				logName: name,
				times: _datetime.as_string(),
				severity: string_upper(_level),
				message: string(_message),
				extras: _combined.as_struct(),
			}
			delete _datetime;
			if (not is_undefined(_stacktrace)) {
				_struct[$ "stacktrace"] = _stacktrace
			}
			var _output = json_stringify(_struct);
		}
		else {
			var _combined_str = dunder.reduce(_combined, "", function(_prev, _value, _key) {
				return _prev + _key + "=" + dunder.as_string(_value) + " ";
			});
		
			var _datetime = dunder.init(DunderDateTime, undefined, "%Y-%m-%d %H:%M:%S.%f");
			var _output = _datetime.__string__()
			delete _datetime;
			switch(_level) {
				case LOG_FATAL:		_output += " [fatal  ]["; break;
				case LOG_ERROR:		_output += " [error  ]["; break;
				case LOG_WARNING:	_output += " [warning]["; break;
				case LOG_INFO:		_output += " [info   ]["; break;
				case LOG_DEBUG:		_output += " [debug  ]["; break;
				default:			_output += " ["+_level+"][";
			}
			_output += __string_pad(name + "] " + string(_message), LOGGING_PAD_WIDTH) + " " + _combined_str;
			if (not is_undefined(_stacktrace)) {
				_combined_str += "stacktrace=" + string(_stacktrace) + " ";
			}
		}
		
		show_debug_message(_output);
		__write_line_to_file(_output);
		
		if (not is_undefined(__sentry)) {
			if (__sentry_send_errors and _level == LOG_ERROR) {
				__sentry.send_report(_level, _message, undefined, undefined, name, _combined.as_struct(), _stacktrace); 
			}
			else {
				if (is_undefined(_type)) {
					if (_level == LOG_FATAL or _level = LOG_ERROR or _level = LOG_WARNING) {
						_type = LOG_ERROR	
					}
					else if (_level == LOG_INFO or _level == LOG_DEBUG) {
						_type = _level
					}
					else {
						_type = "default";	
					}
				}
				__sentry.add_breadcrumb(name, _message, _combined.as_struct(), _level, _type);
			}
		}
	}
	
	static debug = function(_message, _extras=undefined, _type=undefined) {
		// Create a debug-level log message
		if (LOGGING_DISABLED or not __enable_debug) return;
		logger(LOG_DEBUG, _message, _extras, _type);	
	}
	static info = function(_message, _extras=undefined, _type=undefined) {
		// Create an info-level log message
		if (LOGGING_DISABLED or not __enable_info) return;
		logger(LOG_INFO, _message, _extras, _type);	
	}
	static log = function(_message, _extras=undefined, _type=undefined) {
		// This function exists purely to appease javascript "console.log()" lovers
		if (LOGGING_DISABLED or not __enable_info) return;
		logger(LOG_INFO, _message, _extras, _type);	
	}
	static warning = function(_message, _extras=undefined, _type=undefined) {
		// Create a warning-level log message
		if (LOGGING_DISABLED or not __enable_warning) return;
		logger(LOG_WARNING, _message, _extras, _type);	
	}
	static error = function(_message, _extras=undefined, _type=undefined) {
		// Create an error-level log message
		if (LOGGING_DISABLED or not __enable_error) return;
		
		if (__sentry_send_errors) {
			var _stacktrace = debug_get_callstack();
			array_delete(_stacktrace, 0, 1);
			logger(LOG_ERROR, _message, _extras, _type, _stacktrace);
		}
		else {
			logger(LOG_ERROR, _message, _extras, _type);
		}
	}
	static fatal = function(_message, _extras=undefined, _type=undefined) {
		// Create an fatal-level log message
		if (LOGGING_DISABLED or not __enable_fatal) return;
		logger(LOG_FATAL, _message, _extras, _type);	
	}
	static stacktrace = function(_message, _extras=undefined, _type=undefined) {
		// Log a stacktrace
		if (LOGGING_DISABLED) return;
		var _stacktrace = debug_get_callstack();
		array_delete(_stacktrace, 0, 1);
		logger(LOG_DEBUG, _message, _extras, _type, _stacktrace);	
	}
	static exception = function(_input, _extras=undefined, _level=LOG_ERROR) {
		// logs a GML catch exception, or one of our own Exception structs
		if (LOGGING_DISABLED) return;
	
		var _exception = dunder.exception(_input);
		logger(_level, string(_exception.message), _extras, undefined, _exception.stacktrace);
	}
	
	static bind_named = function(_name, _extras=undefined) {
		// create a new log_output instance with extra bindings
		
		if (LOGGING_DISABLED) return new Logger(_name);
		// combine curretn bound values
		
		var _root_logger = is_undefined(__root_logger) ? self : __root_logger;
		var _new_logger = dunder.init(self.__type__(), _name, bound_values, _root_logger);
		_new_logger.__json_logging = __json_logging;
		
		if (not is_undefined(_extras)) {
			_new_logger.bound_values.update(_extras);
		}
		
		if (not is_undefined(__sentry)) {
			_new_logger.use_sentry(__sentry, __sentry_send_errors);
		}
		
		return _new_logger;
	}
	
	static bind = function(_extras=undefined) {
		// create a new logger instance with extra bindings, but same name
		return bind_named(name, _extras);
	}
	
	static set_level = function(_minimum_log_level=LOG_DEBUG) {
		__enable_fatal = false
		__enable_error = false;
		__enable_warning = false;
		__enable_info = false;
		__enable_debug = false;
		switch(_minimum_log_level) {
			case LOG_DEBUG: __enable_debug = true;
			case LOG_INFO: __enable_info = true;
			case LOG_WARNING: __enable_warning = true;
			case LOG_ERROR: __enable_error = true;
			case LOG_FATAL: __enable_fatal = true;
		}
		return self;
	}
	
	static json_mode = function(_mode=true) {
		// Configure this logger to write logs in json mode
		__json_logging = _mode;
		return self;
	}
	static use_sentry = function(_sentry=undefined, _sentry_send_errors=false) {
		// Attach a sentry instance to logger, to automatically add breadcrumbs
		// and optionally automatically send to sentry on errors
		__sentry = _sentry;
		__sentry_send_errors = _sentry_send_errors;
		return self;
	}
	
	static __string_pad = function(_str, _spaces) {
		var _spaces_to_add = _spaces - string_length(_str);
		
		while(_spaces_to_add >= 8)	{ _spaces_to_add -= 8; _str += "        "; }
		if (_spaces_to_add >= 4)	{ _spaces_to_add -= 4; _str += "    "; }
		if (_spaces_to_add >= 2)	{ _spaces_to_add -= 2; _str += "  "; }
		if (_spaces_to_add == 1)	{ _str += " "; }
		
		return _str;
	}
	
	log_to_file = function(_filename=undefined, _auto_flush=false) {
		if (LOGGING_DISABLED) return;
		close_log()
		
		__auto_flush = _auto_flush;
		
		if (is_undefined(__file)) {
			if (is_undefined(_filename)) {
				_filename = __generate_log_filename();	
			}
			
			__file = dunder.init(DunderFile, _filename).open("a");
		}

		return self;
	}
	
	
	close_log = function() {
		if (LOGGING_DISABLED) return;
		if (not is_undefined(__file)) {
			__file.close();	
		}
	}
	
	__write_line_to_file = function(_output) {
		if (not is_undefined(__file)) {
			__file.write_line(_output);
			if (__auto_flush) {
			__file.flush();
			}
		}
		else if (not is_undefined(__root_logger)) {
			// if I don't have a file handle, but have a root, and use grandparent's output
			__root_logger.__write_line_to_file(_output);
		}
	}
	
	__generate_log_filename = function() {
		var _datetime = dunder.init(DunderDateTime, undefined, "%Y%m%d%H%M%S");	
		var _filename = "log_" + _datetime.__string__() + ".log";
		delete _datetime;
		return _filename;
	}
}
