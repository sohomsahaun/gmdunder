## Dunders


### `dunder.del(_dunder)`
Runs the dunder's `__del__()` method, and also calls GML `delete` on it

### `dunder.init(_dunder_contructor, _value)`
Will create a dunder struct using its constructor, and call its `__init__()` method with the provided argument(s).

```gml
var _inst = dunder.create(Thing, {a: 123, b: 456})
```

Note: only supports up to 15 additional arguments.



### `dunder.is_exception(_exception)`
Runs `true` if `_exception` is `DunderExecption` or any of its descendents (relying on correct resolution of `__bases__` to work)


### `__bases__`
If you use the line `__bases_add__(StructName);` at the top of every struct, it will construct the inheritance inside `__bases__`


### `__bases_add__()`
Use the line `__bases_add__(StructName);` at the top of every struct to properly create the inheritance array `__bases__`

```gml
function ChildStruct() : DunderBase() constructor {
    __bases_add__(ChildStruct);
}
```

### `__bases_len__`
Simply the length of the `__bases__` array, to facilitate iteration through it.


### `__del__()`
Facilitates any deletion activities. Note this is not run automatically, it must be run by hand

```gml
__init__ = function(_values) {

}
```


### `__init__()`
Used for initializing a struct or instance

```gml
__init__ = function(_values) {

}
```

### `__repr__()`
For returning a human-readable representation of the struct.

```gml
__repr__ = function() {
	return "<dunder '"+instanceof(self)+"' message='"+string(message)+"'>";
}
```

### `__str__()`
For returning a string representation of the struct.

```gml
__str__ = function() {
  return json_stringify(self);
}
```

