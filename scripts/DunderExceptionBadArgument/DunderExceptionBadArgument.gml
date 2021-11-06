function DunderExceptionBadArgument() : DunderException() constructor {
	// For when the wrong number of arguments provided
	__bases_add__(DunderExceptionBadArgument);
	static __human_readable_name = "Incorrect Arguments Provided";
}
