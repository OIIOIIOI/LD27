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
	
	var frames:Int;
	var hits:Int;
	var isDown:Bool;
	var progress:Int;
	var hasEnded:Bool;
	
	var aContainer:Sprite;
	var mapBD:BitmapData;
	var mapB:Bitmap;
	
	public function new () {
		super();
		var l:Level = new Level(123456789 - Std.random(99), Level.LVL_HUMAN);
		addChild(l);
		//reset();
	}
	
	/*function reset () {
		
		Log.clear();
		trace("");
		trace("");
		trace("");
		
		frames = 0;
		hits = 0;
		isDown = false;
		hasEnded = false;
		
		R = new Random(seed);
		trace(seed);
		
		// Generate path
		//lvl = LVL_ROBOT;
		lvl = LVL_HUMAN;
		//lvl = LVL_BONOBO;
		
		
		Lib.current.stage.addEventListener(KE.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
		trace("TIME 10");
	}*/
	
	/*function displayKeys () {
		// Create or clean the container
		if (aContainer == null) {
			aContainer = new Sprite();
			aContainer.x = 100;
			aContainer.y = 25;
			addChild(aContainer);
		} else {
			while (aContainer.numChildren > 0)	aContainer.removeChildAt(0);
		}
		// Add an arrow object for each move
		for (i in 0...keys.length) {
			var a:Arrow = new Arrow(keys[i]);
			a.x = i * (a.width + 2);
			if (i > 0)	a.alpha = 0.6;
			aContainer.addChild(a);
		}
	}*/
	
	/*function keyDownHandler (e:KE) {
		if (e.keyCode == K.SPACE)	{
			if (e.shiftKey)	seed++;
			endSession();
			reset();
			return;
		}
		if (isDown || hasEnded)	return;
		if (e.keyCode == K.UP || e.keyCode == K.LEFT || e.keyCode == K.RIGHT) {
			isDown = true;
			// Increment total number of keystrokes
			hits++;
			// Progress in the series if needed
			if (e.keyCode == keys[progress]) {
				var a:DisplayObject;
				// Hide current arrow
				try {
					a = aContainer.getChildAt(progress);
					a.alpha = 0.2;
				} catch (er:Error) { }
				// Hide current position
				mapBD.setPixel(nowCoords.x, nowCoords.y, 0x333333);
				// Increment progress
				progress++;
				// Show new position
				switch (e.keyCode) {
					case K.UP:		nowCoords.y--;
					case K.LEFT:	nowCoords.x--;
					case K.RIGHT:	nowCoords.x++;
				}
				mapBD.setPixel(nowCoords.x, nowCoords.y, 0x00FF00);
				// Check victory
				if (progress == keys.length) {
					trace("VICTORY!!!");
					endSession();
					return;
				}
				// Highlight next arrow
				try {
					a = aContainer.getChildAt(progress);
					a.alpha = 1;
				} catch (er:Error) { }
				// Highlight next position
				var next:IntPoint = nowCoords.clone();
				switch (keys[progress]) {
					case K.UP:		next.y--;
					case K.LEFT:	next.x--;
					case K.RIGHT:	next.x++;
				}
				mapBD.setPixel(next.x, next.y, 0x999999);
			}
			Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
		}
	}*/
	
	/*function keyUpHandler (e:KE) {
		if (isDown) {
			isDown = false;
			//trace("isDown: " + isDown);
		}
	}*/
	
	/*function update (e:Event) :Void {
		frames++;
		// Timer display
		if (frames % 30 == 0) {
			trace("TIME " + (10 - Math.floor(frames / 30)));
		}
		// Check session end
		if (frames >= 300) {
			trace("FAIL...");
			endSession();
			return;
		}
	}*/
	
	/*function endSession () {
		//trace("done -> " + hits);
		hasEnded = true;
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, update);
		//Lib.current.stage.removeEventListener(KE.KEY_DOWN, keyDownHandler);
		Lib.current.stage.removeEventListener(KE.KEY_UP, keyUpHandler);
	}*/
	
}