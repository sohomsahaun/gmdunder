function DunderExceptionFileError() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionFileError);
	// For when a dunder method is not found
	static __human_readable_name = "File Error";
}
