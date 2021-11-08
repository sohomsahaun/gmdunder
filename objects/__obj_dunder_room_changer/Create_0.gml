/// This object exists solely to be spawned by the RoomChanger
// so that it can change the room and fire off the callback

__init__ = function(_room_start_handler) {
	room_start_handler = _room_start_handler;
}