package entities;


/**
 * ...
 * @author 01101101
 */

class Entity {
	
	var anim:Array<String>;
	var animIndex:Int;
	var animLoop:Bool;
	
	public function new () {
		anim = new Array<String>();
		animIndex = 0;
		animLoop = false;
	}
	
	public function update () {
		if (anim.length > 1) {
			animIndex++;
			if (animIndex >= anim.length) {
				animIndex = (!animLoop) ? anim.length - 1 : 0;
			}
		}
	}
	
	public var frameName (get, null) :String;
	function get_frameName () :String {
		if (anim.length == 0)	return null;
		else					return anim[animIndex];
	}
	
}