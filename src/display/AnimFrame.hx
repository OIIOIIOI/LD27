package display;


/**
 * ...
 * @author 01101101
 */

class AnimFrame {
	
	public var name:String;
	public var action:Void->Void;
	
	public function new (name:String, action:Void->Void = null) {
		this.name = name;
		this.action = action;
	}
	
}