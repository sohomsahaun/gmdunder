function DunderExceptionRuntimeError() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionRuntimeError);
	// For wrapping a gamemaker runtime exception
	static __human_readable_name = "Runtime Error";
	
	static __init__ = function(_err) {
		message = _err.message
		stacktrace = _err.stacktrace
		global.SENTRY_LAST_ERROR = self;
	}
}