function DunderExceptionNoMethod() : DunderException() constructor {
	// For when a dunder method is not found
	__bases_add__(DunderExceptionNoMethod);
	static __human_readable_name = "No Dunder Method Found";
}
