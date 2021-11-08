function DunderExceptionIndexError() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionIndexError);
	// For wrapping a gamemaker runtime exception
	static __human_readable_name = "Index Out Of Range Error";
}