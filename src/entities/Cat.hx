package entities;
import display.AnimFrame;
import haxe.Log;


/**
 * ...
 * @author 01101101
 */

class Cat extends Entity {
	
	public function new () {
		super();
		// 44 x 46
		setAnim(CatAnim.Front);
		animLoop = true;
		xOffset = -6;
		yOffset = -18;
	}
	
	public function setAnim (a:CatAnim) {
		while (anim.length > 0)	anim.pop();
		switch (a) {
			case CatAnim.Front:
				for (i in 0...4)	anim.push(new AnimFrame("cat_front_01"));
				for (i in 0...4)	anim.push(new AnimFrame("cat_front_03"));
				for (i in 0...4)	anim.push(new AnimFrame("cat_front_04"));
				for (i in 0...4)	anim.push(new AnimFrame("cat_front_02"));
			case CatAnim.Back:
				for (i in 0...4)	anim.push(new AnimFrame("cat_back_01"));
				for (i in 0...4)	anim.push(new AnimFrame("cat_back_03"));
				for (i in 0...4)	anim.push(new AnimFrame("cat_back_04"));
				for (i in 0...4)	anim.push(new AnimFrame("cat_back_02"));
				for (i in 0...4)	anim.push(new AnimFrame("cat_back_04"));
				for (i in 0...3)	anim.push(new AnimFrame("cat_back_03"));
				anim.push(new AnimFrame("cat_back_03", setAnim.bind(CatAnim.Front)));
		}
		animIndex = 0;
	}
	
}

enum CatAnim {
	Front;
	Back;
}