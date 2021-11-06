function DunderExceptionRuntimeError() : DunderException() constructor {
	// For wrapping a gamemaker runtime exception
	__bases_add__(DunderExceptionRuntimeError);
	static __human_readable_name = "Runtime Error";
	
	static __init__ = function(_err) {
		message = _err.message
		stacktrace = _err.stacktrace
	}
}