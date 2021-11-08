function Dunder() : DunderGlobal() constructor {
	// Root-level Dunder, contains initialized global-level stuff
	
	static logger = init(DunderLogger);
	static env = init(DunderEnv);
}
