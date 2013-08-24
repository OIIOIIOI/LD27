package ;

import display.FrameManager;
import flash.display.BitmapData;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
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

class Main {
	
	static function main()
	{
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		//
		FrameManager.store("SPRITES", new SpriteBM(0, 0), Resource.getString("spritesJson"));
		Lib.current.stage.addChild(new Game());
		
	}
	
}
