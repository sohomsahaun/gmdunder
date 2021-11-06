function DunderExceptionNotImplemented() : DunderException() constructor {
	// For when a dunder method is not found
	__bases_add__(DunderExceptionNotImplemented);
	static __human_readable_name = "Method was not implemented";
}
