function DunderExceptionStopIteration() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionStopIteration);
	// Used for stopping iteration, not really an exception!
	static __human_readable_name = "Stop Iteration";
	static __init__ = function() {}
	static __string__ = function() {
		return __human_readable_name;
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+"'>";
	}
}