function DunderRoomChanger() : DunderInstance() constructor { REGISTER_SUBTYPE(DunderRoomChanger);
	// changes the room and then runs a callback when the room is reached

	static __init__ = function(_target_room, _callback) {
		if (not room_exists(_target_room)) {
			throw __dunder__.init(DunderExceptionResourceNotFound, "Could not find room id "+string(_target_room))	
		}
		
		var _inst = __dunder__.init_instance(__obj_dunder_room_changer, 0, 0, 0, undefined, [_callback]);
		room_goto(_target_room);
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" target="+room_get_name(target_room)+">";
	}
}