package ;

import entities.Entity;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
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
	
	var keys:Array<UInt>;
	var nowCoords:IntPoint;
	var minCoords:IntPoint;
	var maxCoords:IntPoint;
	var mapRect:IntRect;
	
	var canvasBD:BitmapData;
	var canvas:Bitmap;
	
	var entities:Array<Entity>;
	
	public function new (seed:Int, lvl:Int) {
		super();
		this.seed = seed;
		this.lvl = lvl;
		generate();
		entities = new Array<Entity>();
		draw();
	}
	
	function generate () {
		R = new Random(seed);
		
		keys = new Array<UInt>();
		nowCoords = new IntPoint();
		minCoords = new IntPoint();
		maxCoords = new IntPoint();
		while (keys.length < lvl - 1) {
			pickKey();
		}
		pickKey(K.UP);//Always end the series on an UP move
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
	
	function draw () {
		// Get map size and starting point
		mapRect = new IntRect();
		mapRect.x = MathLib.iAbs(minCoords.x);
		mapRect.y = MathLib.iAbs(minCoords.y);
		mapRect.w = MathLib.iAbs(minCoords.x) + maxCoords.x + 1;
		mapRect.h = MathLib.iAbs(minCoords.y) + maxCoords.y + 1;
		
		// Create map BitmapData if required
		if (canvasBD != null)	canvasBD.dispose();
		canvasBD = new BitmapData(mapRect.w * TILE_SIZE, mapRect.h * TILE_SIZE, false, 0x76909E);
		// Display map
		if (canvas == null) {
			canvas = new Bitmap(canvasBD);
			addChild(canvas);
		} else {
			canvas.bitmapData = canvasBD;
		}
		canvas.x = (1000 - canvas.width) / 2;
		canvas.y = (1000 - canvas.height) / 2;
		
		// Create map BitmapData
		/*if (mapBD != null)	mapBD.dispose();
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
		mapB.y = (1000 - mapB.height) / 2;*/
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
			//mapBD.setPixel(nowCoords.x, nowCoords.y, 0x333333);
		}
		
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
	
}
