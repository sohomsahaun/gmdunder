function DunderInstance() : DunderBaseStruct() constructor {
	// Wraps a gamemaker object instance, to make it managable as a Dunder Struct
	__bases_add__(DunderInstance);
	
	static __init__ = function(_object=0, _xx=0, _yy=0, _depth=0, _layer=undefined, _values=undefined) {
		if (not object_exists(_object)) {
			throw __dunder__.init(DunderExceptionResourceNotFound, "Could not find object "+string(_object))	
		}
		
		if (not is_undefined(_layer)) {
			instance = instance_create_layer(_xx, _yy, _layer, _object);
		}
		else {
			instance = instance_create_depth(_xx, _yy, _depth, _object);
		}
		
		if (variable_instance_exists(instance, "__init__") and is_method(instance.__init__)) {
			with (instance) {
				if (is_array(_values)) {
					// we're doing this pyramid of doom because gamemaker has no string_execute_ext for methods
					switch(array_length(_values)) {
						case  0: __init__(); break;
						case  1: __init__(_values[0]); break;
						case  2: __init__(_values[0], _values[1]); break;
						case  3: __init__(_values[0], _values[1], _values[2]); break;
						case  4: __init__(_values[0], _values[1], _values[2], _values[3]); break;
						case  5: __init__(_values[0], _values[1], _values[2], _values[3], _values[4]); break;
						case  6: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5]); break;
						case  7: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6]); break;
						case  8: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6], _values[7]); break;
						case  9: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6], _values[7], _values[8]); break;
						case 10: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6], _values[7], _values[8], _values[9]); break;
						case 11: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6], _values[7], _values[8], _values[9], _values[10]); break;
						case 12: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6], _values[7], _values[8], _values[9], _values[10], _values[11]); break;
						case 13: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6], _values[7], _values[8], _values[9], _values[10], _values[11], _values[12]); break;
						case 14: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6], _values[7], _values[8], _values[9], _values[10], _values[11], _values[12], _values[13]); break;
						case 15: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6], _values[7], _values[8], _values[9], _values[10], _values[11], _values[12], _values[13], _values[14]); break;
						case 16: __init__(_values[0], _values[1], _values[2], _values[3], _values[4], _values[5], _values[6], _values[7], _values[8], _values[9], _values[10], _values[11], _values[12], _values[13], _values[14], _values[15]); break;
						default: throw init(DunderExceptionBadArgument, "Init can't accept more than 16 extra arguments");
					}
				}
				else {
					__init__(_values);
				}
			}
		}
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