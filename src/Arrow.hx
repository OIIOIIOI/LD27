package ;

import flash.display.Shape;
import flash.display.Sprite;
import Game;


/**
 * ...
 * @author 01101101
 */

class Arrow extends Sprite {
	
	static var SIZE:Int = 20;
	var shape:Shape;
	
	public function new (dir:UInt) {
		super();
		
		shape = new Shape();
		shape.graphics.beginFill(0x000000);
		shape.graphics.drawRect(-SIZE/2, -SIZE/2, SIZE, SIZE);
		shape.graphics.endFill();
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.moveTo(0, -SIZE/4);
		shape.graphics.lineTo(SIZE/4, SIZE/4);
		shape.graphics.lineTo(-SIZE/4, SIZE/4);
		shape.graphics.lineTo(0, -SIZE/4);
		shape.graphics.endFill();
		
		shape.rotation = switch (dir) {
			case K.LEFT:	-90;
			case K.RIGHT:	90;
			case K.DOWN:	180;
			default:		0;
		}
		
		addChild(shape);
	}
	
}