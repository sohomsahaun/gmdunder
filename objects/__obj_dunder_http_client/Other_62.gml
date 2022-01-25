show_debug_message("http");

if (is_method(async_http_handler)) {
	async_http_handler(async_load);
}
