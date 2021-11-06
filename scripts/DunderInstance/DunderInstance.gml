function DunderInstance() : DunderBaseStruct() constructor {
	// Wraps a gamemaker object instance, to make it managable as a Dunder Struct
	__bases_add__(DunderInstance);
	
	static __init__ = function(_inst, _values) {
		instance = _inst;
	}
	static destroy = function() {
		instance_destroy(instance);
		instance = noone;
	}
	static __del__ = function() {
		if (instance != noone) {
			instance_destroy(instance, false);
		}
	}
	static __str__ = function() {
		return object_get_name(instance.object_index)+"("+string(instance)+")";
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" instance="+string(instance)+" object='"+object_get_name(instance.object_index)+"'>";
	}
}