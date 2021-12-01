function AstParser(_logger=undefined) constructor {
	specials = {}
	context = {
		specials: specials,
		logger: _logger,
		is_breaking: false,
		is_continuing: false,
		is_returning: false,
		return_value: undefined,
	}
	
	static execute = function(_ast, _parent=undefined) {
		context.is_breaking = false;
		context.is_continuing = false;
		context.is_returning = false;
		context.return_value = undefined;
		
		var _scope = _parent ?? {};
		var _ast_node = asset_get_index(_ast.type)
		_ast_node(_ast, context, _scope, 0);
		return context.return_value;
	}
	
	static register_special = function(_ident, _callback) {
		specials[$ _ident] = _callback;
	}
}