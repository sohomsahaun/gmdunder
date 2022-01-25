/// This object exists solely to be spawned by the http client
// so that it is able to send in async networking functions.
// Do not spawn this object by hand, it should be handled and
// destroyed only by HttpClient

__create__ = function(_step_handler, _async_http_handler) {
	step_handler = _step_handler;
	async_http_handler = _async_http_handler;
}