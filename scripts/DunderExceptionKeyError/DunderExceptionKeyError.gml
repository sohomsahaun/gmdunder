function DunderExceptionKeyError() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionKeyError);
	// For when type checks fail
	static __human_readable_name = "Invalid Key";
}
