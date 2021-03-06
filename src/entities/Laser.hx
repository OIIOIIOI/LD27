package entities;
import display.AnimFrame;


/**
 * ...
 * @author 01101101
 */

class Laser extends Entity {
	
	public function new () {
		super();
		anim.push(new AnimFrame("laser"));
	}
	
	override public function update () {
		var tx:Int = x;
		var ty:Int = y;
		super.update();
		xOffset = Std.random(2) * 2 - 1;
		yOffset = Std.random(2) * 2 - 1;
	}
	
}
