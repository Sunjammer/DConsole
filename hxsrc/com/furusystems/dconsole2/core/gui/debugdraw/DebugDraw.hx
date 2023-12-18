package com.furusystems.dconsole2.core.gui.debugdraw ;
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.utils.LLNode;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
import com.furusystems.dconsole2.core.interfaces.IDisposable;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
	
	/**
	 * Utility class for drawing superimposed symbols on display objects
	 * @author Andreas Ronning
	 */
	 class DebugDraw {
		var _shape:Shape = new Shape();
		var _g:Graphics;
		var colors:Vector<UInt> = Vector.ofArray(([0xFF0000, 0xFF0000, 0x00FFFF, 0x0000FF, 0xFF00FF, 0x00FF00] : Array<UInt>));
		var currentColor:UInt = 0;
		var _enabled:Bool = true;
		var _arrowSize:Float = Math.NaN;
		var default3DFields:Array<ASAny> = ["x", "y", "z", "width", "height", "rotationX", "rotationY", "rotationZ"];
		var default2DFields:Array<ASAny> = ["x", "y", "width", "height", "rotation"];
		
		var drawInstructions:LLNode = new LLNode(null);
		var prevDrawInstructions:LLNode = null;
		
		public function new(messaging:PimpCentral) {
			_g = _shape.graphics;
			messaging.addCallback(Notifications.FRAME_UPDATE, onFrameUpdate);
		}
		
		function onFrameUpdate() {
			if (!enabled)
				return;
			clear();
			
			//TODO: compare the previous set of instructions to the current and pass in delta if needed
			var iterator= drawInstructions.getIterator();
			var data:DrawInstruction = iterator.data;while (data != null) {
				data.draw(g);
data = iterator.next();
			}
			
			prevDrawInstructions = drawInstructions;
			drawInstructions = new LLNode(null); //TODO: This is such bad news
		}
		
		@:flash.property public var g(get,never):Graphics;
function  get_g():Graphics {
			return _g;
		}
		
		@:flash.property public var shape(get,never):Shape;
function  get_shape():Shape {
			return _shape;
		}
		
				
		@:flash.property public var enabled(get,set):Bool;
function  get_enabled():Bool {
			return _enabled && shape.stage != null;
		}
function  set_enabled(value:Bool):Bool{
			return _enabled = value;
		}
		
		public function clear() {
			g.clear();
			currentColor = 0;
		}
		
		public function drawArrow2D(x:Float, y:Float, angle:Float = 0, color:UInt = 0) {
			drawInstructions.append(new DrawArrowInstruction(x, y, angle, color));
		}
		
		/**
		 * Draws a path through a list of objects with x/y properties
		 * @param	path
		 * The path to trace in world coordinates. Every item is expected to have xy properties.
		 * @param	color
		 * The color for the wire
		 * @param	cameraOffsetX
		 * The viewpoint's horizontal offset in world coordinates
		 * @param	cameraOffsetY
		 * The viewpoint's vertical offset in world coordinates
		 * @param	directed
		 * Wether to draw arrows at every junction to show the path direction
		 */
		public function drawPath2D(path:Array<ASAny>, color:UInt, cameraOffsetX:Float = 0, cameraOffsetY:Float = 0, directed:Bool = false) {
			
			var i= 0;while (i < path.length) {
				var item:ASAny = path[i];
i++;
				
			}
		}
		
		/**
		 * Draws a 3D path through a list of objects with x/y/z properties
		 * @param	path
		 * The path to trace in world space. Every item is expected to have xyz properties
		 * @param	color
		 * The color for the wire
		 * @param	viewProjection
		 * A matrix combining the view and perspective transforms
		 * @param	directed = false
		 * Wether to draw arrows at every junction to show the path direction
		 */
		public function drawPath3D(path:Array<ASAny>, color:UInt, viewProjection:Matrix3D, directed:Bool = false) {
		
		}
		
		public function bracketObject(o:DisplayObject) {
			if (!enabled)
				return;
			var pb= o.transform.pixelBounds;
			var outOfBounds= false;
			
			var sw:Float = shape.stage.stageWidth;
			var sh:Float = shape.stage.stageHeight;
			
			if (pb.x + pb.width < 0) {
				
				outOfBounds = true;
			} else if (pb.x > sw) {
				outOfBounds = true;
			}
			
			if (pb.y + pb.height < 0) {
				outOfBounds = true;
			} else if (pb.y > sh) {
				outOfBounds = true;
			}
			var color= nextColor();
			if (outOfBounds) {
				var tx= pb.x + pb.width * 0.5;
				var ty= pb.y + pb.height * 0.5;
				var dx= tx - sw * 0.5;
				var dy= ty - sh * 0.5;
				drawArrow2D(Math.max(DrawArrowInstruction.ARROW_SIZE, Math.min(sw - DrawArrowInstruction.ARROW_SIZE, tx)), Math.max(DrawArrowInstruction.ARROW_SIZE, Math.min(sh - DrawArrowInstruction.ARROW_SIZE, ty)), Math.atan2(dy, dx), color);
			} else {
				drawRect(pb, color);
			}
		}
		
		function drawRect(rect:Rectangle, color:UInt) {
			drawInstructions.append(new DrawRectInstruction(rect, color));
		}
		
		public function drawMotionVector(o:DisplayObject) {
		
		}
		
		public function drawTransform(o:DisplayObject) {
			var color= nextColor();
			if (o.transform.matrix3D != null) {
				drawMatrix3D(o, color);
			} else {
				drawMatrix2D(o, color);
			}
		}
		
		function nextColor():UInt {
			return colors[currentColor++ % colors.length];
		}
		
		function drawMatrix2D(o:DisplayObject, color:UInt) {
			drawInstructions.append(new DrawMatrix2DInstruction(o, nextColor()));
		}
		
		function drawMatrix3D(o:DisplayObject, color:UInt) {
			var m3D= o.transform.getRelativeMatrix3D(o.root);
		}
		
		public function printInfo(o:DisplayObject,  fields:Array<ASAny> = null) {
if (fields == null) fields = [];
			if (fields.length == 0) {
				if (o.transform.matrix3D != null) {
					fields = default3DFields;
				} else {
					fields = default2DFields;
				}
			}
		
		}
		
		public function lineBetween(o1:DisplayObject, o2:DisplayObject) {
			if (!enabled)
				return;
			var color= colors[currentColor++ % colors.length];
			drawInstructions.append(new LineBetweenInstruction(o1, o2, color));
		}
	
	}



