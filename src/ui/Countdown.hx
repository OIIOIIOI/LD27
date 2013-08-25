package ui;

import events.GameEvent;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import haxe.Log;
import haxe.Timer;
import Main;

/**
 * ...
 * @author 01101101
 */

class Countdown extends Sprite {
	
	public var startFrames:Int;
	public var frames:Int;
	var started:Bool;
	
	var tf:TextField;
	
	public function new (frames:Int) {
		super();
		
		this.frames = this.startFrames = frames;
		started = false;
		
		tf = new TextField();
		tf.embedFonts = true;
		tf.selectable = false;
		tf.width = 200;
		tf.height = 200;
		tf.defaultTextFormat = new TextFormat("GoodDog", 96, 0x333333, true);
		tf.text = Std.string(format());
		addChild(tf);
	}
	
	public function format () :Float {
		return Std.int((10 - frames / 30) * 100) / 100;
		
	}
	
	public function start () {
		started = true;
	}
	
	public function stop () {
		started = false;
	}
	
	public function update () {
		if (!started)	return;
		frames--;
		tf.text = Std.string(format());
		if (frames == 0) {
			stop();
			//Timer.delay(EM.instance.dispatchEvent.bind(new GameEvent(GE.GAME_OVER, false)), 1000);
			EM.instance.dispatchEvent(new GameEvent(GE.GAME_OVER));
		}
	}
	
	public function reset () {
		started = false;
		frames = startFrames;
	}
	
}