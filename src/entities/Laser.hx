package entities;


/**
 * ...
 * @author 01101101
 */

class Laser extends Entity {
	
	public function new () {
		super();
		anim.push("laser");
	}
	
	override public function update () {
		super.update();
		xOffset = Std.random(2) * 2 - 1;
		yOffset = Std.random(2) * 2 - 1;
	}
	
}
