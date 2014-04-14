package shule 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.display.Stage;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import shule.net.NetWork;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.system.Security;
	import shule.net.ServerConnect;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author shule
	 */
	public class LoginScreen extends Sprite
	{
		// mainのstage
		private var mainStage:Stage;
		
		// ログインタイマー
		public var loginTimer:Timer = new Timer(1500, 0);
		
		// テキストフィールド
		private var textFieldID:TextField = new TextField();
		private var textField:TextField = new TextField();
		private var textField2:TextField = new TextField();
		
		// 画像データ
		[Embed(source='/data/login.png')]
        private var imageLogin:Class;
		
		public function getID():String
		{
			return textFieldID.text;
		}

		// コンストラクタ
		public function LoginScreen(mainStage:Stage)
		{
			this.mainStage = mainStage;
			init();
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		}
	
		// 初期化
		private function init():void
		{
			// ロゴ表示
			var bitmap: Bitmap = new imageLogin;
			bitmap.x = 50;
			bitmap.y = 50;
			addChild(bitmap);
			
			/*
			// 背景を青色
			var bg_shape:Shape = new Shape();
			bg_shape.graphics.beginFill(0xDCECFF);　//　RGB値:0xRRGGBB形式
			bg_shape.graphics.drawRect(0, 0, mainStage.stageWidth, mainStage.stageHeight);
			addChildAt(bg_shape, 0); 　//　表示リストレイヤー0に矩形を追加
			*/
			
			// テキスト
			textField.htmlText = "<font size = \"20\"><b>名前ヲ入力シテクダサイ</b></font>";
			textField.textColor = 0x000000;
			textField.autoSize = "center";
			textField.x = 245 + 50;
			textField.y = 255 + 50;
			addChild(textField);

			// テキスト2
			textField2.htmlText = "<font size = \"20\"><b>名前入力後 → Enter or DoubleClick</b></font>";
			textField2.textColor = 0xffffff;
			textField2.autoSize = "center";
			textField2.selectable = false;
			textField2.filters = [new GlowFilter(0, 1, 20, 20, 5)];
			textField2.x = 245 + 50;
			textField2.y = 255 + 50 + 200;
			addChild(textField2);

			// IDテキストボックス
			textFieldID.border = true;
			textFieldID.background = true;
			textFieldID.backgroundColor = 0xFFFFFF;
			textFieldID.width = 140;
			textFieldID.height = 20;
			textFieldID.x = 480 + 50;
			textFieldID.y = 422 + 50;
			textFieldID.type = TextFieldType.INPUT
			addChild(textFieldID);
			textFieldID.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		// ログイン処理
		private function login():void
		{
			if (textFieldID.text == "")// || (textFieldPW.text.length < 6))
			{
				textField.htmlText = "<font size = \"20\"><b>空白以外デ オ願イシマス</b></font>";
				trace("ID：空白以外でお願いします");//、PW：6文字以上");
			}
			else if (textFieldID.type == TextFieldType.INPUT)
			{
				// ログイン処理
				trace("ログイン(id:" + textFieldID.text);// + " pw:" + textFieldPW.text + ")");
				NetWork.login(textFieldID.text, "PassWord");
			
				// 入力禁止にする
				setReadOnly(true, "<font size = \"20\"><b>ログイン中デス...</b></font>");
				
				loginTimer.stop();
				loginTimer.addEventListener(TimerEvent.TIMER, onTimer);
				loginTimer.start();
			}
		}
		
		// キーダウン
		private function onKeyDown(event:KeyboardEvent):void
		{
			// エンター
			if (event.keyCode == 13)
			{
				login();
			}
		}
		
		// マウスダウン
		private function onDoubleClick(event:Event):void
		{
			login();
		}

		// 何度かログイン
		public function onTimer(event:Event):void
		{
			NetWork.login(textFieldID.text, "PassWord");
		}
		
		// 入力禁止にする
		public function setReadOnly(b:Boolean, str:String):void
		{
			textField.htmlText = str;
			textField.textColor = 0x000000;
			if (b)
			{
				// ReadOnly
				textFieldID.type = TextFieldType.DYNAMIC;
				//textFieldPW.type = TextFieldType.DYNAMIC;
			}
			else
			{
				// 入力可能
				textFieldID.type = TextFieldType.INPUT;
				//textFieldPW.type = TextFieldType.INPUT;
			}
		}
	}
}
