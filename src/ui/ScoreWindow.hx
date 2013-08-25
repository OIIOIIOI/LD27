package ui;

import events.EventManager;
import events.GameEvent;
import flash.display.Shape;
import flash.display.Sprite;
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
	
	var black:Sprite;
	var window:Sprite;
	var bg:Shape;
	var nameTF:TextField;
	var button:Sprite;
	
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
		
		nameTF = new TextField();
		nameTF.type = TextFieldType.INPUT;
		nameTF.selectable = true;
		nameTF.alwaysShowSelection = true;
		nameTF.maxChars = 16;
		nameTF.border = true;
		nameTF.background = true;
		nameTF.defaultTextFormat = new TextFormat("Arial", 24, 0, true, false, false, null, null, TextFormatAlign.CENTER);
		nameTF.width = 400;
		nameTF.height = 50;
		nameTF.x = (Lib.current.stage.stageWidth- nameTF.width) / 2;
		nameTF.y = (Lib.current.stage.stageHeight - nameTF.height) / 2;
		nameTF.text = "anon";
		addChild(nameTF);
		
		button = new Sprite();
		Game.drawRect(button.graphics, 0x00FF00, 1, 100, 30);
		button.x = (Lib.current.stage.stageWidth- button.width) / 2;
		button.y = nameTF.y + nameTF.height + 10;
		button.buttonMode = true;
		addChild(button);
		
		button.addEventListener(MouseEvent.CLICK, clickHandler);
		
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
	
	function clickHandler (e:MouseEvent) {
		if (ready) {
			if (nameTF.text == "")	nameTF.text = "anon";
			params.name = nameTF.text;
			ScoreManager.save(params);
		}
		
		EventManager.instance.dispatchEvent(new GameEvent(GameEvent.WINDOW_CLOSE));
		ready = false;
	}
	
}











