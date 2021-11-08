if (is_method(room_start_handler)) {
	room_start_handler();
	instance_destroy(id, false);
}
