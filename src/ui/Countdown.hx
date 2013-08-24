package ui;

import events.GameEvent;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import haxe.Log;
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
		tf.width = 160;
		tf.height = 60;
		tf.defaultTextFormat = new TextFormat("Arial", 48, 0xFF0000, true);
		tf.text = Std.string(format()) + "s";
		addChild(tf);
	}
	
	public function format () :Float {
		return Std.int((frames / 30) * 1000) / 1000;
	}
	
	public function start () {
		started = true;
	}
	
	public function update () {
		if (!started)	return;
		frames--;
		tf.text = Std.string(format()) + "s";
		if (frames == 0) {
			EM.instance.dispatchEvent(new GE(GE.GAME_OVER));
		}
	}
	
	public function reset () {
		started = false;
		frames = startFrames;
	}
	
}