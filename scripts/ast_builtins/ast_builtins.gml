function ast_builtins(_name) {
	static __builtins = {
		show_debug_message: show_debug_message,
		show_error: show_error,
		show_message: show_message,
		string: string,
	}
	return __builtins[$ _name];
}