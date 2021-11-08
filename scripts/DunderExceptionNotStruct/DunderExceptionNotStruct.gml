function DunderExceptionNotStruct() : DunderException() constructor { REGISTER_SUBTYPE(DunderExceptionNotStruct);
	// For when an argument given to Dunder() was expected to be a struct but was not
	static __human_readable_name = "Not A Struct";
}