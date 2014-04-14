package LBB
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class Thread extends Sprite
	{
		private var zoom:WindowSizeChange = new WindowSizeChange();
		
		//スレッドウィンドウ
		private var threadBox:MovieClip = new MovieClip();
		
		//ウィンドウ背景
		private var bg_Box:Sprite = new Sprite();
		
		//スレッド背景
		private var bg_thread:Sprite = new Sprite();
		
		//スレッドテキスト
		private var output_thread:TextField = new TextField();
		
		//ウィンドウクリアー
		private var text_clear:TextField = new TextField();
		public var button_clear:SimpleButton = new SimpleButton();

		public function Thread():void
		{
			setthread();
			
			setclear();
			
			addChild(threadBox);
			
			button_clear.addEventListener(MouseEvent.CLICK, click);
			bg_Box.addEventListener(MouseEvent.MOUSE_DOWN, myMouseDown);
			bg_Box.addEventListener(MouseEvent.MOUSE_UP, myMouseUp);
			zoom.zoomup.addEventListener(MouseEvent.MOUSE_UP, Resize);
		}
		
		 private function setthread():void
		{
			bg_thread = graphic(0xFFFFFF, 0xC5C5C5, 248, 348, 1);
			bg_thread.x = 20;
			bg_thread.y = 20;
			
			output_thread.width = bg_thread.width;
			output_thread.height = bg_thread.height;
			output_thread.x = bg_thread.x;
			output_thread.y = bg_thread.y;
			output_thread.text = "てｓ1\nてｓ2\nてｓ3\nてｓ4\nてｓ5\nてｓ6\nてｓ7\nてｓ8\nてｓ9\nてｓ10\nてｓ11\nてｓ12\nてｓ13\nてｓ14\nてｓ15\nてｓ16\nてｓ17\nてｓ18\nてｓ19\nてｓ20";
			
			bg_Box = graphic(0xffff66, 0xffcc33, bg_thread.width + 42, bg_thread.height + 42, 1);
			bg_Box.name = "bg";
			
			threadBox.x = threadBox.y = 40;
			threadBox.visible = false;
			
			zoom.zoomup.x = bg_Box.width - 21;
			zoom.zoomup.y = bg_Box.height - 21;
			
			threadBox.addChild(bg_Box);
			threadBox.addChild(bg_thread);
			threadBox.addChild(output_thread);
			threadBox.addChild(zoom);
		}
		  
		private function setclear():void
		{			
			//ボタンテキスト　フォーマット設定
			var clear_format:TextFormat = new TextFormat();
			clear_format.size = 17;
			
			button_clear.upState = graphic(0xff0000, 0xff0000, 20, 20, 0.45);
			button_clear.overState = graphic(0xff0000, 0xff0000, 20, 20, 0.45);
			button_clear.downState = graphic(0x000000, 0xff0000, 20, 20, 0.45);
			button_clear.hitTestState = button_clear.upState;
			button_clear.x = bg_Box.width -22;
			
			text_clear.defaultTextFormat = clear_format;
			text_clear.text = "×";
			text_clear.width = button_clear.width;
			text_clear.height = button_clear.height;
			text_clear.x = button_clear.x;
			text_clear.y = button_clear.y;
			text_clear.autoSize = TextFieldAutoSize.CENTER;
			text_clear.selectable = false;
			
			threadBox.addChild(text_clear);
			threadBox.addChild(button_clear);
		}
		
		private function graphic(color:uint, lineColor:uint, w:int, h:int, a:Number):Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(1, lineColor);
			s.graphics.beginFill(color);
			s.graphics.drawRect(0, 0, w, h);
			s.graphics.endFill();
			s.alpha = a;
			return s;
		}
		
		public function disp():void
		{
			threadBox.visible = true;
		}
		
		public function not_disp():void
		{
			threadBox.visible = false;
		}
		
		private function click(e:MouseEvent):void
		{
			threadBox.visible = false;
		}
		
		private function myMouseDown(e:MouseEvent):void
		{
			if (e.target.name == "bg")
			{
				threadBox.startDrag(false);
				threadBox.addEventListener(MouseEvent.MOUSE_MOVE, myMouseMove);
				
			}
		}
		
		private function myMouseMove(e:MouseEvent):void
		{
			e.updateAfterEvent();
		}
		
		private function myMouseUp(e:MouseEvent):void
		{
			if (e.target.name == "bg")
			{
				threadBox.stopDrag();
				threadBox.removeEventListener(MouseEvent.MOUSE_MOVE, myMouseMove);
			}
		}
		
		private function Resize(e:MouseEvent):void
		{
			if (zoom.stage.mouseX > threadBox.x + 80)
			{
				bg_Box.width = bg_Box.width + zoom.w;
				bg_thread.width = bg_Box.width - 42;
				output_thread.width = bg_thread.width;
				button_clear.x = bg_Box.width - 22;
				text_clear.x = button_clear.x + 4;
				zoom.zoomup.x = bg_Box.width - 21;
			}
			else if (zoom.stage.mouseX < threadBox.x + 80)
			{
				zoom.zoomup.x = bg_Box.width - 21;
				zoom.zoomup.y = bg_Box.height - 21;
			}
			if (zoom.stage.mouseY > threadBox.y + 80)
			{
				bg_Box.height = bg_Box.height + zoom.h;
				bg_thread.height = bg_Box.height - 42;
				output_thread.height = bg_thread.height;
				text_clear.y = button_clear.y;
				zoom.zoomup.y = bg_Box.height - 21;
			}
			else if (zoom.stage.mouseY < threadBox.y + 80)
			{
				zoom.zoomup.x = bg_Box.width - 21;
				zoom.zoomup.y = bg_Box.height - 21;
			}
		}
	}
}