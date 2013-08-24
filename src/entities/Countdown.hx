package entities;

import events.GameEvent;
import haxe.Log;
import Main;

/**
 * ...
 * @author 01101101
 */

class Countdown extends Entity {
	
	var startFrames:Int;
	var frames:Int;
	var started:Bool;
	
	public function new (frames:Int) {
		super();
		this.frames = this.startFrames = frames;
		started = false;
	}
	
	public function start () {
		started = true;
		trace("TIME " + (Math.floor(frames / 30)));
	}
	
	override public function update () {
		super.update();
		if (!started)	return;
		frames--;
		if (frames % 30 == 0) {
			trace("TIME " + (Math.floor(frames / 30)));
		}
		if (frames == 0) {
			trace("FAIL...");
			EM.instance.dispatchEvent(new GE(GE.GAME_OVER));
		}
	}
	
	public function reset () {
		started = false;
		frames = startFrames;
	}
	
}