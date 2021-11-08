function Dunder(_first_room_callback) : DunderGlobal() constructor {
	// Root-level Dunder, contains initialized global-level stuff
	
	static logger = init(DunderLogger);
	static env = init(DunderEnv);
	
	// Inserts the callback object into the first room, which is responsible
	// for firing off the _first_room_callback when the first room is entered.
	// This is necessary because globally-registered objects may not do
	// certain room-related things until actually inside the room
	if (is_method(_first_room_callback)) {
		room_instance_add(room_first, 0, 0, __obj_dunder_init_room);	
		variable_global_set(DUNDER_FIRST_ROOM_GLOBAL, _first_room_callback);
	}
}
