#macro DUNDER_REGISTER_GLOBALS true

if (DUNDER_REGISTER_GLOBALS) {
	var _dunder = new Dunder();
	
	globalvar init;init = method(_dunder, _dunder.init);
	globalvar del;del = method(_dunder, _dunder.del);
	globalvar clone;clone = method(_dunder, _dunder.clone);
	
	globalvar instance;instance = method(_dunder, _dunder.instance);
	globalvar exception;exception = method(_dunder, _dunder.exception);
	globalvar range;range = method(_dunder, _dunder.range);
	globalvar reversed;reversed = method(_dunder, _dunder.reversed);
	globalvar field;field = method(_dunder, _dunder.field);
	globalvar init_string;init_string = method(_dunder, _dunder.init_string);
	globalvar init_dict;init_dict = method(_dunder, _dunder.init_dict);
	globalvar init_list;init_list = method(_dunder, _dunder.init_list);
	
	globalvar repr;repr = method(_dunder, _dunder.repr);
	globalvar as_str;as_str = method(_dunder, _dunder.as_str);
	globalvar as_bool;as_bool = method(_dunder, _dunder.as_bool);
	globalvar as_struct;as_struct = method(_dunder, _dunder.as_struct);
	globalvar as_array;as_array = method(_dunder, _dunder.as_array);
	
	globalvar add;add = method(_dunder, _dunder.add);
	globalvar mul;mul = method(_dunder, _dunder.mul);
	globalvar div_;div_ = method(_dunder, _dunder.div_);
	globalvar eq;eq = method(_dunder, _dunder.eq);
	
	globalvar len;len = method(_dunder, _dunder.len);
	globalvar contains;contains = method(_dunder, _dunder.contains);
	globalvar get;get = method(_dunder, _dunder.get);
	globalvar set;set = method(_dunder, _dunder.set);
	globalvar has;has = method(_dunder, _dunder.has);
	globalvar remove;remove = method(_dunder, _dunder.remove);
	
	globalvar iter;iter = method(_dunder, method(_dunder, _dunder.iter));
	globalvar next;next = method(_dunder, method(_dunder, _dunder.next));
	globalvar foreach;foreach = method(_dunder, method(_dunder, _dunder.foreach));
	globalvar map;map = method(_dunder, method(_dunder, _dunder.map));
	globalvar filter;filter = method(_dunder, method(_dunder, _dunder.filter));
	globalvar all_;all_ = method(_dunder, method(_dunder, _dunder.all_));
	globalvar any;any = method(_dunder, method(_dunder, _dunder.any));
	
	globalvar is_subtype;is_subtype = method(_dunder, _dunder.is_subtype);
	globalvar is_type;is_type = method(_dunder, _dunder.is_type);
	globalvar is_exception;is_exception = method(_dunder, _dunder.is_exception);
	globalvar is_dunder_struct;is_dunder_struct = method(_dunder, _dunder.is_dunder_struct);
	globalvar is_same_type;is_same_type = method(_dunder, _dunder.is_same_type);
	globalvar is_struct_with_method;is_struct_with_method = method(_dunder, _dunder.is_struct_with_method);
	
}