package LBB
{
	import flash.filters.GlowFilter;
	import net.lifebird.ui.cursor.*;
	import net.lifebird.ui.cursor.plugins.*;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.*;
	import shule.net.NetWorkEvent;
	import shule.net.NetWork;
	import shule.net.Header;
	import shule.world.World;
	
	/**
	 * ...
	 * @author LBB
	 */
	public class Chat extends Sprite
	{
		/*************
		 * 埋め込み画像
		 * ***********/
		
		//出力テキスト　背景
		private var ChatOut_mc:MovieClip;
		[Embed(source = '../data/Chat_Out.png')]
		private var ChatOutBitmap:Class;
		private var ChatOut:Bitmap;
		
		//出力テキスト　サイズ変更ボタン 未選択
		private var LChatTab_mc:MovieClip;
		private var MChatTab_mc:MovieClip;
		private var SChatTab_mc:MovieClip;
		private var OFFChatTab_mc:MovieClip;
		[Embed(source='../data/Tab.png')]
		private var ChatTabBitmap:Class;
		private var LChatTab:Bitmap;
		private var MChatTab:Bitmap;
		private var SChatTab:Bitmap;
		private var OFFChatTab:Bitmap;
		
		//出力テキスト　サイズ変更ボタン 選択中
		private var LTabSelect_mc:MovieClip;
		private var MTabSelect_mc:MovieClip;
		private var STabSelect_mc:MovieClip;
		private var OFFTabSelect_mc:MovieClip;
		[Embed(source='../data/Tab_select.png')]
		private var TabSelectBitmap:Class;
		private var LTabSelect:Bitmap;
		private var MTabSelect:Bitmap;
		private var STabSelect:Bitmap;
		private var OFFTabSelect:Bitmap;
		
		/***************
		 * テキストフィールド
		 * *************/
		
		//出力テキスト
		private var Output_chat:TextField;
		
		//入力テイスト
		private var Input_chat:TextField;
		
		/*******************************
		 * 出力テキスト　サイズ変更ボタン　未選択
		 * *****************************/
		
		//最大
		private var L_Button:TextField;
		
		//通常
		private var M_Button:TextField;
		
		//最小
		private var S_Button:TextField;
		
		//非表示
		private var OFF_Button:TextField;
		
		/*******************************
		 * 出力テキスト　サイズ変更ボタン　選択中
		 * *****************************/
		
		//最大
		private var L_ButtonSelect:TextField;
		
		//通常
		private var M_ButtonSelect:TextField;
		
		//最小
		private var S_ButtonSelect:TextField;
		
		//非表示
		private var OFF_ButtonSelect:TextField;
		
		/********
		 * その他
		 * ******/
		
		private var Chat_format:TextFormat;
		
		public function Chat():void
		{
			//各種初期値設定
			setChat();
			
			// ネットワークイベント追加
			NetWork.addEventListener(Header.PacketChat, onChat);
			NetWork.addEventListener(Header.PacketAddCharactor, onAddCharactor);
			NetWork.addEventListener(Header.PacketRemoveCharactor, onRemoveCharactor);
			NetWork.addEventListener(Header.PacketLiveStart, onLiveStart);
		}
		
		// 配信開始
		public function onLiveStart(event:NetWorkEvent):void
		{
			var fmt:TextFormat = new TextFormat();
			fmt.bold = true;
			fmt.color = 0x00FCF8;

			var s:int = Output_chat.length;
			var text:String = event.id + "さんが配信開始 [" + event.title + "]" + event.detail + "\n";

			Output_chat.appendText(text);
			Output_chat.setTextFormat(fmt, s, s + text.length);
			Output_chat.scrollV = Output_chat.maxScrollV;
		}
		
		// チャット
		public function onChat(event:NetWorkEvent):void
		{
			var fmt:TextFormat = new TextFormat();
			fmt.bold = false;
			fmt.color = 0xffffff;

			var s:int = Output_chat.length;
			var text:String = event.id + " : " + event.message + "\n";

			Output_chat.appendText(text);
			Output_chat.setTextFormat(fmt, s, s + text.length);
			Output_chat.scrollV = Output_chat.maxScrollV;
		}

		// ログイン
		public function onAddCharactor(event:NetWorkEvent):void
		{
			if (event.id != "")
			{
				var fmt:TextFormat = new TextFormat();
				fmt.bold = false;
				fmt.color = 0xF0F000;

				var s:int = Output_chat.length;
				var text:String = event.id + "さんがログインしました\n";
				
				Output_chat.appendText(text);
				Output_chat.setTextFormat(fmt, s, s + text.length);
				Output_chat.scrollV = Output_chat.maxScrollV;
			}
		}

		// ログアウト
		public function onRemoveCharactor(event:NetWorkEvent):void
		{
			if (event.id != "")
			{
				var fmt:TextFormat = new TextFormat();
				fmt.bold = false;
				fmt.color = 0xF0F000;

				var s:int = Output_chat.length;
				var text:String = event.id + "さんがログアウトしました\n";

				Output_chat.appendText(text);
				Output_chat.setTextFormat(fmt, s, s + text.length);
				Output_chat.scrollV = Output_chat.maxScrollV;
			}
		}
		
		/***************
		 * 各種初期値設定
		 * *************/
		
		private function setChat():void
		{
			ChatOut_mc = new MovieClip();
			Chat_format = new TextFormat();
			Output_chat = new TextField();
			
			Input_chat = new TextField();
			
			LChatTab_mc = new MovieClip();
			MChatTab_mc = new MovieClip();
			SChatTab_mc = new MovieClip();
			OFFChatTab_mc = new MovieClip();
			L_Button = new TextField();
			M_Button = new TextField();
			S_Button = new TextField();
			OFF_Button = new TextField();
			
			LTabSelect_mc = new MovieClip();
			MTabSelect_mc = new MovieClip();
			STabSelect_mc = new MovieClip();
			OFFTabSelect_mc = new MovieClip();
			L_ButtonSelect = new TextField();
			M_ButtonSelect = new TextField();
			S_ButtonSelect = new TextField();
			OFF_ButtonSelect = new TextField();
			
			/******************
			 * チャット　出力初期値
			 * ****************/
			/*
			ChatOut_mc.x = 10;
			ChatOut_mc.y = Main.mainStage.stageHeight - 200;
			addChild(ChatOut_mc);
			
			ChatOut = new ChatOutBitmap;
			ChatOut.alpha = 0.6;
			ChatOut.width = 325;
			ChatOut.height = 175;
			ChatOut_mc.addChild(ChatOut);
			
			Chat_format.leading = 1.5;
			
			Output_chat.wordWrap = true;
			Output_chat.background = true;
			Output_chat.backgroundColor = 0x000000;
			//Output_chat.alpha = 0.7;
			Output_chat.textColor = 0xFFFFFF;
			Output_chat.defaultTextFormat = Chat_format;
			
			Output_chat.width = 320;
			Output_chat.height = 150;
			Output_chat.x = 13;
			Output_chat.y = Main.mainStage.stageHeight - 48 - Output_chat.height;
			Output_chat.filters = [new GlowFilter(0, 1, 2, 2, 6)];
			
			addChild(Output_chat);
			*/
			ChatOut_mc.x = 10;
			ChatOut_mc.y = Main.mainStage.stageHeight - 200;
			addChild(ChatOut_mc);
			
			ChatOut = new ChatOutBitmap;
			ChatOut.alpha = 0.6;
			ChatOut.width = 325;
			ChatOut.height = 175;
			ChatOut_mc.addChild(ChatOut);
			
			Chat_format.leading = 1.5;
			
			Output_chat.wordWrap = true;
			Output_chat.defaultTextFormat = Chat_format;
			
			Output_chat.width = 320;
			Output_chat.height = 150;
			Output_chat.x = 13;
			Output_chat.y = Main.mainStage.stageHeight - 50 - Output_chat.height;
			Output_chat.textColor = 0xffffff;
			Output_chat.filters = [new GlowFilter(0, 1, 2, 2, 6)];
			
			addChild(Output_chat);
			/******************
			 * チャット　入力初期値
			 * ****************/
			
			Input_chat.type = TextFieldType.INPUT;
			Input_chat.wordWrap = true;
			Input_chat.background = true;
			Input_chat.border = true;
			Input_chat.borderColor = 0xFDAC05;
			
			Input_chat.width = 320;
			Input_chat.height = 20;
			Input_chat.x = 12;
			Input_chat.y = Main.mainStage.stageHeight - 50;
			
			addChild(Input_chat);
			
			//エンターキーイベント
			Input_chat.addEventListener(KeyboardEvent.KEY_DOWN, Enter);
			
			/*************************************
			 * 出力テキスト　サイズ変更ボタン　未選択 初期値
			 * ***********************************/
			
			//出力サイズ変更ボタン　オーバー時　マウスカーソル変更イベント
			Cursors.init(Main.mainStage);
			FlexCursors.Set();
			
			//最大
			LChatTab = new ChatTabBitmap;
			setTab(LChatTab_mc, LChatTab, L_Button, "L");
			LChatTab_mc.x = 10;
			L_Button.name = "L";
			LChatTab_mc.name = "L_mc";
			
			//通常
			MChatTab = new ChatTabBitmap;
			setTab(MChatTab_mc, MChatTab, M_Button, "M");
			MChatTab_mc.x = 10 + LChatTab_mc.width;
			MChatTab_mc.visible = false;
			M_Button.name = "M";
			MChatTab_mc.name = "M_mc";
			
			//最小
			SChatTab = new ChatTabBitmap;
			setTab(SChatTab_mc, SChatTab, S_Button, "S");
			SChatTab_mc.x = MChatTab_mc.x + MChatTab_mc.width;
			S_Button.name = "S";
			SChatTab_mc.name = "S_mc";
			
			//非表示
			OFFChatTab = new ChatTabBitmap;
			setTab(OFFChatTab_mc, OFFChatTab, OFF_Button, "OFF");
			OFFChatTab_mc.x = SChatTab_mc.x + SChatTab_mc.width;
			OFF_Button.name = "OFF";
			OFFChatTab_mc.name = "OFF_mc";
			
			/*************************************
			 * 出力テキスト　サイズ変更ボタン　選択中　初期値
			 * ***********************************/
			
			//最大
			LTabSelect = new TabSelectBitmap;
			setTab(LTabSelect_mc, LTabSelect, L_ButtonSelect, "L");
			LTabSelect_mc.x = 10;
			LTabSelect_mc.visible = false;
			L_ButtonSelect.name = "LSelect";
			LTabSelect_mc.name = "LSelect_mc";
			
			//通常
			MTabSelect = new TabSelectBitmap;
			setTab(MTabSelect_mc, MTabSelect, M_ButtonSelect, "M");
			MTabSelect_mc.x = 10 + LTabSelect_mc.width;
			M_ButtonSelect.name = "MSelect";
			MTabSelect_mc.name = "MSelect_mc";
			
			//最小
			STabSelect = new TabSelectBitmap;
			setTab(STabSelect_mc, STabSelect, S_ButtonSelect, "S");
			STabSelect_mc.x = MTabSelect_mc.x + MTabSelect_mc.width;
			STabSelect_mc.visible = false;
			S_ButtonSelect.name = "SSelect";
			STabSelect_mc.name = "SSelect_mc";
			
			//非表示
			OFFTabSelect = new TabSelectBitmap;
			setTab(OFFTabSelect_mc, OFFTabSelect, OFF_ButtonSelect, "OFF");
			OFFTabSelect_mc.x = STabSelect_mc.x + STabSelect_mc.width;
			OFFTabSelect_mc.visible = false;
			OFF_ButtonSelect.name = "OFFSelect";
			OFFTabSelect_mc.name = "OFFSelect_mc";
			
			/**************************
			 * stege　リサイズ時　イベント登録
			 * ************************/
			
			Main.mainStage.addEventListener(Event.RESIZE, Chat_Resize);
		}
		
		/*******************
		 * ボタン　共通要素設定
		 * *****************/
		
		private function setTab(mc:MovieClip, bit:Bitmap, tf:TextField, text:String):void
		{
			mc.y = Main.mainStage.stageHeight - 50 + 22;
			
			bit.width = 81.25;
			bit.height = 20;
			
			var format:TextFormat = new TextFormat();
			format.bold = true;
			
			tf.defaultTextFormat = format;
			tf.text = text;
			tf.selectable = false;
			tf.width = 81.25;
			tf.height = 20;
			tf.autoSize = TextFieldAutoSize.CENTER;
			
			mc.addChild(bit);
			mc.addChild(tf);
			addChild(mc);
			
			mc.addEventListener(MouseEvent.MOUSE_DOWN, Button_down);
			
			Cursors.addHoverCursor(mc, CursorType.POINTER, CursorType.DEFAULT);
		}
		
		/*****************
		 * エンターキーイベント
		 * ***************/
		
		private function Enter(e:KeyboardEvent):void
		{
			if ((e.keyCode == Keyboard.ENTER) && (Input_chat.text.length > 0))
			{
				// チャットパケット送信
				NetWork.sendChat(Input_chat.text);
				
				// チャットバルーン表示
				World.myChara.showChat(Input_chat.text);
				
				// チャット欄に表示
				var fmt:TextFormat = new TextFormat();
				fmt.bold = false;
				fmt.color = 0xffffff;

				var s:int = Output_chat.length;
				var text:String = Main.myID + " : " + Input_chat.text + "\n";

				Output_chat.appendText(text);
				Output_chat.setTextFormat(fmt, s, s + text.length);
				Output_chat.scrollV = Output_chat.maxScrollV;

				Input_chat.text = "";
			}
		}
		
		/*************
		 * ボタンイベント
		 * ***********/
		
		//マウス　ダウンイベント
		private function Button_down(e:MouseEvent):void
		{
			//最大
			if (e.target.name == "L" || e.target.name == "L_mc")
			{
				LTabSelect.height += 5;
				L_ButtonSelect.y += 5;
				
				LTabSelect_mc.visible = true;
				MTabSelect_mc.visible = false;
				STabSelect_mc.visible = false;
				OFFTabSelect_mc.visible = false;
				
				LChatTab_mc.visible = false;
				MChatTab_mc.visible = true;
				SChatTab_mc.visible = true;
				OFFChatTab_mc.visible = true;
				
				LTabSelect_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
				LTabSelect_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//通常
			else if (e.target.name == "M" || e.target.name == "M_mc")
			{
				MTabSelect.height += 5;
				M_ButtonSelect.y += 5;
				
				LTabSelect_mc.visible = false;
				MTabSelect_mc.visible = true;
				STabSelect_mc.visible = false;
				OFFTabSelect_mc.visible = false;
				
				LChatTab_mc.visible = true;
				MChatTab_mc.visible = false;
				SChatTab_mc.visible = true;
				OFFChatTab_mc.visible = true;
				
				MTabSelect_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
				MTabSelect_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//小
			else if (e.target.name == "S" || e.target.name == "S_mc")
			{
				STabSelect.height += 5;
				S_ButtonSelect.y += 5;
				
				LTabSelect_mc.visible = false;
				MTabSelect_mc.visible = false;
				STabSelect_mc.visible = true;
				OFFTabSelect_mc.visible = false;
				
				LChatTab_mc.visible = true;
				MChatTab_mc.visible = true;
				SChatTab_mc.visible = false;
				OFFChatTab_mc.visible = true;
				
				STabSelect_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
				STabSelect_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//非表示
			else if (e.target.name == "OFF" || e.target.name == "OFF_mc")
			{
				OFFTabSelect.height += 5;
				OFF_ButtonSelect.y += 5;
				
				LTabSelect_mc.visible = false;
				MTabSelect_mc.visible = false;
				STabSelect_mc.visible = false;
				OFFTabSelect_mc.visible = true;
				
				LChatTab_mc.visible = true;
				MChatTab_mc.visible = true;
				SChatTab_mc.visible = true;
				OFFChatTab_mc.visible = false;
				
				OFFTabSelect_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
				OFFTabSelect_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
		}
		
		//マウス　アップイベント
		private function Button_up(e:MouseEvent):void
		{
			//最大
			if (e.target.name == "LSelect" || e.target.name == "LSelect_mc")
			{
				LTabSelect.height -= 5;
				L_ButtonSelect.y -= 5;
				
				Output_chat.height = 300;
				Output_chat.y = Main.mainStage.stageHeight - 48 - Output_chat.height;
				ChatOut_mc.height = 325;
				ChatOut_mc.y = Main.mainStage.stageHeight - 352;
				
				LTabSelect_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
				LTabSelect_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//通常
			else if (e.target.name == "MSelect" || e.target.name == "MSelect_mc")
			{
				MTabSelect.height -= 5;
				M_ButtonSelect.y -= 5;
				
				Output_chat.height = 150;
				Output_chat.y = Main.mainStage.stageHeight - 48 - Output_chat.height;
				ChatOut_mc.height = 175;
				ChatOut_mc.y = Main.mainStage.stageHeight - 200;
				
				MTabSelect_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
				MTabSelect_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//最小
			else if (e.target.name == "SSelect" || e.target.name == "SSelect_mc")
			{
				STabSelect.height -= 5;
				S_ButtonSelect.y -= 5;
				
				Output_chat.height = 75;
				Output_chat.y = Main.mainStage.stageHeight - 48 - Output_chat.height;
				ChatOut_mc.height = 100;
				ChatOut_mc.y = Main.mainStage.stageHeight - 125;
				
				STabSelect_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
				STabSelect_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//非表示
			else if (e.target.name == "OFFSelect" || e.target.name == "OFFSelect_mc")
			{
				OFFTabSelect.height -= 5;
				OFF_ButtonSelect.y -= 5;
				
				Output_chat.height = 0;
				Output_chat.y = Input_chat.y;
				ChatOut_mc.height = 25;
				ChatOut_mc.y = Input_chat.y;
				
				OFFTabSelect_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
				OFFTabSelect_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
		}
		
		/************
		 * リサイズ処理
		 * **********/
		
		//ブラウザサイズ変更
		private function Chat_Resize(e:Event):void
		{
			ChatOut_mc.y = Main.mainStage.stageHeight - 50 - Output_chat.height;
			Output_chat.y = Main.mainStage.stageHeight - 50 - Output_chat.height;
			Input_chat.y = Main.mainStage.stageHeight - 50;
			LChatTab_mc.y = Main.mainStage.stageHeight - 50 + 22;
			MChatTab_mc.y = Main.mainStage.stageHeight - 50 + 22;
			SChatTab_mc.y = Main.mainStage.stageHeight - 50 + 22;
			OFFChatTab_mc.y = Main.mainStage.stageHeight - 50 + 22;
			LTabSelect_mc.y = Main.mainStage.stageHeight - 50 + 22;
			MTabSelect_mc.y = Main.mainStage.stageHeight - 50 + 22;
			STabSelect_mc.y = Main.mainStage.stageHeight - 50 + 22;
			OFFTabSelect_mc.y = Main.mainStage.stageHeight - 50 + 22;
		}
	}
}