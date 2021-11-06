b = init_dict({a: 1, b: 2, c: 3, d: 4});

foreach(b, function(_key, _value) {
	show_debug_message(_key)	
	show_debug_message(_value)	
})

