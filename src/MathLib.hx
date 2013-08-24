package ;

/**
 * ...
 * @author 01101101
 */

class MathLib {
	
	public static inline function iMax (a:Int, b:Int) :Int {
		return (a < b) ? b : a;
	}
	
	public static inline function iMin (a:Int, b:Int) :Int {
		return (a < b) ? a : b;
	}
	
	public static inline function iAbs (a:Float) :Int {
		return (a < 0) ? Std.int(-a) : Std.int(a);
	}
	
}