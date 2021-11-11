if (is_method(room_start_handler)) {
	logger.info("Room change complete", {end_room: room_get_name(room)})
	room_start_handler();
	instance_destroy(id, false);
}
