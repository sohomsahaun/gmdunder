function DunderExceptionBadArgument() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionBadArgument);
	// For when the wrong number of arguments provided
	static __human_readable_name = "Incorrect Arguments Provided";
}
