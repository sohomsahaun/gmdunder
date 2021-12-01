function DunderDelayedExecute() : DunderInstance() constructor { REGISTER_SUBTYPE(DunderDelayedExecute);
	// runs a callback after some alarm

	static __init__ = function(_steps, _callback) {
		logger = dunder.bind_named_logger("DelayedExecute", {steps: _steps})
		dunder.create_instance(__obj_dunder_delayed_execute, 0, 0, 0, undefined, [_steps, _callback, logger]);
		logger.info("Delayed execute prepared")
	}
}