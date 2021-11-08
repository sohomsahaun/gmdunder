function DunderExceptionNotImplemented() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionNotImplemented);
	// For when a dunder method is not found
	static __human_readable_name = "Method was not implemented";
}
