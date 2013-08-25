package entities;
import display.AnimFrame;


/**
 * ...
 * @author 01101101
 */

class Entity {
	
	var anim:Array<AnimFrame>;
	var animIndex:Int;
	var animLoop:Bool;
	public var x:Int;
	public var y:Int;
	public var xOffset:Int;
	public var yOffset:Int;
	public var xTarget:Int;
	public var yTarget:Int;
	
	public function new () {
		anim = new Array<AnimFrame>();
		animIndex = 0;
		animLoop = false;
		x = y = 0;
		xOffset = yOffset = 0;
		xTarget = yTarget = 0;
	}
	
	public function update () {
		if (anim.length > 1) {
			animIndex++;
			if (animIndex >= anim.length) {
				animIndex = (!animLoop) ? anim.length - 1 : 0;
			}
			if (anim[animIndex].action != null)	anim[animIndex].action();
		}
		if (xTarget != x) {
			if (Math.abs(xTarget - x) * 0.5 < 1)	x = xTarget;
			else									x += Std.int((xTarget - x) * 0.5);
		}
		if (yTarget != y) {
			if (Math.abs(yTarget - y) * 0.5 < 1)	y = yTarget;
			else									y += Std.int((yTarget - y) * 0.5);
		}
	}
	
	public var frameName (get, null) :String;
	function get_frameName () :String {
		if (anim.length == 0)	return null;
		else					return anim[animIndex].name;
	}
	
}