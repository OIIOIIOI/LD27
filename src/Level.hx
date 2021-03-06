package ;

import display.FrameManager;
import entities.Basket;
import entities.Cat;
import entities.Entity;
import entities.Laser;
import events.EventManager;
import events.GameEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.Event;
import flash.geom.Point;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.Timer;
import Main;
import ui.Countdown;
import ui.ScoreWindow;
import ui.FocusWindow;


/**
 * ...
 * @author 01101101
 */

class Level extends Sprite {
	
	static public var SEED_MIN:Int = 0;
	static public var SEED_MAX:Int = 999999999;
	
	static public var DIFFICULTY:Array<Int> = [15, 35, 50, 60];
	var lvl:Int;
	
	static var MAX_SIZE:Int = 18;// Max height and width of a map
	static var TILE_SIZE:Int = 32;// Pixels in a tile
	
	
	static var R:Random;
	var seed:Int;
	
	var moves:Array<UInt>;
	var movesIndex:Int;
	var hits:Int;
	
	var nowCoords:IntPoint;
	var minCoords:IntPoint;
	var maxCoords:IntPoint;
	var endCoords:IntPoint;
	var mapRect:IntRect;
	
	var isDown:Bool;
	var hasEnded:Bool;
	
	var mapBD:BitmapData;
	var mapBG:BitmapData;
	var canvasBD:BitmapData;
	var canvas:Bitmap;
	var bg:Shape;
	
	var fxContainer:Sprite;
	
	var entities:Array<Entity>;
	var cat:Cat;
	var basket:Basket;
	var laser:Laser;
	
	var countdown:Countdown;
	var scoreWindow:ScoreWindow;
	var focusWindow:FocusWindow;
	
	public function new (seed:Int, lvl:Int) {
		super();
		this.seed = seed;
		this.lvl = lvl;
		//
		//trace("SEED " + this.seed + ", DIFFICULTY " + this.lvl);
		//
		entities = new Array<Entity>();
		//
		generate();
		draw();
		//
		fxContainer = new Sprite();
		fxContainer.x = canvas.x;
		fxContainer.y = canvas.y;
		addChild(fxContainer);
		new Fx(fxContainer);
		//
		start();
	}
	
	function generate () {
		R = new Random(seed);
		
		moves = new Array<UInt>();
		nowCoords = new IntPoint();
		minCoords = new IntPoint();
		maxCoords = new IntPoint();
		while (moves.length < DIFFICULTY[lvl] - 1) {
			pickKey();
		}
		pickKey(K.UP);//Always end the series on an UP move
	}
	
