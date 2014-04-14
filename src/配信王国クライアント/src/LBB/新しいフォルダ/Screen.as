package LBB
{
	import com.bit101.components.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.*;
	
	/**
	 * ...
	 * @author LBB
	 */
	public class Screen extends Sprite
	{
		private var zoom:WindowSizeChange = new WindowSizeChange();
		public var clickX:Number;
		public var clickY:Number;
		public var w:Number;
		public var h:Number;
		
		//動画ウィンドウ
		private var screen:MovieClip = new MovieClip();
		
		//ウィンドウ背景
		private var bg_screen:Sprite = new Sprite();
		
		//ウィンドウクリアー
		private var text_clear:TextField = new TextField();
		public var button_clearScreen:SimpleButton = new SimpleButton();
		
		//ウィンドウ縮小化
		private var text_close:TextField = new TextField();
		public var button_closeScreen:SimpleButton = new SimpleButton();
		
		//初回クリック判定
		private var first:Boolean = true;
		
		//最小化ボタンクリック判定
		public var click_close:Boolean = false;

		//動画各種必要項目
		private var video:Video = new Video(480, 320);
		private var netStream:NetStream;
		private var connection:NetConnection;
		
		//音量バー
		private var volume:HSlider;
		private var soundTrans:SoundTransform;
		
		public function Screen():void
		{
			setScreen();
			setClear();
			setClose();
			
			addChild(screen);
			
			button_clearScreen.addEventListener(MouseEvent.CLICK, click);
			button_closeScreen.addEventListener(MouseEvent.CLICK, close);
			screen.addEventListener(MouseEvent.MOUSE_DOWN, myMouseDown);
			screen.addEventListener(MouseEvent.MOUSE_UP, myMouseUp);
//			zoom.zoomup.addEventListener(MouseEvent.MOUSE_UP, Resize);
			zoom.zoomup.addEventListener(MouseEvent.MOUSE_DOWN, down);
		}
		
		private function setScreen():void
		{
			//screen表示用サンプル動画 各種設定
			connection = new NetConnection();
			connection.connect(null);
			netStream = new NetStream(connection);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, Netstatus_Check);
			var obj:Object = new Object();
			netStream.client = obj;
			video.attachNetStream(netStream);
			
			//ウィンドウ内動画位置
			video.x = 20;
			video.y = 20;
			
			//ウィンドウ背景設定
			bg_screen = graphic(0xffff66, 0xffcc66, 520, 360, 1);
			bg_screen.name = "bg";

			//ウィンドウ各種設定
			screen.x = screen.y = 150;
			screen.visible = false;
			
			zoom.zoomup.x = bg_screen.width - 21;
			zoom.zoomup.y = bg_screen.height - 21;
			
			screen.addChild(bg_screen);
			screen.addChild(video);
			screen.addChild(zoom);
			//音量バー設定
			volume = new HSlider(screen, (bg_screen.width / 2) - 100, bg_screen.height - 20);
			volume.addEventListener(Event.CHANGE, onHSliderChange);
			soundTrans = netStream.soundTransform;
			soundTrans.volume = 0.3;
			netStream.soundTransform = soundTrans;
		}
		
		private function setClear():void
		{			
			//ボタンテキスト　フォーマット設定
			var clear_format:TextFormat = new TextFormat();
			clear_format.size = 17;
			
			button_clearScreen.upState = graphic(0xff0000, 0xff0000, 20, 20, 0.45);
			button_clearScreen.overState = graphic(0xff0000, 0xff0000, 20, 20, 0.45);
			button_clearScreen.downState = graphic(0x000000, 0xff0000, 20, 20, 0.45);
			button_clearScreen.hitTestState = button_clearScreen.upState;
			button_clearScreen.x = bg_screen.width -22;
			
			text_clear.defaultTextFormat = clear_format;
			text_clear.text = "×";
			text_clear.width = button_clearScreen.width;
			text_clear.height = button_clearScreen.height;
			text_clear.x = button_clearScreen.x;
			text_clear.y = button_clearScreen.y;
			text_clear.autoSize = TextFieldAutoSize.CENTER;
			text_clear.selectable = false;
			
			screen.addChild(text_clear);
			screen.addChild(button_clearScreen);
		}
		
		private function setClose():void
		{
			var close_format:TextFormat = new TextFormat();
			close_format.size = 17;
			
			button_closeScreen.upState = graphic(0x3399ff, 0x3399ff, 20, 20, 0.45);
			button_closeScreen.overState = graphic(0x3399ff, 0x3399ff, 20, 20, 0.45);
			button_closeScreen.downState = graphic(0x990099, 0x990099, 20, 20, 0.45);
			button_closeScreen.hitTestState = button_closeScreen.upState;
			button_closeScreen.x = button_clearScreen.x - 22;
			
			text_close.defaultTextFormat = close_format;
			text_close.text = "－";
			text_close.width = button_closeScreen.width;
			text_close.height = button_closeScreen.height;
			text_close.x = button_closeScreen.x;
			text_close.y = button_closeScreen.y;
			text_close.autoSize = TextFieldAutoSize.CENTER;
			text_close.selectable = false;
			
			screen.addChild(text_close);
			screen.addChild(button_closeScreen);
		}
		
		private function graphic(color:uint, lineColor:uint, w:int, h:int, a:Number):Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(2, lineColor);
			s.graphics.beginFill(color);
			s.graphics.drawRect(0, 0, w, h);
			s.graphics.endFill();
			s.alpha = a;
			return s;
		}
		
		public function disp():void
		{
			screen.visible = true;
			play();
		}
		
		public function not_disp():void
		{
			netStream.togglePause();
			screen.visible = false;
		}
		
		public function play():void
		{
			if (first)
			{
				netStream.play("http://shule517.ddo.jp/NetWalk/data/SampleMovie.flv");
				first = false;
			}
			else
			{
				screen.visible = true;
				netStream.togglePause();
			}
		}
		
		public function open():void
		{
			screen.visible = true;
			click_close = false;
		}
		
		private function click(e:MouseEvent):void
		{
			not_disp();
		}
		
		private function close(e:MouseEvent):void
		{
			screen.visible = false;
			click_close = true;
		}
		
		private function myMouseDown (e:MouseEvent):void
		{
			if (e.target.name == "bg")
			{
				screen.startDrag (false);   
				screen.addEventListener (MouseEvent.MOUSE_MOVE, myMouseMove);   
			}
		}   
		  
		private function myMouseMove (e:MouseEvent):void 
		{
			e.updateAfterEvent ();   
		}
		  
		private function myMouseUp (e:MouseEvent):void 
		{
			if (e.target.name == "bg")
			{
				screen.stopDrag ();   
				screen.removeEventListener (MouseEvent.MOUSE_MOVE, myMouseMove);   
			}
		}
		public function Netstatus_Check(e:NetStatusEvent):void 
		{
			trace(e.info.code);			
		}
		
		private function onHSliderChange(e:Event):void
		{
			soundTrans.volume = volume.value / 100;
			netStream.soundTransform = soundTrans;
		}
		
		private function Resize():void
		{trace(zoom.zoomup.x);
			if (zoom.stage.mouseX > screen.x + 80)
			{
				bg_screen.width = w;
				video.width = bg_screen.width - 40;
				/*button_clearScreen.x = bg_screen.width -22;
				text_clear.x = button_clearScreen.x + 4;
				button_closeScreen.x = button_clearScreen.x - 22;
				text_close.x = button_closeScreen.x;
				//zoom.zoomup.x = bg_screen.width - 21;*/
			}
			else if (zoom.stage.mouseX < screen.x + 80)
			{
				//zoom.zoomup.x = bg_screen.width - 21;
				//zoom.zoomup.y = bg_screen.height - 21;
			}
			if (zoom.stage.mouseY > screen.y + 80)
			{
				bg_screen.height = h;
				video.height = bg_screen.height - 40;
				/*text_clear.y = button_clearScreen.y;
				text_close.y = button_closeScreen.y;
				//zoom.zoomup.y = bg_screen.height - 21;*/
			}
			else if (zoom.stage.mouseY < screen.y + 80)
			{
				//zoom.zoomup.x = bg_screen.width - 21;
				//zoom.zoomup.y = bg_screen.height - 21;
			}
		}
		
		private function down(e:MouseEvent):void
		{
			clickX = stage.mouseX;
			clickY = stage.mouseY;
			zoom.zoomup.startDrag(false);
			zoom.zoomup.addEventListener(Event.ENTER_FRAME, drawingHandler);
			zoom.zoomup.addEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		private function drawingHandler(e:Event):void
		{
			w = stage.mouseX - screen.x + 7;
			h = stage.mouseY - screen.y + 7;
			trace("w=" + w);
			trace("h=" + h); 
			Resize();
		}
		
		private function up(e:MouseEvent):void
		{
			zoom.zoomup.stopDrag();
			zoom.zoomup.removeEventListener(Event.ENTER_FRAME, drawingHandler);
			zoom.zoomup.removeEventListener(MouseEvent.MOUSE_UP, up);
		}

	}
}