function DunderExceptionFileError() : DunderException() constructor {
	// For when a dunder method is not found
	__bases_add__(DunderExceptionFileError);
	static __human_readable_name = "File Error";
}
