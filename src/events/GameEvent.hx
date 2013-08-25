package events;
import entities.Entity;
import flash.events.Event;

/**
 * ...
 * @author 01101101
 */

class GameEvent extends Event {
	
	inline static public var GAME_OVER:String = "game_over";
	inline static public var START_AGAIN:String = "start_again";
	inline static public var TRY_NEW:String = "try_new";
	inline static public var WINDOW_CLOSE:String = "window_close";
	
	public var data:Dynamic;
	
	public function new (type:String, ?_data:Dynamic = null, ?bubbles:Bool = false, ?cancelable:Bool = false) {
		data = _data;
		super(type, bubbles, cancelable);
	}
	
	public override function clone () :GameEvent {
		return new GameEvent(type, data, bubbles, cancelable);
	}
	
	public override function toString () :String {
		return formatToString("GameEvent", "data", "type", "bubbles", "cancelable", "eventPhase");
	}
	
}