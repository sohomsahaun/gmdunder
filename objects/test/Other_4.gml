a = dunder.init_dict({a: 123, b: 234})

show_message(dunder.reduce(a, "", function(_prev, _value, _key) {
	return _prev + _key + "=" + string(_value) + " ";
}));