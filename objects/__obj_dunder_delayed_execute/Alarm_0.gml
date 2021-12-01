if (is_method(delayed_call)) {
	logger.info("Delayed execute", {delayed_call: delayed_call});
	delayed_call();
	instance_destroy(id, false);
}
