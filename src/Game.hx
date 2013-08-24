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
	
	// level = number of moves in the series
	static var LVL_BONOBO:Int = 15;
	static var LVL_HUMAN:Int = 40;
	static var LVL_ROBOT:Int = 90;
	var lvl:Int;
	
	static var MAX_SIZE:Int = 18;// Max height and width of a map
	static var TILE_SIZE:Int = 16;// Pixels in a tile
	static var SCALE:Int = 2;// Scale for displaying tiles
	
	static var R:Random;
	static var seed:Int = 10000000;
	
	var frames:Int;
	var hits:Int;
	var isDown:Bool;
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
		seed += Std.random(9999);
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
		hasEnded = false;
		
		R = new Random(seed);
		trace(seed);
		
		// Generate path
		//lvl = LVL_ROBOT;
		lvl = LVL_HUMAN;
		//lvl = LVL_BONOBO;
		keys = new Array<UInt>();
		nowCoords = new IntPoint();
		minCoords = new IntPoint();
		maxCoords = new IntPoint();
		while (keys.length < lvl - 1) {
			pickKey();
		}
		pickKey(K.UP);//Always end the series on an UP move
		
		// Get map size and starting point
		mapRect = new IntRect();
		mapRect.x = MathLib.iAbs(minCoords.x);
		mapRect.y = MathLib.iAbs(minCoords.y);
		mapRect.w = MathLib.iAbs(minCoords.x) + maxCoords.x + 1;
		mapRect.h = MathLib.iAbs(minCoords.y) + maxCoords.y + 1;
		
		// Create map BitmapData
		if (mapBD != null)	mapBD.dispose();
		mapBD = new BitmapData(mapRect.w, mapRect.h, false, 0);
		// Display map
		if (mapB == null) {
			mapB = new Bitmap(mapBD);
			mapB.scaleX = mapB.scaleY = TILE_SIZE * SCALE;
			addChild(mapB);
		} else {
			mapB.bitmapData = mapBD;
		}
		mapB.x = (1000 - mapB.width) / 2;
		mapB.y = (1000 - mapB.height) / 2;
		//trace(mapRect.w + " x " + mapRect.h);
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
			mapBD.setPixel(nowCoords.x, nowCoords.y, 0x333333);
		}
		
		// Display keys
		displayKeys();
		
		progress = 0;
		nowCoords.x = mapRect.x;
		nowCoords.y = mapRect.y;
		// Draw starting point
		mapBD.setPixel(nowCoords.x, nowCoords.y, 0x00FF00);
		// Highlight next position
		var next:IntPoint = nowCoords.clone();
		switch (keys[progress]) {
			case K.UP:		next.y--;
			case K.LEFT:	next.x--;
			case K.RIGHT:	next.x++;
		}
		mapBD.setPixel(next.x, next.y, 0x999999);
		
		Lib.current.stage.addEventListener(KE.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
		trace("TIME 10");
	}
	
	function pickKey (k:UInt = 0) {
		if (k == 0) {
			// Pick a random move
			k = 37 + R.random(3);
			// Prevent the random generation from going over the max height
			if (lvl > MAX_SIZE - 1 && k == K.UP && keys.length > lvl / 4) {// No need to check if the number of moves (lvl) is smaller than the max size
				// If y position is already high enough...
				if (MathLib.iAbs(nowCoords.y) >= Std.int(keys.length / lvl * (MAX_SIZE - 1))) {
					// ...cancel the UP move for now
					//trace("cancel UP move");
					pickKey();
					return;
				}
			}
			// If x position is at the minimum and a LEFT move was picked but the max width is already reached...
			if (nowCoords.x == minCoords.x && k == K.LEFT && MathLib.iAbs(minCoords.x) + maxCoords.x + 1 >= MAX_SIZE) {
				// ...cancel the LEFT move
				//trace("cancel LEFT move");
				pickKey();
				return;
			}
			// If x position is at the maximum and a RIGHT move was picked but the max width is already reached...
			if (nowCoords.x == maxCoords.x && k == K.RIGHT && MathLib.iAbs(minCoords.x) + maxCoords.x + 1 >= MAX_SIZE) {
				// ...cancel the RIGHT move
				//trace("cancel RIGHT move");
				pickKey();
				return;
			}
		}
		// Store move
		keys.push(k);
		// Update coords
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
	}
	
	function keyDownHandler (e:KE) {
		if (e.keyCode == K.SPACE)	{
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
	}
	
	function endSession () {
		//trace("done -> " + hits);
		hasEnded = true;
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, update);
		//Lib.current.stage.removeEventListener(KE.KEY_DOWN, keyDownHandler);
		Lib.current.stage.removeEventListener(KE.KEY_UP, keyUpHandler);
	}
	
}