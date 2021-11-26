function DunderRoomChanger() : DunderInstance() constructor { REGISTER_SUBTYPE(DunderRoomChanger);
	// changes the room and then runs a callback when the room is reached

	static __init__ = function(_target_room, _callback) {
		if (not room_exists(_target_room)) {
			throw dunder.init(DunderExceptionResourceNotFound, "Could not find room id "+string(_target_room))	
		}
		
		logger = dunder.bind_named_logger("RoomChanger", {target_room: room_get_name(_target_room)});
		
		if (instance_exists(__obj_dunder_room_changer)) {
			logger.warning("Another RoomChange is pending, this will override it");
			instance_destroy(__obj_dunder_room_changer, false);
		}
		
		var _inst = dunder.create_instance(__obj_dunder_room_changer, 0, 0, 0, undefined, [_callback, logger]);
		logger.info("Room change prepared", {start_room: room_get_name(room)})
		room_goto(_target_room);
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" target="+room_get_name(target_room)+">";
	}
}