function DunderException() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderException);
	// A Dunder-style exception, This is thrown internally
	
	// a nice, human-readable name
	static __human_readable_name = "Exception";
	
	static __init__ = function(_msg="") {
		message = __dunder__.as_string(_msg);
		stacktrace = debug_get_callstack();
		// pops two values off call stack, one is this init, the other is porbably Dunder().init
		array_delete(stacktrace, 0, 2);
	}
	static __string__ = function() {
		return __human_readable_name + ": " + string(message) + "\n" + string(stacktrace);
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+"' message='"+string(message)+"'>";
	}
	static toString = function() {
		// This is gamemaker's default string function. This is needed because
		// when throwing an exception, this wil be run
		return __string__();	
	}
}