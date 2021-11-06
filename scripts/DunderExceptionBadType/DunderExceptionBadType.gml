function DunderExceptionBadType() : DunderException() constructor {
	// For when type checks fail
	__bases_add__(DunderExceptionBadType);
	static __human_readable_name = "Bad Variable Type";
}
