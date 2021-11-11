function DunderInstance() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderInstance);
	// Wraps a gamemaker object instance, to make it managable as a Dunder Struct

	static __init__ = function(_object=0, _xx=0, _yy=0, _depth=0, _layer=undefined, _create_args=undefined) {
		if (not object_exists(_object)) {
			throw dunder.init(DunderExceptionResourceNotFound, "Could not find object "+string(_object))	
		}
		
		if (not is_undefined(_layer)) {
			instance = instance_create_layer(_xx, _yy, _layer, _object);
		}
		else {
			instance = instance_create_depth(_xx, _yy, _depth, _object);
		}
		instance.dunder = dunder;
		__run_create(_create_args);
	}
	
	static __run_create = function(_create_args) {
		if (variable_instance_exists(instance, "__create__") and is_method(instance.__create__)) {
			with (instance) {
				if (is_array(_create_args)) {
					// we're doing this pyramid of doom because gamemaker has no string_execute_ext for methods
					switch(array_length(_create_args)) {
						case  0: __create__(); break;
						case  1: __create__(_create_args[0]); break;
						case  2: __create__(_create_args[0], _create_args[1]); break;
						case  3: __create__(_create_args[0], _create_args[1], _create_args[2]); break;
						case  4: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3]); break;
						case  5: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4]); break;
						case  6: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5]); break;
						case  7: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6]); break;
						case  8: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6], _create_args[7]); break;
						case  9: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6], _create_args[7], _create_args[8]); break;
						case 10: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6], _create_args[7], _create_args[8], _create_args[9]); break;
						case 11: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6], _create_args[7], _create_args[8], _create_args[9], _create_args[10]); break;
						case 12: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6], _create_args[7], _create_args[8], _create_args[9], _create_args[10], _create_args[11]); break;
						case 13: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6], _create_args[7], _create_args[8], _create_args[9], _create_args[10], _create_args[11], _create_args[12]); break;
						case 14: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6], _create_args[7], _create_args[8], _create_args[9], _create_args[10], _create_args[11], _create_args[12], _create_args[13]); break;
						case 15: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6], _create_args[7], _create_args[8], _create_args[9], _create_args[10], _create_args[11], _create_args[12], _create_args[13], _create_args[14]); break;
						case 16: __create__(_create_args[0], _create_args[1], _create_args[2], _create_args[3], _create_args[4], _create_args[5], _create_args[6], _create_args[7], _create_args[8], _create_args[9], _create_args[10], _create_args[11], _create_args[12], _create_args[13], _create_args[14], _create_args[15]); break;
						default: throw init(DunderExceptionBadArgument, "Init can't accept more than 16 extra arguments");
					}
				}
				else {
					__create__(_create_args);
				}
			}
		}
	}
	
	static __cleanup__ = function() {
		if (instance != noone) {
			instance_destroy(instance, false);
		}
	}
	static __string__ = function() {
		return object_get_name(instance.object_index)+"("+string(instance)+")";
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" instance="+string(instance)+" object='"+object_get_name(instance.object_index)+"'>";
	}
}