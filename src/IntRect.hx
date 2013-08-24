package ;

/**
 * ...
 * @author 01101101
 */

class IntRect {
	
	public var x:Int;
	public var y:Int;
	public var w:Int;
	public var h:Int;
	
	public function new (x:Int = 0, y:Int = 0, w:Int = 0, h:Int = 0) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
	
	public function clone () :IntRect {
		return new IntRect(x, y, w, h);
	}
	
	public function toString () {
		return "{x:" + x + ", y:" + y + ", w:" + w + ", h:" + h + "}";
	}
	
}
