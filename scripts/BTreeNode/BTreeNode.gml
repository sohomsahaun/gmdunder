function BTreeNode(_degrees, _leaf, _compare) constructor {
	degrees = _degrees;
	leaf = _leaf;
	keys = array_create(2*degrees-1);
	children = array_create(2*degrees);
	num_keys = 0;
	compare = _compare;
		
	static traverse = function() {
	    for (var _idx=0; _idx<num_keys; _idx++) {
	        if (not leaf) {
	            children[_idx].traverse();
			}
	        show_debug_message(keys[_idx]);
	    }
  
	    if (not leaf) {
	        children[_idx].traverse();
		}
	}
		
	static search = function(_key) {
		var _idx = 0;
		while (_idx < num_keys and compare(keys[_idx].key, _key) < 0) {
		    _idx++;
		}
  
		if (_idx < num_keys and compare(keys[_idx].key, _key) == 0) {
		    return keys[_idx];
		}
  
		if (leaf) {
		    return undefined;
		}
  
		// Go to the appropriate child
		return children[_idx].search(_key);
	}
		
	static find_key = function(_key) {
		var _idx=0;
		while (_idx<num_keys and compare(keys[_idx].key, _key) < 0) {
			_idx++;	
		}
		return _idx;
	}
		
	static insert_non_full = function(_key, _value) {
		var _idx = num_keys-1;
		if (leaf) {
		    while (_idx >= 0 and compare(keys[_idx].key, _key) > 0) {
		        keys[_idx+1] = keys[_idx];
		        _idx -= 1;
		    }
		    keys[_idx+1] = new BTreeKey(_key);
			keys[_idx+1].set(_value);
		    num_keys += 1;
		}
		else {
		    while (_idx >= 0 and compare(keys[_idx].key, _key) > 0) {
		        _idx -= 1;
			}
		    if (children[_idx+1].num_keys == 2*degrees-1) {
		        split_child(_idx+1, children[_idx+1]);
		        if (compare(keys[_idx+1].key, _key) < 0) {
		            _idx++;
				}
		    }
		    children[_idx+1].insert_non_full(_key, _value);
		}
	}
		
	static split_child = function(_split_idx, _child) {
		var _new_child = new BTreeNode(_child.degrees, _child.leaf, _child.compare);
		_new_child.num_keys = degrees - 1;
  
		for (var _i=0; _i<degrees-1; _i++) {
		    _new_child.keys[_i] = _child.keys[_i+degrees];	
		}
	
		if (not _child.leaf) {
		    for (var _i=0; _i<degrees; _i++) {
		        _new_child.children[_i] = _child.children[_i+degrees];
			}
		}
  
		_child.num_keys = degrees - 1;
  
		for (var _i=num_keys; _i>=_split_idx; _i--) {
			children[_i+1] = children[_i];
		}
  
		children[_split_idx+1] = _new_child;
  
		for (var _i=num_keys-1; _i>=_split_idx; _i--) {
		    keys[_i+1] = keys[_i];
		}
  
		keys[_split_idx] = _child.keys[degrees-1];
		num_keys += 1;
	}
		
	static remove = function(_key) {
		var _idx = find_key(_key);
		if (_idx < num_keys and compare(keys[_idx].key, _key.key) == 0) {
			if (leaf) {
				remove_from_leaf(_idx);
			}
			else {
				remove_from_non_leaf(_idx);	
			}
		}
		else {
			if (leaf) {
				return	
			}
				
			var _flag = (_idx == num_keys);
				
			if (children[_idx].num_keys < degrees) {
				fill(_idx);	
			}
				
			if (_flag and _idx > num_keys) {
				children[_idx-1].remove(_key);	
			}
			else {
				children[_idx].remove(_key);	
			}
		}
	}
		
	static remove_from_leaf = function(_idx) {
		for (var _i=_idx+1; _i<num_keys; _i++) {
			keys[_i-1] = key[_i];	
		}
		num_keys -= 1;
	}
		
	static remove_from_non_leaf = function(_idx) {
		if (children[_idx].num_keys >= degrees) {
			var _prev = get_previous(_idx);
			keys[_idx] = _prev;
			children[_idx].remove(_prev);
		}
		else if (children[_idx+1].num_keys >= degrees) {
			var _next = get_next(_idx);
			keys[_idx] = _next;
			children[_idx+1].remove(_next);
		}
		else {
			var _key_obj = keys[_idx];
			merge(_idx);
			children[_idx].remove(_key_obj.key);
		}
	}
		
	static get_previous = function(_idx) {
		var _cur = children[_idx+1];
		while(not _cur.leaf) {
			_cur = _cur.children[0];	
		}
		return _cur.keys[0];
	}
		
	static get_next = function(_idx) {
			
	}
		
	static fill = function(_idx) {
		if (_idx != 0 and children[_idx-1].num_keys >= degrees) {
			borrow_previous(_idx);	
		}
		else if (_idx != num_keys and children[_idx+1].num_keys >= degrees) {
			borrow_next(_idx);	
		}
		else {
			if (_idx != num_keys) {
				merge(_idx);
			}
			else {
				merge(_idx-1);	
			}
		}
	}
		
	static borrow_previous = function(_idx) {
		var _child = children[_idx];
		var _sibling = children[_idx-1];
			
		for (var _i=_child.num_keys-1; _i>=0; _i--) {
			_child.keys[_i+1] = _child.keys[_i];	
		}
			
		if (not _child.leaf) {
			for (var _i=_child.num_keys; _i>=0; _i--) {
				_child.children[_i+1] = _child.children[_i];	
			}
		}
			
		_child.keys[0] = keys[_idx-1];
			
		if (not _child.leaf) {
			_child.children[0] = _sibling.children[_sibling.num_keys];	
		}
			
		keys[_idx-1] = _sibling.keys[_sibling.num_keys-1];
			
		_child.num_keys += 1;
		_sibling.num_keys -= 1;
	}
		
	static borrow_next = function(_idx) {
		var _child = children[_idx];
		var _sibling = children[_idx+1];

		_child.keys[_child.num_keys] = keys[_idx];
  
		if (not _child.leaf) {
			_child.children[_child.num_keys + 1] = _sibling.children[0];
		}
			
		keys[_idx] = _sibling.keys[0];
  
		for (var _i=1; _i<_sibling.num_keys; _i++) {
		    _sibling.keys[_i-1] = _sibling.keys[_i];
		}
  
		if (not _sibling.leaf) {
		    for(var _i=1; _i<=_sibling.num_keys; _i++) {
		        _sibling.children[_i-1] = _sibling.children[_i];
			}
		}
  
		_child.num_keys += 1;
		_sibling.num_keys -= 1;
	}
		
	static merge = function(_idx) {
		var _child = children[_idx];
		var _sibling = children[_idx+1];
  
		_child.keys[degrees-1] = keys[_idx];
  
		for (var _i=0; _i<_sibling.num_keys; _i++) {
		    _child.keys[_i+degrees] = _sibling.keys[_i];
		}
			
		if (not _child.leaf) {
		    for(var _i=0; _i<=_sibling.num_keys; _i++) {
		        _child.children[_i+degrees] = _sibling.children[_i];
			}
		}
  
		for (var _i=_idx+1; _i<num_keys; _i++) {
		    keys[_i-1] = keys[_i];
		}
  
		for (var _i=_idx+2; _i<=num_keys; _i++) {
		    children[_i-1] = children[_i];
		}
  
		_child.num_keys += _sibling.num_keys+1;
		num_keys -= 1;
  
		delete _sibling;
		return;
	};

}