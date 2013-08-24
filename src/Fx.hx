package ;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import mt.deepnight.Particle;
import mt.deepnight.Lib;
import mt.deepnight.Color;

class Fx {
	
	static public var instance(default, null):Fx;
	
	var container:Sprite;
	var tick:Int;
	
	public function new (container:Sprite) {
		this.container = container;
		Particle.LIMIT = 150;
		tick = 0;
		instance = this;
	}
	
	public function register(p:Particle, ?b:BlendMode, ?bg = false) {
		container.addChild(p);
		p.blendMode = b!=null ? b : BlendMode.ADD;
	}
	
	inline function rnd(min,max,?sign) { return Lib.rnd(min,max,sign); }
	inline function irnd(min,max,?sign) { return Lib.irnd(min,max,sign); }
	
	public function explode (x:Float, y:Float, color:UInt) {
		var a = rnd(0, 6.28);
		var s = rnd(0, 3);
		var p = new Particle(x + Math.cos(a), y + Math.sin(a));
		p.drawCircle(2, color);
		//p.rotation = a * 180 / 3.14;
		p.dx = Math.cos(a) * s;
		p.dy = Math.sin(a) * s;
		p.frictX = p.frictY = 0.8;
		p.ds = -0.03;
		p.life = 0;
		//p.filters = [ new flash.filters.GlowFilter(c2, 1, 6, 6) ];
		register(p, BlendMode.NORMAL);
	}
	
	public function trail (x:Float, y:Float, color:UInt) {
		var p = new Particle(x, y);
		p.drawCircle(2, color);
		p.da = 0.5;
		p.life = 0;
		register(p, BlendMode.NORMAL);
	}
	
	public inline function update() {
		tick++;
		Particle.update();
	}
}










