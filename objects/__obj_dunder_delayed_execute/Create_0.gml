/// This object exists solely to be spawned by the Delayed Execute
// so that it can fire off a callback later

__create__ = function(_alarm, _delayed_call, _logger) {
	delayed_call = _delayed_call;
	logger = _logger;
	alarm[0] = _alarm;
}