package ;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.Lib;


/**
 * ...
 * @author 01101101
 */

class Game extends Sprite {
	
	static public var TAP:Point = new Point();
	static public var TICK:Int = 0;
	
	var level:Level;
	
	public function new () {
		super();
		
		// Get flashvars
		var params = Lib.current.loaderInfo.parameters;
		// Get seed
		var s:Int = Std.random(Level.SEED_MAX);
		if (params.s != null && Std.parseInt(params.s) >= Level.SEED_MIN && Std.parseInt(params.s) <= Level.SEED_MAX)
			s = Std.parseInt(params.s);
		//else trace("Invalid or missing parameter. A new random seed was chosen: " + s);
		// Get level
		var l:Int = 1;
		if (params.l != null && Std.parseInt(params.l) >= 0 && Std.parseInt(params.l) < Level.DIFFICULTY.length)
			l = Std.parseInt(params.l);
		//else trace("Invalid or missing parameter. Difficulty was set to " + l + ".");
		
		level = new Level(s, l);
		addChild(level);
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event) :Void {
		// Increment tick
		TICK++;
		// Update level
		level.update();
	}
	
	static public function drawRect (target:Graphics, color:UInt, alpha:Float = 1, w:Int = 100, h:Int = 100, x:Int = 0, y:Int = 0) {
		target.beginFill(color, alpha);
		target.drawRect(x, y, w, h);
		target.endFill();
	}
	
}