package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;


/**
 * ...
 * @author 01101101
 */

class Test extends Sprite {
	
	var nameTF:TextField;
	var seedTF:TextField;
	var bt:Sprite;
	var tf:TextField;
	
	public function new () {
		super();
		
		nameTF = new TextField();
		nameTF.type = TextFieldType.INPUT;
		nameTF.maxChars = 8;
		nameTF.border = true;
		nameTF.defaultTextFormat = new TextFormat("Arial", 12);
		nameTF.width = 400;
		nameTF.height = 50;
		addChild(nameTF);
		
		seedTF = new TextField();
		seedTF.type = TextFieldType.INPUT;
		seedTF.border = true;
		seedTF.defaultTextFormat = new TextFormat("Arial", 12);
		seedTF.width = 400;
		seedTF.height = 50;
		seedTF.y = 60;
		addChild(seedTF);
		
		bt = new Sprite();
		bt.graphics.beginFill(0);
		bt.graphics.drawRect(0, 0, 40, 40);
		bt.graphics.endFill();
		bt.x = 410;
		bt.buttonMode = true;
		bt.addEventListener(MouseEvent.CLICK, clickHandler);
		addChild(bt);
		
		tf = new TextField();
		tf.border = true;
		tf.defaultTextFormat = new TextFormat("Arial", 12);
		tf.width = 400;
		tf.height = 400;
		tf.y = 120;
		addChild(tf);
		tf.text = "init";
		
		tf.text += "\n" + Lib.current.loaderInfo.parameters;
	}
	
	private function clickHandler (e:MouseEvent) {
		ScoreManager.save(111, 1, 6.523, 42, "bibi");
		/*// Assign a variable name for our URLVariables object
		var variables:URLVariables = new URLVariables();
		// Build the varSend variable
		var varSend:URLRequest = new URLRequest("save.php");
		varSend.method = URLRequestMethod.POST;
		varSend.data = variables;
		tf.text += "\nvarSend: " + varSend;
		// Build the varLoader variable
		var varLoader:URLLoader = new URLLoader();
		varLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
		varLoader.addEventListener(Event.COMPLETE, completeHandler);
		varLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		tf.text += "\nvarLoader: " + varLoader;
		//
		variables.name = nameTF.text;
		variables.seed = seedTF.text;
		// Send the data to the php file
		varLoader.load(varSend);*/
	}
	
	/*private function errorHandler(e:IOErrorEvent):Void {
		tf.text += "\n: " + e.errorID;
	}
	
	private function completeHandler (e:Event) {
		tf.text += "\n:" + e.target.data.r;
	}*/
	
}