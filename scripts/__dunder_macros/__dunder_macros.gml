#macro DUNDER_REGISTER_GLOBALS true

if (DUNDER_REGISTER_GLOBALS) {
	globalvar dunder;dunder = new Dunder();
	
	globalvar init;init = method(dunder, dunder.init);
	globalvar del;del = method(dunder, dunder.del);
	globalvar clone;clone = method(dunder, dunder.clone);
	
	globalvar instance;instance = method(dunder, dunder.instance);
	globalvar exception;exception = method(dunder, dunder.exception);
	globalvar range;range = method(dunder, dunder.range);
	globalvar reversed;reversed = method(dunder, dunder.reversed);
	globalvar field;field = method(dunder, dunder.field);
	globalvar init_string;init_string = method(dunder, dunder.init_string);
	globalvar init_dict;init_dict = method(dunder, dunder.init_dict);
	globalvar init_list;init_list = method(dunder, dunder.init_list);
	
	globalvar repr;repr = method(dunder, dunder.repr);
	globalvar as_string;as_string = method(dunder, dunder.as_string);
	globalvar as_boolean;as_boolean = method(dunder, dunder.as_boolean);
	globalvar as_number;as_number = method(dunder, dunder.as_number);
	globalvar as_struct;as_struct = method(dunder, dunder.as_struct);
	globalvar as_array;as_array = method(dunder, dunder.as_array);
	globalvar can_string;can_string = method(dunder, dunder.can_string);
	globalvar can_boolean;can_boolean = method(dunder, dunder.can_boolean);
	globalvar can_number;can_number = method(dunder, dunder.can_number);
	globalvar can_struct;can_struct = method(dunder, dunder.can_struct);
	globalvar can_array;can_array = method(dunder, dunder.can_array);
	
	globalvar add;add = method(dunder, dunder.add);
	globalvar mul;mul = method(dunder, dunder.mul);
	globalvar div_;div_ = method(dunder, dunder.div_);
	globalvar eq;eq = method(dunder, dunder.eq);
	
	globalvar len;len = method(dunder, dunder.len);
	globalvar contains;contains = method(dunder, dunder.contains);
	globalvar get;get = method(dunder, dunder.get);
	globalvar set;set = method(dunder, dunder.set);
	globalvar has;has = method(dunder, dunder.has);
	globalvar remove;remove = method(dunder, dunder.remove);
	
	globalvar iter;iter = method(dunder, dunder.iter);
	globalvar next;next = method(dunder, dunder.next);
	globalvar foreach;foreach = method(dunder, dunder.foreach);
	globalvar map;map = method(dunder, dunder.map);
	globalvar filter;filter = method(dunder, dunder.filter);
	globalvar reduce;reduce = method(dunder, dunder.reduce);
	globalvar all_;all_ = method(dunder, dunder.all_);
	globalvar any;any = method(dunder, dunder.any);
	
	globalvar is_subtype;is_subtype = method(dunder, dunder.is_subtype);
	globalvar is_type;is_type = method(dunder, dunder.is_type);
	globalvar is_exception;is_exception = method(dunder, dunder.is_exception);
	globalvar is_dunder_struct;is_dunder_struct = method(dunder, dunder.is_dunder_struct);
	globalvar is_same_type;is_same_type = method(dunder, dunder.is_same_type);
	globalvar is_struct_with_method;is_struct_with_method = method(dunder, dunder.is_struct_with_method);
	
	globalvar logger;logger = init(DunderLogger, "root");
}

// Log severity levels. These match the sentry level macros. so are interchangeable
#macro LOG_FATAL "fatal"
#macro LOG_ERROR "error"
#macro LOG_WARNING "warning"
#macro LOG_INFO "info"
#macro LOG_DEBUG "debug"

// Setting this to True globally disables logging, causing the logger to do nothing when called
// NOTE: this includes not sending sentry reports, or adding values to the sentry breadcrumbs.
// If you want to turn off log outputs, but still send sentry reports, use set_levels() with
// no arguments
#macro LOGGING_DISABLED false

// Width of the padding used in the output
#macro LOGGING_PAD_WIDTH 48