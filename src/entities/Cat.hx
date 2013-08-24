package entities;


/**
 * ...
 * @author 01101101
 */

class Cat extends Entity {
	
	public function new () {
		super();
		anim.push("cat_idle_01");
		animLoop = true;
	}
	
}