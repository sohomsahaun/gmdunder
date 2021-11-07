function DunderExceptionStopIteration() : DunderException() constructor {
	// Used for stopping iteration, not really an exception!
	__bases_add__(DunderExceptionStopIteration);
	static __human_readable_name = "Stop Iteration";
	
	static __init__ = function() {}
}