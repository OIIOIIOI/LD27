package ;

import display.FrameManager;
import events.EventManager;
import events.GameEvent;
import flash.display.BitmapData;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.Resource;

/**
 * ...
 * @author 01101101
 */

@:bitmap("../res/sprites.png") class SpriteBM extends BitmapData {}

typedef K = Keyboard;
typedef KE = KeyboardEvent;
typedef E = Event;
typedef EM = EventManager;
typedef GE = GameEvent;

class Main {
	
	static function main()
	{
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		
		/*trace(17 | 42 << 8 | 33 << 16);
		trace(2173457 >> 16);// R 33
		trace((2173457 >> 8) & 0xFF);// G 42
		trace(2173457 & 0xFF);// B 17*/
		
		//FrameManager.store("SPRITES", new SpriteBM(0, 0), Resource.getString("spritesJson"));
		//Lib.current.stage.addChild(new Game());
		Lib.current.stage.addChild(new Test());
		
	}
	
}
