function DunderExceptionValueError() : DunderException() constructor {
	// For when type checks fail
	__bases_add__(DunderExceptionValueError);
	static __human_readable_name = "Invalid Value";
}
