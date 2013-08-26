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
	public var running(get, null):Bool;
	
	var tf:TextField;
	
	public function new (frames:Int) {
		super();
		
		this.frames = this.startFrames = frames;
		running = false;
		
		tf = new TextField();
		//tf.border = true;
		tf.embedFonts = true;
		tf.selectable = false;
		tf.width = 200;
		tf.height = 75;
		tf.defaultTextFormat = new TextFormat("GoodDog", 72, 0x9BCA2A, true);
		tf.text = Std.string(format());
		addChild(tf);
	}
	
	public function format () :Float {
		return Std.int((10 - frames / 30) * 100) / 100;
	}
	
	public function start () {
		running = true;
	}
	
	public function stop () {
		running = false;
	}
	
	public function update () {
		if (!running)	return;
		frames--;
		tf.text = Std.string(format());
		if (frames == 0) {
			stop();
			EM.instance.dispatchEvent(new GameEvent(GE.GAME_OVER));
		}
	}
	
	public function penalty (f:Int = 3) {
		if (f < 0)	f = 3;
		while (running && f > 0) {
			update();
			f--;
		}
	}
	
	public function reset () {
		running = false;
		frames = startFrames;
		tf.text = Std.string(format());
	}
	
	function get_running () :Bool { return running; }
	
}