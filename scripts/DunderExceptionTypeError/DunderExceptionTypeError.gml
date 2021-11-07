function DunderExceptionTypeError() : DunderException() constructor {
	// For when type checks fail
	__bases_add__(DunderExceptionTypeError);
	static __human_readable_name = "Bad Variable Type";
}
