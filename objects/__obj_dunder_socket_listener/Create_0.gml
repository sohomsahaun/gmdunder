/// This object exists solely to be spawned by the SocketClient
// so that it is able to send in async networking functions.
// Do not spawn this object by hand, it should be handled and
// destroyed only by SocketClient

__init__ = function(_step_handler, _async_networking_handler) {
	step_handler = _step_handler;
	async_networking_handler = _async_networking_handler;
}