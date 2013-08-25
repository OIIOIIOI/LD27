package ui;

import events.EventManager;
import events.GameEvent;
import flash.display.Shape;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.Timer;

/**
 * ...
 * @author 01101101
 */

class ScoreWindow extends Sprite {
	
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
	
	public function new () {
		super();
		
		ready = false;
		
		black = new Sprite();
		Game.drawRect(black.graphics, 0x000000, 0.8, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		addChild(black);
		
		window = new Sprite();
		Game.drawRect(window.graphics, 0xFFFFFF, 1, 500, 280);
		window.x = (Lib.current.stage.stageWidth- window.width) / 2;
		window.y = (Lib.current.stage.stageHeight- window.height) / 2;
		addChild(window);
		
		titleTF = new TextField();
		titleTF.selectable = false;
		titleTF.defaultTextFormat = new TextFormat("GoodDog", 42, 0, true, false, false, null, null, TextFormatAlign.CENTER);
		titleTF.width = window.width;
		titleTF.height = 50;
		titleTF.x = 0;
		titleTF.y = 20;
		
		nameTF = new TextField();
		nameTF.type = TextFieldType.INPUT;
		nameTF.selectable = true;
		nameTF.alwaysShowSelection = true;
		nameTF.maxChars = 16;
		nameTF.border = true;
		nameTF.background = true;
		nameTF.defaultTextFormat = new TextFormat("Arial", 20, 0, true, false, false, null, null, TextFormatAlign.CENTER);
		nameTF.restrict = "A-Z0-9_. \\-";
		nameTF.width = 290;
		nameTF.height = 35;
		nameTF.x = 25;
		nameTF.y = titleTF.y + titleTF.height + 20;
		nameTF.text = "ENTER YOUR NAME";
		
		submitButton = new Button();
		submitButton.x = window.width - submitButton.width - 25;
		submitButton.y = nameTF.y;
		submitButton.addEventListener(MouseEvent.CLICK, clickHandler);
		
		contentTF = new TextField();
		contentTF.selectable = false;
		contentTF.wordWrap = true;
		contentTF.multiline = true;
		contentTF.defaultTextFormat = new TextFormat("Arial", 20, 0, true, false, false, null, null, TextFormatAlign.CENTER);
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
		nameTF.setSelection(0, nameTF.text.length);
	}
	
	public function setParams (seed:Int, level:Int, time:Float, moves:Int) {
		params = {};
		params.seed = seed;
		params.level = level;
		params.time = time;
		params.moves = moves;
		
		ready = true;
	}
	
	public function setMode (win:Bool) {
		this.win = win;
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
		submitButton.alpha = 1;
		
		// Set
		if (this.win) {
			titleTF.text = "Congratulations!";
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
		}
		else {
			titleTF.text = "Time is out!";
			contentTF.text = "Play this level again or skip to another one...";
			mainButton.label = "Retry";
			secondButton.label = "Skip";
			window.addChild(titleTF);
			window.addChild(contentTF);
			window.addChild(mainButton);
			window.addChild(secondButton);
		}
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == submitButton) {
			// If qon
			if (win && ready) {
				if (nameTF.text == "")	nameTF.text = "ANON";
				params.name = nameTF.text;
				ScoreManager.save(params);
				submitButton.mouseEnabled = false;
				submitButton.alpha = 0.5;
				nameTF.mouseEnabled = false;
				nameTF.alpha = 0.5;
				return;
			}
		}
		else if (e.currentTarget == mainButton) {
			EventManager.instance.dispatchEvent(new GameEvent(GameEvent.START_AGAIN));
		}
		else if (e.currentTarget == secondButton) {
			EventManager.instance.dispatchEvent(new GameEvent(GameEvent.TRY_NEW));
		}
		EventManager.instance.dispatchEvent(new GameEvent(GameEvent.WINDOW_CLOSE));
		ready = false;
	}
	
}











