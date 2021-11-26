function DunderDateTime() : DunderBaseStruct() constructor { REGISTER_SUBTYPE(DunderDateTime);
	// A Datetime object
	static __init__ = function(_input=undefined, _format="%Y-%m-%dT%H:%M:%S.%fZ", _timezone=timezone_utc) {
		static offset_datetime = undefined;
		static offset_timer = undefined;
		
		timezone = _timezone ?? date_get_timezone();
		
		if (is_undefined(_input)) {
			var _list_timezone = date_get_timezone();
			date_set_timezone(timezone);
			
			// calculate time offsets, to allow us to get millisecond precision
			if (is_undefined(offset_datetime)) {
				offset_datetime = date_current_datetime();
				offset_timer = get_timer();
			}
			
			datetime = offset_datetime + (get_timer() - offset_timer)/86400000000;
			date_set_timezone(_list_timezone);
		}
		else {
			datetime = dunder.as_number(_input);
			microseconds = 0;
		}
		
		format = _format;
		formatted_time = undefined;
	}
	
	// Representation methods
	static __string__ = function() {
		static format_table = undefined;
		
		if (is_undefined(format_table)) {
			format_table = {};
			format_table[$ "%a"] = weekday_name_short;
			format_table[$ "%A"] = weekday_name;
			format_table[$ "%w"] = weekday;
			format_table[$ "%y"] = year_short;
			format_table[$ "%Y"] = year;
			format_table[$ "%b"] = month_name_short;
			format_table[$ "%B"] = month_name;
			format_table[$ "%m"] = month_pad;
			format_table[$ "%d"] = day_pad;
			format_table[$ "%e"] = day;
			format_table[$ "%j"] = day_of_year_pad;
			
			format_table[$ "%l"] = hour;
			format_table[$ "%H"] = hour_24_pad;
			format_table[$ "%I"] = hour_12_pad;
			format_table[$ "%M"] = minute_pad;
			format_table[$ "%S"] = second_pad;
			format_table[$ "%p"] = am_pm;
			format_table[$ "%f"] = millisecond_pad;
			
			format_table[$ "%%"] = literal_percent;
		}
		
		if (not is_undefined(formatted_time)) {
			return formatted_time;
		}
		
		var _tokens = [];
		var _len = string_length(format);
		var _last_pos = 0;
		for (var _i=0; _last_pos<_len; _i++) {
			var _pos = string_pos_ext("%", format, _last_pos);
			if (_pos == 0) {
				break;
			}
			if (_last_pos > 0) {
				array_push(_tokens, string_copy(format, _last_pos, _pos-_last_pos));
			}
			array_push(_tokens, string_copy(format, _pos, 2));
			_last_pos = _pos+2;
		}
		array_push(_tokens, string_copy(format, _last_pos, _len-_last_pos+1));
		
		formatted_time = "";
		var _len = array_length(_tokens);
		for (var _i=0; _i<_len; _i++) {
			var _token = _tokens[_i];
			var _func = format_table[$ _token];
			if (is_method(_func)) {
				formatted_time += _func()
			}
			else {
				formatted_time += _token;
			}
		}
		return formatted_time;
	}
	static __repr__ = function() {
		return "<dunder '"+instanceof(self)+" format='"+format+"'>";
	}
	static toString = function() {
		return __string__();
	}
	static as_string = __string__;
	
	// Date functions
	static set_format = function(_format) {
		format = _format;
		formatted_time = undefined;
		return self;
	}
	static weekday_name_short = function() {
		switch(date_get_weekday(datetime)) {
			case 0: return "Sun";
			case 1: return "Mon";
			case 2: return "Tue";
			case 3: return "Wed";
			case 4: return "Thu";
			case 5: return "Fri";
			case 6: return "Sat";
		}
	}
	static weekday_name = function() {
		switch(date_get_weekday(datetime)) {
			case 0: return "Sunday";
			case 1: return "Monday";
			case 2: return "Tuesday";
			case 3: return "Wednesday";
			case 4: return "Thursday";
			case 5: return "Friday";
			case 6: return "Saturday";
		}
	}
	static weekday = function() {
		return date_get_weekday(datetime);
	}
	static year_short = function() {
		return __zero_pad_string(date_get_year(datetime) % 100, 2);
	}
	static year = function() {
		return __zero_pad_string(date_get_year(datetime), 4);
	}
	static month_name_short = function() {
		switch(date_get_month(datetime)) {
			case 1: return "Jan";
			case 2: return "Feb";
			case 3: return "Mar";
			case 4: return "Apr";
			case 5: return "May";
			case 6: return "Jun";
			case 7: return "Jul";
			case 8: return "Aug";
			case 9: return "Sep";
			case 10: return "Oct";
			case 11: return "Nov";
			case 12: return "Dec";
		}
	}
	static month_name = function() {
		switch(date_get_month(datetime)) {
			case 1: return "January";
			case 2: return "Febuary";
			case 3: return "March";
			case 4: return "Aprril";
			case 5: return "May";
			case 6: return "June";
			case 7: return "July";
			case 8: return "August";
			case 9: return "September";
			case 10: return "October";
			case 11: return "November";
			case 12: return "December";
		}
	}
	static month_pad = function() {
		return __zero_pad_string(date_get_month(datetime), 2);
	}
	static day_pad = function() {
		return __zero_pad_string(date_get_day(datetime), 2);
	}
	static day = function() {
		return string(date_get_day(datetime));
	}
	static day_of_year_pad = function() {
		return __zero_pad_string(date_get_day_of_year(datetime), 3);
	}
	
	static hour = function() {
		return string(date_get_hour(datetime));
	}
	static hour_24_pad = function() {
		return __zero_pad_string(date_get_hour(datetime), 2);
	}
	static hour_12_pad = function() {
		return __zero_pad_string(((date_get_hour(datetime)-1) % 12)+1, 2);
	}
	static minute_pad = function() {
		return __zero_pad_string(date_get_minute(datetime), 2);
	}
	static second_pad = function() {
		return __zero_pad_string(date_get_second(datetime), 2);
	}
	static am_pm = function() {
		return (date_get_hour(datetime) < 12 ? "AM" : "PM");
	}
	
	
	static millisecond_pad = function() {
		return __zero_pad_string(floor(datetime * 86400000) mod 1000, 3);
	}
	static literal_percent = function() {
		return "%";
	}
	
	static __zero_pad_string = function(_number, _places) {
		return string_replace_all(string_format(_number, _places, 0), " ", "0");
	}
}