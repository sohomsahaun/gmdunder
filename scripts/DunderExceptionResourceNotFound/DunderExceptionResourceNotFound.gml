function DunderExceptionResourceNotFound() : DunderException() constructor {
	// For when something is not found
	__bases_add__(DunderExceptionResourceNotFound);
	static __human_readable_name = "Resource Not Found";
}