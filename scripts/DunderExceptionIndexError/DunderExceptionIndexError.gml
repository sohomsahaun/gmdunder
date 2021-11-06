function DunderExceptionIndexError() : DunderException() constructor {
	// For wrapping a gamemaker runtime exception
	__bases_add__(DunderExceptionIndexError);
	static __human_readable_name = "Index Out Of Range Error";
}