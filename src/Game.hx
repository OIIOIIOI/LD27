package ;

import display.FrameManager;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.Log;


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
		
		level = new Level(123456789, Level.LVL_HUMAN);
		addChild(level);
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event) :Void {
		// Increment tick
		TICK++;
		// Update level
		level.update();
		/*// Timer display
		if (TICK % 30 == 0) {
			trace("TIME " + (10 - Math.floor(TICK / 30)));
		}
		// Check session end
		if (TICK >= 300) {
			trace("FAIL...");
			endSession();
			return;
		}*/
	}
	
}