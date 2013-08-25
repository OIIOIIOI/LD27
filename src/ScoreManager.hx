package ;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;


/**
 * ...
 * @author 01101101
 */

class ScoreManager {
	
	static var cbf:Bool->Void;
	
	//static public function save (seed:Int, level:Int, time:Float, moves:Int, name:String = "anon", cb:Bool->Void = null) {
	static public function save (params:Dynamic) {
		
		var vars:URLVariables = new URLVariables();
		
		var req:URLRequest = new URLRequest("save.php");
		req.method = URLRequestMethod.POST;
		req.data = vars;
		
		var loader:URLLoader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.VARIABLES;
		
		vars.seed = params.seed;
		vars.level = params.level;
		vars.time = Std.string(params.time);
		vars.moves = params.moves;
		vars.name = params.name;
		
		//cbf = cb;
		
		loader.addEventListener(Event.COMPLETE, completeHandler);
		loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		loader.load(req);
	}
	
	static function errorHandler (e:IOErrorEvent) {
		//if (cbf != null)	cbf(false);
	}
	
	static function completeHandler (e:Event) {
		//if (e.target.data.r == "error" && cbf != null)	cbf(false);
		//else if (cbf != null)	cbf(true);
	}
	
}