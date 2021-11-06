function DunderExceptionNotStruct() : DunderException() constructor {
	// For when an argument given to Dunder() was expected to be a struct but was not
	__bases_add__(DunderExceptionNotStruct);
	static __human_readable_name = "Not A Struct";
}