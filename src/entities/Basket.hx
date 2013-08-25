package entities;
import display.AnimFrame;

/**
 * ...
 * @author 01101101
 */

class Basket extends Entity {
	
	public function new () {
		super();
		// 44 x 46
		setAnim(BasketAnim.Empty);
		animLoop = true;
		xOffset = -6;
		yOffset = -18;
	}
	
	public function setAnim (a:BasketAnim) {
		while (anim.length > 0)	anim.pop();
		switch (a) {
			case BasketAnim.Empty:
				for (i in 0...4)	anim.push(new AnimFrame("basket_01"));
				for (i in 0...4)	anim.push(new AnimFrame("basket_02"));
				for (i in 0...4)	anim.push(new AnimFrame("basket_03"));
				for (i in 0...4)	anim.push(new AnimFrame("basket_04"));
			case BasketAnim.Full:
				anim.push(new AnimFrame("cat_zen"));
		}
		animIndex = 0;
	}
	
}

enum BasketAnim {
	Empty;
	Full;
}