	function pickKey (k:UInt = 0) {
		if (k == 0) {
			// Pick a random move
			k = 37 + R.random(3);
			// Prevent the random generation from going over the max height
			if (DIFFICULTY[lvl] > MAX_SIZE - 1 && k == K.UP && moves.length > DIFFICULTY[lvl] / 4) {// No need to check if the number of moves is smaller than the max size
				// If y position is already high enough...
				if (MathLib.iAbs(nowCoords.y) >= Std.int(moves.length / DIFFICULTY[lvl] * (MAX_SIZE - 1))) {
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
		
		mapRect.h += 1;
		mapRect.y += 1;
		
		// Create map BitmapData if required
		if (mapBD != null)	mapBD.dispose();
		mapBD = new BitmapData(mapRect.w, mapRect.h, false, 0);
		/*var bmp = new Bitmap(mapBD);
		bmp.scaleX = bmp.scaleY = 16;
		Lib.current.stage.addChild(bmp);*/
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
			if (i < moves.length - 1)	mapBD.setPixel(nowCoords.x, nowCoords.y, 0x80 | mapBD.getPixel(nowCoords.x, nowCoords.y));
		}
		endCoords = nowCoords.clone();
		mapBD.setPixel(mapRect.x, mapRect.y, 0xFF | mapBD.getPixel(mapRect.x, mapRect.y));
		
		// Create map BitmapData if required
		if (mapBG != null)	mapBG.dispose();
		mapBG = new BitmapData(mapRect.w * TILE_SIZE, mapRect.h * TILE_SIZE, false, 0);
		// Draw level
		for (yy in 0...mapBD.height) {
			for (xx in 0...mapBD.width) {
				Game.TAP.x = xx * TILE_SIZE;
				Game.TAP.y = yy * TILE_SIZE;
				switch (mapBD.getPixel(xx, yy) >> 16) {// Isolate red channel
					case 0xA0:
						FrameManager.copyFrame(mapBG, "big_tile_00", "SPRITES", Game.TAP);
					case 0xA1:
						FrameManager.copyFrame(mapBG, "big_tile_01", "SPRITES", Game.TAP);
					case 0xA2:
						FrameManager.copyFrame(mapBG, "big_tile_03", "SPRITES", Game.TAP);
					case 0xA3:
						FrameManager.copyFrame(mapBG, "big_tile_02", "SPRITES", Game.TAP);
					case 0xFF:
						FrameManager.copyFrame(mapBG, "tile_03", "SPRITES", Game.TAP);
					default:
						FrameManager.copyFrame(mapBG, "tile_02", "SPRITES", Game.TAP);
				}
				switch (mapBD.getPixel(xx, yy) & 0xFF) {// Isolate blue channel
					case 0x80, 0xFF:
						FrameManager.copyFrame(mapBG, "tile_01", "SPRITES", Game.TAP);
					default:
						continue;
				}
			}
		}
		
		// Create canvas BitmapData if required
		if (canvasBD != null)	canvasBD.dispose();
		canvasBD = new BitmapData(mapRect.w * TILE_SIZE, mapRect.h * TILE_SIZE, false, 0);
		
		// Display canvas
		if (canvas == null) {
			canvas = new Bitmap(canvasBD);
			
			bg = new Shape();
			Game.drawRect(bg.graphics, 0xBAD277, 1, Std.int(canvas.width + 20), Std.int(canvas.height + 20), -10, -10);
			addChild(bg);
			addChild(canvas);
		} else {
			canvas.bitmapData = canvasBD;
			bg.graphics.clear();
			Game.drawRect(bg.graphics, 0xBAD277, 1, Std.int(canvas.width + 20), Std.int(canvas.height + 20), -10, -10);
		}
		canvas.x = bg.x = (Lib.current.stage.stageWidth - canvas.width) / 2;
		canvas.y = bg.y = (Lib.current.stage.stageHeight - canvas.height) / 2;
	}
	
	function start () {
		Game.TICK = 0;
		
		isDown = false;
		hasEnded = false;
		movesIndex = 0;
		hits = 0;
		
		if (countdown == null) {
			countdown = new Countdown(300);
			countdown.x = 10;
			countdown.y = Lib.current.stage.stageHeight - countdown.height;
			addChild(countdown);
		}
		countdown.reset();
		
		while (entities.length > 0) {
			entities.remove(entities[0]);
		}
		
		basket = new Basket();
		basket.x = basket.xTarget = endCoords.x * TILE_SIZE;
		basket.y = basket.yTarget = endCoords.y * TILE_SIZE;
		entities.push(basket);
		
		laser = new Laser();
		var next:IntPoint = new IntPoint(mapRect.x, mapRect.y);
		switch (moves[movesIndex]) {
			case K.UP:		next.y--;
			case K.LEFT:	next.x--;
			case K.RIGHT:	next.x++;
		}
		laser.x = laser.xTarget = next.x * TILE_SIZE;
		laser.y = laser.yTarget = next.y * TILE_SIZE;
		entities.push(laser);
		
		cat = new Cat();
		cat.x = cat.xTarget = mapRect.x * TILE_SIZE;
		cat.y = cat.yTarget = mapRect.y * TILE_SIZE;
		entities.push(cat);
		
		if (scoreWindow == null) {
			EventManager.instance.addEventListener(GameEvent.START_AGAIN, eventHandler);
			EventManager.instance.addEventListener(GameEvent.WINDOW_CLOSE, eventHandler);
			scoreWindow = new ScoreWindow();
		}
		
		// When the game is loaded for the first time, display the focus window
		if (focusWindow == null) {
			EventManager.instance.addEventListener(GameEvent.GET_FOCUS, eventHandler);
			focusWindow = new FocusWindow();
			addChild(focusWindow);
		}
		// Window not null means there is no need to display the focus window again
		else {
			Lib.current.stage.addEventListener(KE.KEY_DOWN, keyDownHandler);
			Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
			EM.instance.addEventListener(GE.GAME_OVER, deactivate);
		}
	}
	
	private function eventHandler (e:GameEvent) {
		switch (e.type) {
			case GameEvent.START_AGAIN:
				startAgain(seed, lvl);
				
			case GameEvent.GET_FOCUS:
				if (contains(focusWindow))	removeChild(focusWindow);
				Lib.current.stage.addEventListener(KE.KEY_DOWN, keyDownHandler);
				Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
				EM.instance.addEventListener(GE.GAME_OVER, deactivate);
				
			case GameEvent.WINDOW_CLOSE:
				if (contains(scoreWindow))	removeChild(scoreWindow);
				Lib.current.stage.addEventListener(KE.KEY_DOWN, keyDownHandler);
				Lib.current.stage.focus = null;
				
			default:
				return;
		}
	}
	
	function startAgain (s:Int, l:Int) {
		if (s != seed || l != lvl) {
			if (s != seed)	seed = s;
			if (l != lvl)	lvl = l;
			generate();
			draw();
		}
		countdown.reset();
		start();
	}
	
	function keyDownHandler (e:KE) {
		// SPACE to restart the level
		if (e.keyCode == K.SPACE)	{
			//if (e.shiftKey)	startAgain(seed - 1, lvl);
			//else			startAgain(seed, lvl);
			startAgain(seed, lvl);
			return;
		}
		// If a key is already down or if the level is over, return
		if (isDown || hasEnded)	return;
		// If a key has been pressed
		if (e.keyCode == K.UP || e.keyCode == K.LEFT || e.keyCode == K.RIGHT) {
			/// Start timer
			if (!countdown.running)	countdown.start();
			//
			isDown = true;
			hits++;
			// Progress in the series if the key was correct
			if (e.keyCode == moves[movesIndex]) {
				// Increment progress
				movesIndex++;
				// Move cat
				switch (e.keyCode) {
					case K.UP:
						nowCoords.y--;
						cat.yTarget -= TILE_SIZE;
						cat.setAnim(CatAnim.Back);
					case K.LEFT:
						nowCoords.x--;
						cat.xTarget -= TILE_SIZE;
					case K.RIGHT:
						nowCoords.x++;
						cat.xTarget += TILE_SIZE;
				}
				// Check victory
				if (movesIndex == moves.length) {
					
					countdown.stop();
					var time:Float = Std.int((10 - countdown.frames / 30) * 1000) / 1000;
					scoreWindow.setParams(seed, lvl, time, hits);
					
					entities.remove(cat);
					entities.remove(laser);
					basket.setAnim(BasketAnim.Full);
					
					deactivate();
					return;
				}
				// Move laser
				switch (moves[movesIndex]) {
					case K.UP:
						laser.yTarget -= TILE_SIZE;
					case K.LEFT:
						laser.xTarget -= TILE_SIZE;
					case K.RIGHT:
						laser.xTarget += TILE_SIZE;
				}
			} else {
				countdown.penalty();
			}
			Lib.current.stage.addEventListener(KE.KEY_UP, keyUpHandler);
		}
	}
	
	function keyUpHandler (e:KE) {
		if (isDown)	isDown = false;
	}
	
	public function update () {
		// Update FX
		Fx.instance.update();
		// Update countdown
		countdown.update();
		// Update entities
		for (e in entities) {
			e.update();
		}
		// Render
		render();
	}
	
	function render () {
		//canvasBD.fillRect(canvasBD.rect, 0xFF00FF);
		canvasBD.draw(mapBG);
		// Render entities
		for (e in entities) {
			Game.TAP.x = e.x + e.xOffset;
			Game.TAP.y = e.y + e.yOffset;
			FrameManager.copyFrame(canvasBD, e.frameName, "SPRITES", Game.TAP);
		}
	}
	
	function deactivate (e:GameEvent = null) {
		hasEnded = true;
		
		scoreWindow.setMode((e == null), lvl, (movesIndex / moves.length));
		Lib.current.stage.removeEventListener(KE.KEY_DOWN, keyDownHandler);
		Lib.current.stage.removeEventListener(KE.KEY_UP, keyUpHandler);
		
		Timer.delay(stop.bind(e == null), 1500);
	}
	
	function stop (win:Bool) {
		//trace("stop level WIN=" + e.data);
		addChild(scoreWindow);
		
		//countdown.reset();
		//hasEnded = true;
		Lib.current.stage.removeEventListener(KE.KEY_UP, keyUpHandler);
	}
	
}



















