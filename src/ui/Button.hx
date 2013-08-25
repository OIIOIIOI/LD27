package ui;

import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

/**
 * ...
 * @author 01101101
 */

class Button extends Sprite {
	
	static var format:TextFormat = new TextFormat("GoodDog", 28, 0xFFFFFF);
	
	var bg:Shape;
	var tf:TextField;
	public var label(get, set):String;
	
	public function new () {
		super();
		
		format.align = TextFormatAlign.CENTER;
		
		mouseChildren = false;
		buttonMode = true;
		
		bg = new Shape();
		Game.drawRect(bg.graphics, 0, 1, 140, 35);
		addChild(bg);
		
		tf = new TextField();
		tf.width = bg.width;
		tf.height = bg.height;
		tf.selectable = false;
		tf.embedFonts = true;
		tf.defaultTextFormat = format;
		addChild(tf);
	}
	
	function get_label () :String {
		return tf.text;
	}
	
	function set_label (string:String) :String {
		tf.text = string;
		return tf.text;
	}
	
}