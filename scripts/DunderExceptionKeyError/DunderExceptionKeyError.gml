function DunderExceptionKeyError() : DunderException() constructor {
	// For when type checks fail
	__bases_add__(DunderExceptionKeyError);
	static __human_readable_name = "Invalid Key";
}
