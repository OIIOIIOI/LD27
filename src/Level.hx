package ;

import display.FrameManager;
import entities.Countdown;
import entities.Entity;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.Lib;
import flash.ui.Keyboard;
import Main;


/**
 * ...
 * @author 01101101
 */

class Level extends Sprite {
	
	// level = number of moves in the series
	static public var LVL_BONOBO:Int = 15;
	static public var LVL_HUMAN:Int = 40;
	static public var LVL_ROBOT:Int = 90;
	var lvl:Int;
	
	static var MAX_SIZE:Int = 18;// Max height and width of a map
	static var TILE_SIZE:Int = 32;// Pixels in a tile
	
	static var R:Random;
	var seed:Int;
	
	var moves:Array<UInt>;
	var movesIndex:Int;
	
	var nowCoords:IntPoint;
	var minCoords:IntPoint;
	var maxCoords:IntPoint;
	var mapRect:IntRect;
	
	var isDown:Bool;
	var hasEnded:Bool;
	
	var mapBD:BitmapData;
	var canvasBD:BitmapData;
	var canvas:Bitmap;
	
	var entities:Array<Entity>;
	
	var countdown:Countdown;
	
	public function new (seed:Int, lvl:Int) {
		super();
		this.seed = seed;
		this.lvl = lvl;
		//
		entities = new Array<Entity>();
		//
		generate();
		draw();
		//
		start();
	}
	
	function generate () {
		R = new Random(seed);
		
		moves = new Array<UInt>();
		nowCoords = new IntPoint();
		minCoords = new IntPoint();
		maxCoords = new IntPoint();
		while (moves.length < lvl - 1) {
			pickKey();
		}
		pickKey(K.UP);//Always end the series on an UP move
	}
	
	function pickKey (k:UInt = 0) {
		if (k == 0) {
			// Pick a random move
			k = 37 + R.random(3);
			// Prevent the random generation from going over the max height
			if (lvl > MAX_SIZE - 1 && k == K.UP && moves.length > lvl / 4) {// No need to check if the number of moves (lvl) is smaller than the max size
				// If y position is already high enough...
				if (MathLib.iAbs(nowCoords.y) >= Std.int(moves.length / lvl * (MAX_SIZE - 1))) {
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
		moves.push(k);
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
	
	function draw () {
		// Get map size and starting point
		mapRect = new IntRect();
		mapRect.x = MathLib.iAbs(minCoords.x);
		mapRect.y = MathLib.iAbs(minCoords.y);
		mapRect.w = MathLib.iAbs(minCoords.x) + maxCoords.x + 1;
		mapRect.h = MathLib.iAbs(minCoords.y) + maxCoords.y + 1;
		
		// Create map BitmapData if required
		if (mapBD != null)	mapBD.dispose();
		mapBD = new BitmapData(mapRect.w, mapRect.h, false, 0);
		// Apply a pattern
		var s:Shape = new Shape();
		s.graphics.beginBitmapFill(FrameManager.getFrame("pattern_01", "SPRITES"));
		s.graphics.drawRect(0, 0, mapBD.width, mapBD.height);
		s.graphics.endFill();
		mapBD.draw(s);
		// Draw path
		nowCoords.x = mapRect.x;
		nowCoords.y = mapRect.y;
		for (i in 0...moves.length) {
			switch (moves[i]) {
				case K.LEFT:
					nowCoords.x--;
				case K.UP:
					nowCoords.y--;
				case K.RIGHT:
					nowCoords.x++;
				case K.DOWN:
					nowCoords.y++;
			}
			mapBD.setPixel(nowCoords.x, nowCoords.y, 0x80 | mapBD.getPixel(nowCoords.x, nowCoords.y));
		}
		mapBD.setPixel(mapRect.x, mapRect.y, 0xFF | mapBD.getPixel(mapRect.x, mapRect.y));
		
		// Create canvas BitmapData if required
		if (canvasBD != null)	canvasBD.dispose();
		canvasBD = new BitmapData(mapRect.w * TILE_SIZE, mapRect.h * TILE_SIZE, false, 0);
		// Draw level
		for (yy in 0...mapBD.height) {
			for (xx in 0...mapBD.width) {
				Game.TAP.x = xx * TILE_SIZE;
				Game.TAP.y = yy * TILE_SIZE;
				switch (mapBD.getPixel(xx, yy) >> 16) {
					case 0xFF:
						FrameManager.copyFrame(canvasBD, "tile_02", "SPRITES", Game.TAP);
					case 0x00:
						FrameManager.copyFrame(canvasBD, "tile_01", "SPRITES", Game.TAP);
					default:
						continue;
				}
				switch (mapBD.getPixel(xx, yy) & 0xFF) {
					case 0x80, 0xFF:
						continue;
					default:
						FrameManager.copyFrame(canvasBD, "tile_03", "SPRITES", Game.TAP);
				}
			}
		}
		// Display map
		if (canvas == null) {
			canvas = new Bitmap(canvasBD);
			addChild(canvas);
		} else {
			canvas.bitmapData = canvasBD;
		}
		canvas.x = (1000 - canvas.width) / 2;
		canvas.y = (1000 - canvas.height) / 2;
		
		// Display keys
		//displayKeys();
		
		/*progress = 0;
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
		mapBD.setPixel(next.x, next.y, 0x999999);*/
		
		
	}
	
	function start () {
		Game.TICK = 0;
		countdown = new Countdown(300);
		countdown.start();
		
		isDown = false;
		hasEnded = false;
		
		Lib.current.stage.addEventListener(KE.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
		EM.instance.addEventListener(GE.GAME_OVER, stop);
	}
	
	function keyDownHandler (e:KE) {
		// SPACE to restart the level
		if (e.keyCode == K.SPACE)	{
			if (e.shiftKey) {
				seed--;// SHIFT + SPACE to change level
				generate();
				draw();
			}
			stop();
			start();
			return;
		}
		// If a key is already down or if the level is over, return
		if (isDown || hasEnded)	return;
		// If a key has been pressed
		if (e.keyCode == K.UP || e.keyCode == K.LEFT || e.keyCode == K.RIGHT) {
			isDown = true;
			// Progress in the series if the key was correct
			if (e.keyCode == moves[movesIndex]) {
				// Increment progress
				movesIndex++;
				// Move cat
				/*switch (e.keyCode) {
					case K.UP:		nowCoords.y--;
					case K.LEFT:	nowCoords.x--;
					case K.RIGHT:	nowCoords.x++;
				}*/
				// Check victory
				if (movesIndex == moves.length) {
					trace("VICTORY!!!");
					stop();
					return;
				}
				// Move laser
				/*var next:IntPoint = nowCoords.clone();
				switch (keys[movesIndex]) {
					case K.UP:		next.y--;
					case K.LEFT:	next.x--;
					case K.RIGHT:	next.x++;
				}*/
			}
			Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
		}
	}
	
	function keyUpHandler (e:KE) {
		if (isDown)	isDown = false;
	}
	
	public function update () {
		countdown.update();
	}
	
	function stop (e:Event = null) {
		trace("stop level");
		countdown.reset();
		hasEnded = true;
		Lib.current.stage.removeEventListener(KE.KEY_UP, keyUpHandler);
	}
}



















