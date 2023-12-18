#macro mBHArgumentConcat	var i = 0; var n = [];										\
							repeat(argument_count){ array_push(n, argument[i++]); }		\
							if ( array_length(n) > 0 && is_array(n[0]) ) n = n[0];

enum eBHStatus { Success, Failure, Running }
function __BHTree() constructor {

	mBHArgumentConcat;
	
	root = n;
	static step = function(){
		for ( var i = 0; i<array_length(root); i++ ){
			root[i].evaluate();
		}
	}
	static add = function(_nodeTree){
		array_push(root, _nodeTree);
		return self;
	}
	static selector = function(){
		mBHArgumentConcat;
		add(bh_selector(n));
	}
	static sequence = function(){
		mBHArgumentConcat;
		add(bh_sequence(n));
	}
	
}
function __BHNode(_children=[]) constructor {
	
	name		= "NODE";
	state		= undefined;
	parent		= undefined;
	children	= [];

	evaluate = function(){ 
		return eBHStatus.Failure;	
	}
	static init = function(_children){
		
		array_foreach(_children, function(_node){
			add(_node);
		});
		
	}
	static add = function(_node){
		_node.parent = self;
		array_push(children, _node);
	}
}
function __BHAction(_children=[], _func) : __BHNode(_children) constructor {

	name = "ACTION";
	func = _func;
	evaluate = function(){
		func();
		return eBHStatus.Running;
	}
	init(_children);
	
}
function __BHCondition(_children=[], _func) : __BHNode(_children=[]) constructor {
	
	name = "CONDITION";
	func = _func;
	evaluate = function(){
		var result = func();
		return ( result ? eBHStatus.Success : eBHStatus.Failure );
	}
	init(_children);
}
function __BHSequence(_children=[]) : __BHNode(_children=[]) constructor {
	
	name = "SEQUENCE";
	evaluate = function(){
		var _running = false;	
		for ( var i = 0; i<array_length(children); i++ ){
			var node = children[i];
			switch(node.evaluate()){
				
				case eBHStatus.Failure : 
					state = eBHStatus.Failure;
					return state;
					
				case eBHStatus.Success : 
					continue;
				
				case eBHStatus.Running : 
					_running = true;
					continue;
					
				default : 
					state = eBHStatus.Success;
					return state;
				
			}
		}
		state = ( _running ? eBHStatus.Running : eBHStatus.Success );
		return state;
	}
	init(_children);
}
function __BHSelector(_children=[]) : __BHNode(_children=[]) constructor {
	
	name = "SELECTOR";
	evaluate = function(){
		var _running = false;	
		for ( var i = 0; i<array_length(children); i++ ){
			var node = children[i];
			switch(node.evaluate()){
				
				case eBHStatus.Failure : 
					continue;
					
				case eBHStatus.Success : 
					state = eBHStatus.Success;
					return state;
				
				case eBHStatus.Running : 
					state = eBHStatus.Running;
					return state;
					
				default : continue;
				
			}
		}
		state = eBHStatus.Failure;
		return state;
	}
	init(_children);
}