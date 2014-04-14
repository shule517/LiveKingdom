 package LBB
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import shule.net.NetWork;
	import shule.world.World;
	
	public class TittleBar extends Sprite
	{
		/*************
		 * 埋め込み画像
		 * ***********/
		
		//背景
		private var TittleBar_mc:MovieClip;
		[Embed(source='../data/TittleBar.png')]
		private var BarBitmap:Class;
		private var Bar:Bitmap;
		
		//タイトル
/*		[Embed(source='../data/Tittle.GIF')]
		private var TittleNameBitmap:Class;
		private var TittleName:Bitmap;
*/		
		
		//マップサイズ変更ボタン 最大
		private var LButton_mc:MovieClip;
		[Embed(source='../data/MapSize_L2.GIF')]
		private var LBitmap:Class;
		private var LButton:Bitmap;
		
		//マップサイズ変更ボタン 中
		private var MButton_mc:MovieClip;
		[Embed(source='../data/MapSize_M2.GIF')]
		private var MBitmap:Class;
		private var MButton:Bitmap;
		
		//マップサイズ変更ボタン 最小
		private var SButton_mc:MovieClip;
		[Embed(source='../data/MapSize_S2.GIF')]
		private var SBitmap:Class;
		private var SButton:Bitmap;
		
		//おっおっボタン
		private var OButton_mc:MovieClip;
		[Embed(source='../data/OButton2.GIF')]
		private var OBitmap:Class;
		private var OButton:Bitmap;
		
		//配信開始ボタン
		private var LiveButton_mc:MovieClip;
		[Embed(source = '../data/LiveButton.GIF')]
		private var LiveButtonBitmap:Class;
		private var LiveButton:Bitmap;
		
		//配信禁止ボタン
		public var Not_mc:MovieClip;
		[Embed(source = '../data/Not.GIF')]
		private var NotBitmap:Class;
		private var Not:Bitmap;
		
		/********
		 * その他
		 * ******/
		
		//ログイン人数
		private var Login:TextField;
		
		//ユーザー名
		private var UserName:TextField;
		
		//「マップサイズ」　テキスト
		private var MapText:TextField;
		
		//フォーマット
		private var format:TextFormat;
		
		public function TittleBar():void
		{
			//タイトルバー初期値設定
			setTittle();
			
			//ユーザー名表示
			getName(Main.myID);
			
			//デバック用
			//getNumber(20);
		}
		
		/********************
		 * タイトルバー初期値設定
		 * ******************/
		
		private function setTittle():void
		{
			TittleBar_mc = new MovieClip();
			format = new TextFormat();
			Login = new TextField();
			UserName = new TextField();
			MapText = new TextField();
			LButton_mc = new MovieClip();
			MButton_mc = new MovieClip();
			SButton_mc = new MovieClip();
			OButton_mc = new MovieClip();
			LiveButton_mc = new MovieClip();
			Not_mc = new MovieClip();
			
			/******************
			 * タイトルバー　初期値
			 * ****************/
			
			TittleBar_mc.x = 10;
			TittleBar_mc.y = 5;
			addChild(TittleBar_mc);
			
			Bar = new BarBitmap;
			Bar.width = 600;
			TittleBar_mc.addChild(Bar);
			
			/*****************
			 * タイトル名　初期値
			 * ***************/
			/*
			TittleName = new TittleNameBitmap;
			TittleName.width = 200;
			TittleName.height = 90;
			TittleBar_mc.addChild(TittleName);
			
			/********************
			 * 配信開始ボタン　初期値
			 * ******************/
			
			LiveButton_mc.x = 20;
			LiveButton_mc.y = 10;
			TittleBar_mc.addChild(LiveButton_mc);
			LiveButton_mc.name = "Live";
			
			LiveButton = new LiveButtonBitmap;
			LiveButton.width = 80;
			LiveButton.height = 30;
			LiveButton_mc.addChild(LiveButton);
			
			LiveButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, ButtonCelect);
			
			//配信フレーム表示　イベント
			LiveButton_mc.addEventListener(MouseEvent.CLICK, Open_LiveWindow);
			
			/********************
			 * 配信禁止ボタン　初期値
			 * ******************/
			
			Not_mc.x = LiveButton_mc.x;
			Not_mc.y = LiveButton_mc.y;
			TittleBar_mc.addChild(Not_mc);
			Not_mc.name = "Not";
			Not_mc.visible = false;
			
			Not = new NotBitmap;
			Not.alpha = 0.7;
			Not.width = 80;
			Not.height = 30;
			Not_mc.addChild(Not);
			
			/***********************************************
			 * ログイン人数　ユーザー名　マップサイズテキスト　共通フォーマット
			 * *********************************************/
			
			format.size = 13; 
			//format.bold = true;
			
			/******************
			 * ログイン人数　初期値
			 * ****************/
			
/*			Login.defaultTextFormat = format;
			Login.text = "ログイン人数 ： ";
			Login.x = LiveButton_mc.x + LiveButton_mc.width + 10;
			Login.y = 5;
			Login.width = Login.textWidth + 6;
			Login.height = 20;
			TittleBar_mc.addChild(Login);
			
			/*****************
			 * ユーザー名　初期値
			 * ***************/
			
			UserName.defaultTextFormat = format;
			UserName.text = "ユーザー名 ： ";
			UserName.x = LiveButton_mc.x + LiveButton_mc.width + 10;
			UserName.y = 15;
			UserName.width = UserName.textWidth + 6;
			UserName.height = 20;
			TittleBar_mc.addChild(UserName);
			
			/*******************
			 * おっおっボタン　初期値
			 * *****************/
			
			OButton_mc.x = UserName.x + UserName.width + 10;
			OButton_mc.y = 10;
			TittleBar_mc.addChild(OButton_mc);
			OButton_mc.name = "OButton";
			
			OButton = new OBitmap;
			OButton.width = 80;
			OButton.height = 30;
			OButton_mc.addChild(OButton);
			
			OButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, ButtonCelect);
			
			OButton_mc.addEventListener(MouseEvent.CLICK, Open_Screen);
			
			/*****************
			 * マップサイズ　テキスト
			 * ***************/
			
			//フォーマット追加
			format.bold = true;
			
			MapText.selectable = false;
			MapText.defaultTextFormat = format;
			MapText.text = "マップサイズ";
			MapText.width = MapText.textWidth + 6;
			MapText.height = 20;
			MapText.x = OButton_mc.x + OButton_mc.width + 10;
			MapText.y = 15;
			TittleBar_mc.addChild(MapText);
			
			/****************
			 * マップサイズ　最大
			 * **************/
			
			LButton_mc.x = MapText.x +MapText.width + 2;
			LButton_mc.y = 15;
			TittleBar_mc.addChild(LButton_mc);
			LButton_mc.name = "LButton";
			
			LButton = new LBitmap;
			LButton.width = 70;
			LButton.height = 20;
			LButton_mc.addChild(LButton);
			
			LButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, ButtonCelect);
			
			/**************
			 * マップサイズ　中
			 * ************/
			
			MButton_mc.x = LButton_mc.x + LButton_mc.width + 2;
			MButton_mc.y = 15
			TittleBar_mc.addChild(MButton_mc);
			MButton_mc.name = "MButton";
			
			MButton = new MBitmap;
			MButton.width = 70;
			MButton.height = 20;
			MButton_mc.addChild(MButton);
			
			MButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, ButtonCelect);
			
			/****************
			 * マップサイズ　最小
			 * **************/
			
			SButton_mc.x = MButton_mc.x + MButton_mc.width + 2;
			SButton_mc.y = 15;
			TittleBar_mc.addChild(SButton_mc);
			SButton_mc.name = "SButton";
			
			SButton = new SBitmap;
			SButton.width = 70;
			SButton.height = 20;
			SButton_mc.addChild(SButton);
			
			SButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, ButtonCelect);
			
			/*****************
			 * タイトルバー　幅調整
			 * ***************/
			
			ChangeBarWidth();
			Bar.height = 50;
		}
		
		/*****************
		 * ログイン人数　設定
		 * ***************/
		
		private function getNumber(i:uint):void
		{
			if (0 < i && i <= 4294967295)
			{
				Login.text = "ログイン人数 ： " + String(i);
			}
			else
			{
				Login.text = "ログイン人数 ： 4,294,967,295以上";
			}
			Login.width = Login.textWidth + 6;
			ChangeBarWidth();
		}
		
		/****************
		 * ユーザー名　設定
		 * **************/
		
		private function getName(name:String):void
		{
			UserName.text = "ユーザー名 ： " + name;
			UserName.width = UserName.textWidth + 6;
			ChangeBarWidth();
		}
		
		/*****************
		 * タイトルバー　幅調整
		 * ***************/
		
		private function ChangeBarWidth():void
		{
/*			if (UserName.width > Login.width)
			{
				OButton_mc.x = UserName.x + UserName.width + 10;
			}
			else
			{
				OButton_mc.x = Login.x + Login.width + 10;
			}*/
			OButton_mc.x = UserName.x + UserName.width + 10;
			MapText.x = OButton_mc.x + OButton_mc.width + 10;
			LButton_mc.x = MapText.x + MapText.width + 2;
			MButton_mc.x = LButton_mc.x + LButton_mc.width + 2;
			SButton_mc.x = MButton_mc.x + MButton_mc.width + 2;
			Bar.width = SButton_mc.x + SButton_mc.width + 20;
		}
		
		private function ButtonCelect(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "LButton":
					LButton_mc.x += 1;
					LButton_mc.y += 1;
					LButton_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
					LButton_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
					break;
					
				case "MButton":
					MButton_mc.x += 1;
					MButton_mc.y += 1;
					MButton_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
					MButton_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
					break;
					
				case "SButton":
					SButton_mc.x += 1;
					SButton_mc.y += 1;
					SButton_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
					SButton_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
					break;
					
				case "OButton":
					OButton_mc.x += 1;
					OButton_mc.y += 1;
					OButton_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
					OButton_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
					break;
					
				case "Live":
					LiveButton_mc.x += 1;
					LiveButton_mc.y += 1;
					LiveButton_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
					LiveButton_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
					break;
			}
		}
		
		private function Button_up(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "LButton":
					LButton_mc.x -= 1;
					LButton_mc.y -= 1;
					LButton_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
					LButton_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
					Main.world.setMapSize(0.4);
					break;
					
				case "MButton":
					MButton_mc.x -= 1;
					MButton_mc.y -= 1;
					MButton_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
					MButton_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
					Main.world.setMapSize(0.7);
					break;
					
				case "SButton":
					SButton_mc.x -= 1;
					SButton_mc.y -= 1;
					SButton_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
					SButton_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
					Main.world.setMapSize(1.0);
					break;
					
				case "OButton":
					OButton_mc.x -= 1;
					OButton_mc.y -= 1;
					OButton_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
					OButton_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);

					// おっおっ
//					NetWork.sendOxOx();
//					World.myChara.playOxOx();
					break;
					
				case "Live":
					LiveButton_mc.x -= 1;
					LiveButton_mc.y -= 1;
					LiveButton_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
					LiveButton_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
					break;
			}
		}
		
		/******************
		 * ボタン クリックイベント
		 * ****************/
		
		//配信開始ボタン
		private function Open_LiveWindow(e:MouseEvent):void
		{
			dispatchEvent(new Event("open"));
			Not_mc.visible = true;
			
			//翔太　要追記
			
		}
		
		//おっおっボタン
		private function Open_Screen(e:MouseEvent):void
		{
			//翔太　要追記
			NetWork.sendOxOx();
			World.myChara.playOxOx();
		}
	}
}