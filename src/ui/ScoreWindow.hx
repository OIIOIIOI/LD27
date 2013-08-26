package ui;

import events.EventManager;
import events.GameEvent;
import flash.display.Shape;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import haxe.Timer;

/**
 * ...
 * @author 01101101
 */

class ScoreWindow extends Sprite {
	
	static var DEFAULT_NAME:String = "ENTER_YOUR_NAME";
	
	var win:Bool;
	
	var black:Sprite;
	var window:Sprite;
	var bg:Shape;
	
	var titleTF:TextField;
	var contentTF:TextField;
	var nameTF:TextField;
	var submitButton:Button;
	var mainButton:Button;
	var secondButton:Button;
	
	var params:Dynamic;
	var ready:Bool;
	
	var flevel:Int;
	
	public function new () {
		super();
		
		ready = false;
		
		black = new Sprite();
		Game.drawRect(black.graphics, 0x5D7521, 0.8, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		addChild(black);
		
		window = new Sprite();
		Game.drawRect(window.graphics, 0xFFFFFF, 1, 500, 280);
		window.x = (Lib.current.stage.stageWidth- window.width) / 2;
		window.y = (Lib.current.stage.stageHeight- window.height) / 2;
		addChild(window);
		
		titleTF = new TextField();
		titleTF.selectable = false;
		titleTF.defaultTextFormat = new TextFormat("GoodDog", 42, 0x5D7521, true, false, false, null, null, TextFormatAlign.CENTER);
		titleTF.width = window.width;
		titleTF.height = 50;
		titleTF.x = 0;
		titleTF.y = 20;
		
		nameTF = new TextField();
		nameTF.type = TextFieldType.INPUT;
		nameTF.selectable = true;
		nameTF.alwaysShowSelection = true;
		nameTF.maxChars = 16;
		//nameTF.border = true;
		nameTF.background = true;
		nameTF.backgroundColor = 0xD7E5B0;
		nameTF.defaultTextFormat = new TextFormat("Arial", 20, 0x5D7521, true, false, false, null, null, TextFormatAlign.CENTER);
		nameTF.restrict = "A-Z0-9_. \\-";
		nameTF.width = 290;
		nameTF.height = 35;
		nameTF.x = 25;
		nameTF.y = titleTF.y + titleTF.height + 20;
		if (Game.SO.data.username != null && Game.SO.data.username != DEFAULT_NAME) {
			nameTF.text = Game.SO.data.username;
		} else {
			nameTF.text = DEFAULT_NAME;
		}
		
		submitButton = new Button();
		submitButton.x = window.width - submitButton.width - 25;
		submitButton.y = nameTF.y;
		submitButton.addEventListener(MouseEvent.CLICK, clickHandler);
		
		contentTF = new TextField();
		contentTF.selectable = false;
		contentTF.wordWrap = true;
		contentTF.multiline = true;
		contentTF.defaultTextFormat = new TextFormat("Arial", 20, 0x5D7521, true, false, false, null, null, TextFormatAlign.CENTER);
		contentTF.width = window.width - 50;
		contentTF.height = 90;
		contentTF.x = 25;
		contentTF.y = nameTF.y + nameTF.height + 20;
		
		mainButton = new Button();
		mainButton.x = (window.width - mainButton.width * 2 - 10) / 2;
		mainButton.y = window.height - mainButton.height - 20;
		mainButton.addEventListener(MouseEvent.CLICK, clickHandler);
		
		secondButton = new Button();
		secondButton.x = mainButton.x + mainButton.width + 10;
		secondButton.y = mainButton.y;
		secondButton.addEventListener(MouseEvent.CLICK, clickHandler);
		
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init (e:Event) {
		Timer.delay(focusTF, 20);
	}
	
	function focusTF () {
		Lib.current.stage.focus = nameTF;
		if (nameTF.text == DEFAULT_NAME) {
			nameTF.setSelection(0, nameTF.text.length);
		} else {
			nameTF.setSelection(nameTF.text.length, nameTF.text.length);
		}
	}
	
	public function setParams (seed:Int, level:Int, time:Float, moves:Int) {
		params = {};
		params.seed = seed;
		params.level = level;
		params.time = time;
		params.moves = moves;
		
		ready = true;
	}
	
	public function setMode (win:Bool, level:Int = -1, progress:Float = -1) {
		this.win = win;
		if (level != -1) {
			flevel = level;
		}
		// Clean
		if (window.contains((titleTF)))		window.removeChild(titleTF);
		if (window.contains(contentTF))		window.removeChild(contentTF);
		if (window.contains(nameTF))		window.removeChild(nameTF);
		if (window.contains(submitButton))	window.removeChild(submitButton);
		if (window.contains(mainButton))	window.removeChild(mainButton);
		if (window.contains(secondButton))	window.removeChild(secondButton);
		submitButton.mouseEnabled = true;
		submitButton.alpha = 1;
		nameTF.mouseEnabled = true;
		nameTF.alpha = 1;
		nameTF.type = TextFieldType.INPUT;
		
		// Set
		if (this.win) {
			titleTF.text = "CONGRATULATIONS!";
			submitButton.label = "Submit";
			contentTF.text = "Start again and try to beat your time or give another level a go!";
			mainButton.label = "Restart";
			secondButton.label = "Try another";
			window.addChild(titleTF);
			window.addChild(nameTF);
			window.addChild(submitButton);
			window.addChild(contentTF);
			window.addChild(mainButton);
			window.addChild(secondButton);
			nameTF.addEventListener(KeyboardEvent.KEY_DOWN, keyDownhandler);
		}
		else {
			titleTF.text = "TIME IS OUT!";
			if (progress != -1)	contentTF.text = "Just so you know, you did " + Std.int(progress * 100) + "% of this level.\n";
			else				contentTF.text = "";
			contentTF.text += "Play this level again or skip to another one...";
			mainButton.label = "Retry";
			secondButton.label = "Skip";
			window.addChild(titleTF);
			window.addChild(contentTF);
			window.addChild(mainButton);
			window.addChild(secondButton);
		}
	}
	
	function keyDownhandler (e:KeyboardEvent) {
		if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.NUMPAD_ENTER) {
			submit();
		}
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == submitButton) {
			submit();
			return;
		}
		else if (e.currentTarget == mainButton) {
			EventManager.instance.dispatchEvent(new GameEvent(GameEvent.START_AGAIN));
		}
		else if (e.currentTarget == secondButton) {
			Lib.getURL(new URLRequest("http://01101101.fr/ld27/?s=" + Std.random(Level.SEED_MAX) + "&l=" + flevel), "_self");
			return;
		}
		EventManager.instance.dispatchEvent(new GameEvent(GameEvent.WINDOW_CLOSE));
		ready = false;
	}
	
	function submit () {
		// If won
		if (win && ready) {
			if (nameTF.text == "")	nameTF.text = DEFAULT_NAME;
			else if (nameTF.text != DEFAULT_NAME) {
				Game.SO.data.username = nameTF.text;
				Game.SO.flush();
			}
			
			params.name = nameTF.text;
			ScoreManager.save(params);
			
			submitButton.label = "Saved!";
			submitButton.mouseEnabled = false;
			submitButton.alpha = 0.5;
			nameTF.setSelection(0, 0);
			nameTF.type = TextFieldType.DYNAMIC;
			nameTF.mouseEnabled = false;
			nameTF.alpha = 0.5;
			nameTF.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownhandler);
		}
	}
	
}











