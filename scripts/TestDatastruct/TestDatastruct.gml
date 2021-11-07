function TestDatastruct() : DunderDataStruct() constructor {
	// A managed data struct
	__bases_add__(TestDatastruct);

	abc = field(undefined, undefined, function(_value) { return _value == 3 }).required()
	def = field(, function() { return 3 })
}