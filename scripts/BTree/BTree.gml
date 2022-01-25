function BTree(_compare=undefined, _degrees=3) constructor {
	root = undefined;
	degrees = _degrees;
	compare = is_undefined(_compare) ? function(_a, _b) { return sign(_a - _b); } : _compare;
	
	static clear = function() {
		root = undefined;	
	}
	
	static traverse = function() {
		if (is_undefined(root)) {
			return undefined;
		}
		show_debug_message("begin traverse");
		root.traverse();
	}
	
	static get_existing_key = function(_key) {
		if (is_undefined(root)) {
			return undefined;
		}
		return root.search(_key);
	}
	
	static get_key_values = function(_key) {
		var _key_obj = get_existing_key(_key);
		if (is_undefined(_key_obj)) {
			return undefined;	
		}
		return _key_obj.values();
	}
		
	static insert = function(_key, _value) {
		// try to find existing to append;
		var _existing_key_obj = get_existing_key(_key);
		if (not is_undefined(_existing_key_obj)) {
			_existing_key_obj.set(_value);
			return;
		}
		
		if (is_undefined(root)) {
			root = new BTreeNode(degrees, true, compare);
			root.keys[0] = new BTreeKey(_key);
			root.keys[0].set(_value);
			root.num_keys = 1
		}
		else {
			if (root.num_keys == 2*degrees-1) {
				var _new_root = new BTreeNode(degrees, false, compare);
			    _new_root.children[0] = root;
			    _new_root.split_child(0, root);
			        
				var _i = (compare(_new_root.keys[0].key, _key) < 0) ? 1 : 0;
			    _new_root.children[_i].insert_non_full(_key, _value);
			    root = _new_root;
			}
			else {
			    root.insert_non_full(_key, _value);
			}
		}
	}
		
	static remove = function(_key, _value) {
		if (is_undefined(root)) {
			return;
		}
		
		var _existing_key_obj = get_existing_key(_key);
		if (not is_undefined(_existing_key_obj) and _existing_key_obj.has(_value)) {
			_existing_key_obj.remove(_value);
			if (_existing_key_obj.length() > 0) {
				return;
			}
			
			root.remove(_key);
  
			// If the root node has 0 keys, make its first child as the new root
			//  if it has a child, otherwise set root as NULL
			if (root.num_keys == 0) {
				var _old_root = root;
				
				if (root.leaf) {
				    root = undefined;
				}
				else {
				    root = root.children[0];
				}
  
				delete _old_root;
			}
		}
		
		return;
	}
}
