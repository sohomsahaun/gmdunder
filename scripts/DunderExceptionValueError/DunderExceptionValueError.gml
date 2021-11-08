function DunderExceptionValueError() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionValueError);
	// For when type checks fail
	static __human_readable_name = "Invalid Value";
}
