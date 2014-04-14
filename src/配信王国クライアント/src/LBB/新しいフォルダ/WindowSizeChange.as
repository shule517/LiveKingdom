package LBB
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	public class WindowSizeChange extends Sprite
	{
		public var zoomup:MovieClip = new MovieClip();
		public var tr:Shape;
		public var clickX:Number;
		public var clickY:Number;
		public var w:Number;
		public var h:Number;
		
		public function WindowSizeChange():void
		{
			tr = fillTriangle();
			//zoomup.addEventListener(MouseEvent.MOUSE_DOWN, down);
			//zoomup.addEventListener(MouseEvent.MOUSE_UP, up);
			//zoomup.addEventListener(MouseEvent.MOUSE_DOWN, down);
			zoomup.addChild(tr);
			addChild(zoomup);
		}
		
		private function fillTriangle():Shape
		{
			var triangle:Shape = new Shape();
			triangle.graphics.beginFill(0x919191);
			triangle.graphics.moveTo(20, 0);
			triangle.graphics.lineTo(0, 20);
			triangle.graphics.lineTo(20, 20);
			triangle.graphics.lineTo(20, 0);
			triangle.graphics.endFill();
			return triangle;    
		}
/*		
		private function down(e:MouseEvent):void
		{
			clickX = stage.mouseX;
			clickY = stage.mouseY;
			zoomup.startDrag(false);
			zoomup.addEventListener(Event.ENTER_FRAME, drawingHandler);
			zoomup.addEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		private function drawingHandler(e:Event):void
		{
			w = stage.mouseX - clickX;
			h = stage.mouseY - clickY;
		}
		
		private function up(e:MouseEvent):void
		{
			zoomup.stopDrag();
			zoomup.removeEventListener(Event.ENTER_FRAME, drawingHandler);
			zoomup.removeEventListener(MouseEvent.MOUSE_UP, up);
		}
		
/*		private function down(e:MouseEvent):void
		{
			clickX = stage.mouseX;
			clickY = stage.mouseY;
			zoomup.startDrag(false);
		}
		
		private function up(e:MouseEvent):void
		{
			w = stage.mouseX - clickX;
			h = stage.mouseY - clickY;
			zoomup.stopDrag();
		}*/
	}
}