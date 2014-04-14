package LBB
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class mainbutton extends Sprite
	{
		//メインボタン
		private var haisin:SimpleButton = new SimpleButton();
		private var douga:SimpleButton = new SimpleButton();
		private var thread:SimpleButton = new SimpleButton();
		private var map:SimpleButton = new SimpleButton();
		private var friend:SimpleButton = new SimpleButton();
		private var oo:SimpleButton = new SimpleButton();
		
		//メインボタン　テキスト
		private var text_hai:TextField = new TextField();
		private var text_dou:TextField = new TextField();
		private var text_thread:TextField = new TextField();
		private var text_map:TextField = new TextField();
		private var text_fri:TextField = new TextField();
		private var text_oo:TextField = new TextField();
		
		//メインボタン　背景
		private var bg_hai:Sprite = new Sprite();
		private var bg_dou:Sprite = new Sprite();
		private var bg_thread:Sprite = new Sprite();
		private var bg_map:Sprite = new Sprite();
		private var bg_fri:Sprite = new Sprite();
		private var bg_oo:Sprite = new Sprite();
		
		//クリック判定
		private var judge_hai:Boolean = true;
		private var judge_dou:Boolean = true;
		private var judge_thread:Boolean = true;
		private var judge_map:Boolean = true;
		private var judge_fri:Boolean = true;
		private var judge_oo:Boolean = true;
		
		//スレッド
		private var THREAD:Thread = new Thread();
		
		//動画
		private var Movie:Screen = new Screen();
		private var Movie2:Screen = new Screen();
		
		//マップ
		private var MAP:Map = new Map();
		
		public function mainbutton():void
		{
			//stegeリサイズ時のイベント
			Main.mainStage.addEventListener(Event.RESIZE, Resize);
			
			//メインボタン設定
			setbutton(haisin, text_hai, bg_hai, "配信", 75, Main.mainStage.stageWidth - 525);
			setbutton(douga, text_dou,  bg_dou, "動画", 75, Main.mainStage.stageWidth - 448);
			setbutton(thread, text_thread,  bg_thread, "スレッド", 75, Main.mainStage.stageWidth - 371);
			setbutton(map, text_map,  bg_map, "ミニマップ", 90, Main.mainStage.stageWidth - 294);
			setbutton(friend, text_fri,  bg_fri, "フレンド", 75, Main.mainStage.stageWidth - 202);
			setbutton(oo, text_oo,  bg_oo, "( ^ω^)おっおっ", 115, Main.mainStage.stageWidth - 125);
			
			//メインボタン　クリックイベント
			haisin.addEventListener(MouseEvent.CLICK, click_hai);
			douga.addEventListener(MouseEvent.CLICK, click_dou);
			thread.addEventListener(MouseEvent.CLICK, click_thread);
			map.addEventListener(MouseEvent.CLICK, click_map);
			friend.addEventListener(MouseEvent.CLICK, click_fri);
			oo.addEventListener(MouseEvent.CLICK, click_oo);
			
			//ウィンドウクリアー時のメニューボタンとの同期
			THREAD.button_clear.addEventListener(MouseEvent.CLICK, click_clearthread);
			Movie.button_clearScreen.addEventListener(MouseEvent.CLICK, click_clearScreen);
			Movie.button_closeScreen.addEventListener(MouseEvent.CLICK, click_closeScreen);
			Movie2.button_clearScreen.addEventListener(MouseEvent.CLICK, click_clearScreen2);
			Movie2.button_closeScreen.addEventListener(MouseEvent.CLICK, click_closeScreen2);
			
			//stage.addChild 一覧（順同）
			addChild(bg_hai);
			addChild(text_hai);
			addChild(haisin);
			addChild(bg_dou);
			addChild(text_dou);
			addChild(douga);
			addChild(bg_thread);
			addChild(text_thread);
			addChild(thread);
			addChild(bg_map);
			addChild(text_map);
			addChild(map);
			addChild(bg_fri);
			addChild(text_fri);
			addChild(friend);
			addChild(bg_oo);
			addChild(text_oo);
			addChild(oo);
			addChild(THREAD);
			addChild(Movie);
			addChild(Movie2);
			addChild(MAP);
		}
		
		private function setbutton(button:SimpleButton, text:TextField, bg:Sprite, T:String, w:int, X:Number):void
		{
			//メインボタン詳細設定
			button.upState = graphic(0xFFFF00, w, 20, 0.45);
			button.overState = graphic(0xFFFF00, w, 20, 0.45);
			button.downState = graphic(0x0000FF, w, 20, 0.45);
			button.hitTestState = button.upState;
			button.x = X;
			button.y = 10;
			
			//ボタンテキスト　フォーマット設定
			var button_format:TextFormat = new TextFormat();
			button_format.size = 17;

			//メインボタンテキスト設定
			text.defaultTextFormat = button_format;
			text.text = T;
			text.x = button.x;
			text.y = button.y - 1;
			text.width = button.width;
			text.height = button.height;
			text.autoSize = TextFieldAutoSize.CENTER;
			text.selectable = false;
			
			//メインボタン背景設定
			bg = graphic(0x000000, w, 20, 1);
		}

		private function graphic(color:uint, w:int, h:int, a:Number):Sprite
		{
			var s:Sprite = new Sprite(); 
			s.graphics.lineStyle(2); 
			s.graphics.beginFill(color); 
			s.graphics.drawRect(0, 0, w, h); 
			s.graphics.endFill(); 
			s.alpha = a; 
			return s; 
		}
		
		private function changeButton(button:SimpleButton, w:int):void
		{
			button.upState = graphic(0x0000FF, w, 20, 0.45);
			button.overState = graphic(0x0000FF, w, 20, 0.45);
			button.downState = graphic(0xFFFF00, w, 20, 0.45);
		}
		
		private function def_changeButton(button:SimpleButton, w:int):void
		{
			button.upState = graphic(0xFFFF00, w, 20, 0.45);
			button.overState = graphic(0xFFFF00, w, 20, 0.45);
			button.downState = graphic(0x0000FF, w, 20, 0.45);
		}
		
		private function click_hai(e:MouseEvent):void
		{
			trace("配信");
			if (judge_hai)
			{
				changeButton(haisin, 75);
				judge_hai = false;
			}
			else
			{
				def_changeButton(haisin, 75);
				judge_hai = true;
			}
		}
		
		private function click_dou(e:MouseEvent):void
		{
			if (judge_dou)
			{
				if (Movie.click_close)
				{
					changeButton(douga, 75);
					Movie.open();
					judge_dou = false;
				}
				else
				{
					changeButton(douga, 75);
					Movie.disp();
					judge_dou = false;
				}
			}
			else
			{
				def_changeButton(douga, 75);
				Movie.not_disp();
				judge_dou = true;
			}
		}
		
		private function click_thread(e:MouseEvent):void
		{
			if (judge_thread)
			{
				changeButton(thread, 75);
				THREAD.disp();
				judge_thread = false;
			}
			else
			{
				def_changeButton(thread, 75);
				THREAD.not_disp();
				judge_thread = true;
			}
		}
		
		private function click_map(e:MouseEvent):void
		{
			if (judge_map)
			{
				changeButton(map, 90);
				MAP.disp();
				judge_map = false;
			}
			else
			{
				def_changeButton(map, 90);
				MAP.not_disp();
				judge_map = true;
			}
		}
		
		private function click_fri(e:MouseEvent):void
		{
			trace("フレンド");
			if (judge_fri)
			{
				if (Movie2.click_close)
				{
					changeButton(friend, 75);
					Movie2.open();
					judge_fri = false;
				}
				else
				{
					changeButton(friend, 75);
					Movie2.disp();
					judge_fri = false;
				}
			}
			else
			{
				def_changeButton(friend, 75);
				Movie2.not_disp();
				judge_fri = true;
			}
		}
		
		private function click_oo(e:MouseEvent):void
		{
			trace("( ^ω^)おっおっ");
			if (judge_oo)
			{
				changeButton(oo, 115);
				judge_oo = false;
			}
			else
			{
				def_changeButton(oo, 115);
				judge_oo = true;
			}
		}
		
		private function click_clearthread(e:MouseEvent):void
		{
			def_changeButton(thread, 75);
			judge_thread = true;
		}
		
		private function click_clearScreen(e:MouseEvent):void
		{
			def_changeButton(douga, 75);
			judge_dou = true;
		}
		
		private function click_closeScreen(e:MouseEvent):void
		{
			def_changeButton(douga, 75);
			judge_dou = true;
		}
		
		private function click_clearScreen2(e:MouseEvent):void
		{
			def_changeButton(friend, 75);
			judge_fri = true;
		}
		
		private function click_closeScreen2(e:MouseEvent):void
		{
			def_changeButton(friend, 75);
			judge_fri = true;
		}
		
		private function Resize(e:Event):void
		{
			//ウィンドウ幅取得
			var w:int = Main.mainStage.stageWidth;
			
			//座標変更
			haisin.x = w - 525;
			douga.x = w - 448;
			thread.x = w - 371;
			map.x = w - 294;
			friend.x = w - 202;
			oo.x = w - 125;
			text_hai.x = haisin.x;
			text_dou.x = douga.x;
			text_thread.x = thread.x;
			text_map.x = map.x;
			text_fri.x = friend.x;
			text_oo.x = oo.x;
			
			//テキストフィールド幅再設定
			text_hai.width = haisin.width;
			text_dou.width = douga.width;
			text_thread.width = thread.width;
			text_map.width = map.width;
			text_fri.width = friend.width;
			text_oo.width = oo.width;
		}
	}
}