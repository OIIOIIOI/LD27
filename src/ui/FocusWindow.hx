package ui;

import events.EventManager;
import events.GameEvent;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


/**
 * ...
 * @author 01101101
 */

class FocusWindow extends Sprite {
	
	var white:Sprite;
	var contentTF:TextField;
	var mod:Float;
	
	public function new () {
		super();
		
		white = new Sprite();
		Game.drawRect(white.graphics, 0xFFFFFF, 0.8, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		addChild(white);
		
		contentTF = new TextField();
		contentTF.selectable = false;
		contentTF.wordWrap = true;
		contentTF.multiline = true;
		contentTF.embedFonts = true;
		contentTF.defaultTextFormat = new TextFormat("GoodDog", 32, 0x5D7521, false, false, false, null, null, TextFormatAlign.CENTER);
		contentTF.width = Lib.current.stage.stageWidth;
		contentTF.height = 260;
		contentTF.x = 0;
		contentTF.y = (Lib.current.stage.stageHeight - contentTF.height) / 2;
		contentTF.text = "Click to focus";
		contentTF.text += "\n\nUse the UP, LEFT and RIGHT keys to chase the laser";
		contentTF.text += "\nGet to your basket before going mad!";
		contentTF.text += "\n\nThe timer starts as soon as you move!";
		addChild(contentTF);
		
		mouseChildren = false;
		buttonMode = true;
		addEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	function clickHandler (e:MouseEvent) {
		removeEventListener(MouseEvent.CLICK, clickHandler);
		mod = 0.01;
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event) {
		alpha -= mod;
		mod *= 1.1;
		if (alpha < 0.01) {
			alpha = 0;
			removeEventListener(Event.ENTER_FRAME, update);
			EventManager.instance.dispatchEvent(new GameEvent(GameEvent.GET_FOCUS));
		}
	}
	
}