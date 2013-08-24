package display;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author 01101101
 */

class Frame {
	
	public var spritesheet:BitmapData;
	public var name:String;
	public var uid:String;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	
	/**
	 * @param	?n		name
	 * @param	?id		frame UID
	 * @param	?xPos	x
	 * @param	?yPos	y
	 * @param	?w		width
	 * @param	?h		height
	 */
	public function new (?n:String = "", ?id:String = "", ?xPos:Int = 0, ?yPos:Int = 0, ?w:Int = 1, ?h:Int = 1) {
		name = n;
		uid = id;
		x = xPos;
		y = yPos;
		width = w;
		height = h;
	}
	
	public function fromObject (d:Dynamic) :Void {
		name = d.name;
		uid = d.uid;
		x = d.x;
		y = d.y;
		width = d.width;
		height = d.height;
	}
	
	public function toString () :String {
		return "{name:" + name + ", uid:" + uid + ", x:" + x + ", y:" + y + ", width:" + width + ", height:" + height + "}";
	}
	
}