/*internal*/ private class DrawInstruction implements IDisposable {
	public function draw(g:Graphics, prevInstruction:DrawInstruction = null) {
	
	}
	
	public function dispose() {
	
	}
}

/*internal*/ private class LineBetweenInstruction extends DrawInstruction {
	var _o1:DisplayObject;
	var _o2:DisplayObject;
	var _color:UInt = 0;
	
	public function new(o1:DisplayObject, o2:DisplayObject, color:UInt) {
		_color = color;
		_o2 = o2;
		_o1 = o1;
	}
	
	override public function draw(g:Graphics, prevInstruction:DrawInstruction = null) {
		var pb1= _o1.transform.pixelBounds;
		var pb2= _o2.transform.pixelBounds;
		g.lineStyle(0, _color);
		g.moveTo(pb1.x + pb1.width * 0.5, pb1.y + pb1.height * 0.5);
		g.lineTo(pb2.x + pb2.width * 0.5, pb2.y + pb2.height * 0.5);
	}
}

/*internal*/ private class DrawMatrix2DInstruction extends DrawInstruction {
	var _color:UInt = 0;
	var _o:DisplayObject;
	
	public function new(o:DisplayObject, color:UInt) {
		_o = o;
		_color = color;
	}
	
	override public function draw(g:Graphics, prevInstruction:DrawInstruction = null) {
		var m= _o.transform.concatenatedMatrix;
		if (m == null)
			return;
		var origo= new Point();
		var y= new Point(0, 20);
		var x= new Point(20, 0);
		
		origo = m.transformPoint(origo);
		x = m.transformPoint(x);
		y = m.transformPoint(y);
		
		g.moveTo(origo.x, origo.y);
		g.lineStyle(1, 0xFF0000);
		g.lineTo(x.x, x.y);
		g.moveTo(origo.x, origo.y);
		g.lineStyle(1, 0x00FF00);
		g.lineTo(y.x, y.y);
	}
}

/*internal*/ private class DrawRectInstruction extends DrawInstruction {
	var _rect:Rectangle;
	var _color:UInt = 0;
	
	public function new(rect:Rectangle, color:UInt) {
		_color = color;
		_rect = rect;
	}
	
	override public function draw(g:Graphics, prevInstruction:DrawInstruction = null) {
		g.lineStyle(0, _color);
		g.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
	}
}

/*internal*/ private class DrawArrowInstruction extends DrawInstruction {
	var _x:Float = Math.NaN;
	var _y:Float = Math.NaN;
	var _angle:Float = Math.NaN;
	var _color:UInt = 0;
	public static inline final ARROW_SIZE= 8;
	
	public function new(x:Float, y:Float, angle:Float, color:UInt) {
		_color = color;
		_angle = angle;
		_y = y;
		_x = x;
	}
	
	override public function draw(g:Graphics, prevInstruction:DrawInstruction = null) {
		g.lineStyle(1, _color);
		var angleOffset= 0.785;
		g.moveTo(_x + Math.cos(_angle - angleOffset) * -ARROW_SIZE, _y + Math.sin(_angle - angleOffset) * -ARROW_SIZE);
		g.lineTo(_x, _y);
		g.lineTo(_x + Math.cos(_angle + angleOffset) * -ARROW_SIZE, _y + Math.sin(_angle + angleOffset) * -ARROW_SIZE);
	}
}