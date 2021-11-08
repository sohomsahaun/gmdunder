function DunderExceptionNoMethod() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionNoMethod);
	// For when a dunder method is not found
	static __human_readable_name = "No Dunder Method Found";
}
