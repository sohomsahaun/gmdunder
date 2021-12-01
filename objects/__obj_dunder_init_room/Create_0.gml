/// This object exists solely to be spawned by the root instance
// of Dunder, to provide a creation callback to run when it's
// in the first room

var _callback = variable_global_get(DUNDER_FIRST_ROOM_GLOBAL)
if (is_method(_callback)) {
	_callback();
	
	// clear from running again
	variable_global_set(DUNDER_FIRST_ROOM_GLOBAL, undefined);
	
	// Note: this instance will still get spawned again next room start, but shouldn't do anything
	instance_destroy(id, false);
}