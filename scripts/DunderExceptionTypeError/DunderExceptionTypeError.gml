function DunderExceptionTypeError() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionTypeError);
	// For when type checks fail
	static __human_readable_name = "Bad Variable Type";
}
