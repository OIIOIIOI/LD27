package ;

/**
 * ...
 * @author 01101101
 */

class IntPoint {
	
	public var x:Int;
	public var y:Int;
	
	public function new (x:Int = 0, y:Int = 0) {
		this.x = x;
		this.y = y;
	}
	
	public function clone () :IntPoint {
		return new IntPoint(x, y);
	}
	
	public function toString () {
		return "{x:" + x + ", y:" + y + "}";
	}
	
}
