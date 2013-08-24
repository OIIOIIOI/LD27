package ;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.Log;


/**
 * ...
 * @author 01101101
 */

typedef KE = KeyboardEvent;
typedef K = Keyboard;

class Game extends Sprite {
	
	static var DIFF_BONOBO:Int = 15;
	static var DIFF_HUMAN:Int = 40;
	static var DIFF_ROBOT:Int = 90;
	
	static var R:Random;
	static var seed:Int = 10000049;
	
	var frames:Int;
	var hits:Int;
	var isDown:Bool;
	var isAllowed:Bool;
	var keys:Array<UInt>;
	var progress:Int;
	var hasEnded:Bool;
	
	var nowCoords:IntPoint;
	var minCoords:IntPoint;
	var maxCoords:IntPoint;
	var mapRect:IntRect;
	
	var aContainer:Sprite;
	var mapBD:BitmapData;
	var mapB:Bitmap;
	
	public function new () {
		super();
		reset();
	}
	
	function reset () {
		
		Log.clear();
		trace("");
		trace("");
		trace("");
		
		frames = 0;
		hits = 0;
		isDown = false;
		isAllowed = true;
		hasEnded = false;
		
		seed++;
		R = new Random(seed);
		trace(seed);
		
		// Generate path
		keys = new Array<UInt>();
		nowCoords = new IntPoint();
		minCoords = new IntPoint();
		maxCoords = new IntPoint();
		while (keys.length < DIFF_ROBOT) {
			pickKey();
		}
		pickKey(K.UP);
		
		// Get map size and starting point
		mapRect = new IntRect();
		mapRect.x = MathLib.iAbs(minCoords.x);
		mapRect.y = MathLib.iAbs(minCoords.y);
		mapRect.w = MathLib.iAbs(minCoords.x) + maxCoords.x + 1;
		mapRect.h = MathLib.iAbs(minCoords.y) + maxCoords.y + 1;
		trace(mapRect + "(" + (mapRect.x * 16) + "x" + (mapRect.y * 16) + ")");
		
		// Create map BitmapData
		if (mapBD != null)	mapBD.dispose();
		mapBD = new BitmapData(mapRect.w, mapRect.h, false, 0);
		// Display map
		if (mapB == null) {
			mapB = new Bitmap(mapBD);
			mapB.scaleX = mapB.scaleY = 16;
			addChild(mapB);
		} else {
			mapB.bitmapData = mapBD;
		}
		mapB.x = 1000 - mapB.width;
		mapB.y = 1000 - mapB.height;
		// Draw starting point
		mapBD.setPixel(mapRect.x, mapRect.y, 0x00FF00);
		// Draw path
		nowCoords.x = mapRect.x;
		nowCoords.y = mapRect.y;
		for (i in 0...keys.length) {
			// Draw path
			switch (keys[i]) {
				case K.LEFT:
					nowCoords.x--;
				case K.UP:
					nowCoords.y--;
				case K.RIGHT:
					nowCoords.x++;
				case K.DOWN:
					nowCoords.y++;
			}
			mapBD.setPixel(nowCoords.x, nowCoords.y, 0xFF0000);
		}
		
		// Display keys
		displayKeys();
		
		progress = 0;
		
		Lib.current.stage.addEventListener(KE.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
		trace("TIME 10");
	}
	
	function pickKey (k:UInt = 0) {
		if (k == 0) {
			k = 37 + R.random(3);
			
			/*if (k == K.UP) {
				if () {
					
				}
			}*/
		}
		
		keys.push(k);
		
		switch (k) {
			case K.LEFT:
				nowCoords.x--;
				minCoords.x = MathLib.iMin(nowCoords.x, minCoords.x);
			case K.UP:
				nowCoords.y--;
				minCoords.y = MathLib.iMin(nowCoords.y, minCoords.y);
			case K.RIGHT:
				nowCoords.x++;
				maxCoords.x = MathLib.iMax(nowCoords.x, maxCoords.x);
			case K.DOWN:
				nowCoords.y++;
				minCoords.y = MathLib.iMax(nowCoords.y, maxCoords.y);
		}
	}
	
	function displayKeys () {
		/*var s:String = "";
		for (i in 0...keys.length) {
			switch (keys[i]) {
				case K.LEFT:	s += "LEFT";
				case K.UP:		s += "UP";
				case K.RIGHT:	s += "RIGHT";
				case K.DOWN:	s += "DOWN";
			}
			if (i < keys.length - 1)	s += " - ";
		}
		trace(s);*/
		if (aContainer == null) {
			aContainer = new Sprite();
			aContainer.x = 100;
			aContainer.y = 25;
			addChild(aContainer);
		} else {
			while (aContainer.numChildren > 0)	aContainer.removeChildAt(0);
		}
		var xMin:Int = 0;
		var xMax:Int = 0;
		var xNow:Int = 0;
		var yMin:Int = 0;
		var yMax:Int = 0;
		var yNow:Int = 0;
		for (i in 0...keys.length) {
			var a:Arrow = new Arrow(keys[i]);
			a.x = i * (a.width + 2);
			if (i > 0)	a.alpha = 0.6;
			aContainer.addChild(a);
		}
	}
	
	function keyDownHandler (e:KE) {
		if (e.keyCode == K.SPACE)	{
			endSession();
			reset();
			return;
		}
		if (isDown || !isAllowed || hasEnded)	return;
		if (e.keyCode == K.UP || e.keyCode == K.DOWN || e.keyCode == K.LEFT || e.keyCode == K.RIGHT) {
			isDown = true;
			//isAllowed = false;// Comment this to allow more than one keystroke per update
			// Increment total number of keystrokes
			hits++;
			// Progress in the series if needed
			if (e.keyCode == keys[progress]) {
				var a:DisplayObject;
				// Hide current arrow
				try {
					a = aContainer.getChildAt(progress);
					a.alpha = 0.2;
				} catch (e:Error) { }
				// Increment progress
				progress++;
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
				} catch (e:Error) { }
			}
			//trace("++ " + keys + " - isDown: " + isDown + " / isAllowed: " + isAllowed);
			Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
		}
	}
	
	function keyUpHandler (e:KE) {
		if (isDown) {
			isDown = false;
			//trace("isDown: " + isDown);
		}
	}
	
	function update (e:Event) :Void {
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
		isAllowed = true;
		//trace("isAllowed: " + isAllowed);
	}
	
	function endSession () {
		//trace("done -> " + hits);
		hasEnded = true;
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, update);
		//Lib.current.stage.removeEventListener(KE.KEY_DOWN, keyDownHandler);
		Lib.current.stage.removeEventListener(KE.KEY_UP, keyUpHandler);
	}
	
}