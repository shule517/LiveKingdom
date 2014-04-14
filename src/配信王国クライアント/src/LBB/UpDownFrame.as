 package LBB
{
	import net.lifebird.ui.cursor.*;
	import jp.atziluth.utils.Cleaner;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author LBB
	 */
	public class UpDownFrame extends SideFrame
	{
		/*************
		 * 埋め込み画像
		 * ***********/
		
		//上下スライドバー
		protected var Bit_mc:MovieClip;
		[Embed(source='../data/UpDownTab.png')]
		private var imagebitmap:Class;
		private	var bitmap:Bitmap;
		
		//最背面フレーム
		protected var Frame_mc:MovieClip;
		[Embed(source='../data/Frame.png')]
		private var FrameBitmap:Class;
		protected var Frame:Bitmap;
		
		//上下タイトルバー
		[Embed(source='../data/Bar.png')]
		private var BarBitmap:Class;
		protected var UpBar:Bitmap;
		protected var DownBar:Bitmap;
		
		//上段クローズボタン
		protected var UpClose_mc:MovieClip;
		[Embed(source='../data/Close.GIF')]
		private var CloseBitmap:Class;
		private var UpClose:Bitmap;
		
		//上下段最小化ボタン
		protected var UpMin_mc:MovieClip;
		protected var DownMin_mc:MovieClip;
		[Embed(source='../data/Min.GIF')]
		private var MinBitmap:Class;
		private var UpMin:Bitmap;
		private var DownMin:Bitmap;
		
		//上下段復元化ボタン
		protected var Re_UpMin_mc:MovieClip;
		protected var Re_DownMin_mc:MovieClip;
		[Embed(source='../data/Re_Min.GIF')]
		private var Re_MinBitmap:Class;
		private var Re_UpMin:Bitmap;
		private var Re_DownMin:Bitmap;
		
		/********
		 * その他
		 * ******/
		
		//上下バー可動範囲指定
		protected var UpDown_bounds:Rectangle;
		
		//Down_bg　高さ　固定値
		private var Down_bg_height:Number;
		
		//最小化前　上下スライドバー　Y値
		private var Before_Bit_y:Number;
		
		//上段MC&背景
		protected var Up_mc:MovieClip;
		protected var Up_bg:Sprite
		
		//下段MC&背景
		protected var Down_mc:MovieClip;
		protected var Down_bg:Sprite
		
		//最小化ボタン(=true)　復元化ボタン(=false)
		private var UpMinBotton_Flag:Boolean = true;
		private var DownMinBotton_Flag:Boolean = true;
		
		//下段最小化時(=true) 下段通常時(=false)
		private var DownMin_Flag:Boolean = false;
		
		public function UpDownFrame():void
		{
			//各種初期値設定
			setUpDown_mc();
			
			//上下スライド処理
			moveUpDown_mc();
			
			//ボタンイベント
			setButton();
		}
		
		/***************
		 * 各種初期値設定
		 * *************/
		
		private function setUpDown_mc():void
		{
			Bit_mc = new MovieClip();
			Frame_mc = new MovieClip();
			Up_mc = new MovieClip();
			Up_bg = new Sprite();
			Down_mc = new MovieClip();
			Down_bg = new Sprite();
			UpClose_mc = new MovieClip();
			UpMin_mc = new MovieClip();
			DownMin_mc = new MovieClip();
			Re_UpMin_mc = new MovieClip();
			Re_DownMin_mc = new MovieClip();
			
			/***************
			 * フレーム　初期値
			 * *************/
			
			Frame_mc.x = Side_mc.x;
			addChild(Frame_mc);
			
			Frame = new FrameBitmap;
			Frame.width = Side_mc.width;
			Frame.height = Side_mc.height / 2 - 50;
//			Frame.height = Main.mainStage.stageHeight;
			Frame_mc.addChild(Frame);
			
			/********************
			 * 上下スライドバー初期値
			 * ******************/
			
			Bit_mc.x = Side_mc.x;
			Bit_mc.y = Side_mc.height / 2 - 50;
			addChild(Bit_mc);
			
			bitmap = new imagebitmap;
			bitmap.width = Side_mc.width;
			Bit_mc.addChild(bitmap);
			
			//スライドバー　オーバー時　マウスカーソル変更イベント
			Cursors.addDragCursor(Bit_mc, CursorType.V_RESIZE, CursorType.V_RESIZE, CursorType.DEFAULT);
			
			/********************
			 * 上段タイトルバー初期値
			 * ******************/
			
			UpBar = new BarBitmap;
			UpBar.width = Frame.width;
			Frame_mc.addChild(UpBar);
			
			/********************
			 * 下段タイトルバー初期値
			 * ******************/
			
			DownBar = new BarBitmap;
			DownBar.y = Bit_mc.y + Bit_mc.height;
			DownBar.width = UpBar.width;
			Frame_mc.addChild(DownBar);
			
			/******************
			 * 上段ウィンドウ初期値
			 * ****************/
			
			Up_mc.x = 8;
			Up_mc.y = UpBar.height + 5;
			Frame_mc.addChild(Up_mc);
			
			Up_bg.graphics.beginFill(0x555555);
			Up_bg.graphics.drawRect(0, 0, Frame.width - 16, Bit_mc.y - UpBar.height - 10);
			Up_bg.graphics.endFill();
			Up_mc.addChild(Up_bg);
			
			/******************
			 * 下段ウィンドウ初期値
			 * ****************/
			
//			Down_mc.x = Up_mc.x;
//			Down_mc.y = DownBar.y + DownBar.height + 5;
			Down_mc.y = DownBar.y + DownBar.height;
			Frame_mc.addChild(Down_mc);
			
			Down_bg.graphics.beginFill(0x333333, 0);
//			Down_bg.graphics.drawRect(0, 0, Up_bg.width, Frame_mc.height - 5 - (DownBar.y + DownBar.height) - 10);
			Down_bg.graphics.drawRect(0, 0, Frame.width, Main.mainStage.stageHeight - (DownBar.y + DownBar.height));
			Down_bg.graphics.endFill();
			Down_mc.addChild(Down_bg);
			
			//Down_bg　高さ　固定値
//			Down_bg_height = Frame_mc.height - 5  - DownBar.height - 10;
			Down_bg_height = Frame_mc.height - DownBar.height;
			
			/*********************
			 * 上段クローズボタン初期値
			 * *******************/
			
			UpClose_mc.name = "UpClose";
			UpClose_mc.x = UpBar.width - 20;
			UpClose_mc.y = 5;
			Frame_mc.addChild(UpClose_mc);
			
			UpClose = new CloseBitmap;
			UpClose_mc.addChild(UpClose);
			
			/*********************
			 * 上段最小化ボタン初期値
			 * *******************/
			
			UpMin_mc.name = "UpMin";
			UpMin_mc.x = UpClose_mc.x - 20;
			UpMin_mc.y = 5;
			Frame_mc.addChild(UpMin_mc);
			
			UpMin = new MinBitmap;
			UpMin_mc.addChild(UpMin);
			
			/*********************
			 * 下段最小化ボタン初期値
			 * *******************/
			
			DownMin_mc.name = "DownMin";
			DownMin_mc.x = UpClose_mc.x;
			DownMin_mc.y = DownBar.y + 5;
			Frame_mc.addChild(DownMin_mc);
			
			DownMin = new MinBitmap;
			DownMin_mc.addChild(DownMin);
			
			/*********************
			 * 上段復元化ボタン初期値
			 * *******************/
			
			 Re_UpMin_mc.name = "Re_UpMin";
			Re_UpMin_mc.x = UpMin_mc.x;
			Re_UpMin_mc.y = UpMin_mc.y;
			Re_UpMin_mc.visible = false;
			Frame_mc.addChild(Re_UpMin_mc);
			
			Re_UpMin = new Re_MinBitmap;
			Re_UpMin_mc.addChild(Re_UpMin);
			
			/*********************
			 * 下段最小化ボタン初期値
			 * *******************/
			
			Re_DownMin_mc.name = "Re_DownMin";
			Re_DownMin_mc.x = DownMin_mc.x;
			Re_DownMin_mc.y = DownMin_mc.y;
			Frame_mc.addChild(Re_DownMin_mc);
			Re_DownMin_mc.visible = false;
			
			Re_DownMin = new Re_MinBitmap;
			Re_DownMin_mc.addChild(Re_DownMin);
		}
		
		
		/***************
		 * 上下スライド処理
		 * *************/
		
		private function moveUpDown_mc():void
		{
			Bit_mc.addEventListener(MouseEvent.MOUSE_DOWN, down);
		}
		
		//マウス　ダウンイベント
		protected function down(e:MouseEvent):void
		{
			//スライドバー可動範囲指定
			UpDown_bounds = new Rectangle(Side_mc.x, UpBar.height, 0, Frame_mc.height - UpBar.height - Bit_mc.height - DownBar.height - 36);
			
			//ドラッグ開始
			Bit_mc.startDrag(false, UpDown_bounds);
			
			//マウス　ダウン時　イベント登録
			Bit_mc.addEventListener(Event.ENTER_FRAME, drawingHandler);
			Bit_mc.addEventListener (MouseEvent.MOUSE_MOVE, move);   
			Bit_mc.addEventListener(MouseEvent.MOUSE_UP, up);
			Main.mainStage.addEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		//マウス　ダウン時　毎フレームイベント
		private function drawingHandler(e:Event):void
		{
			//上下リサイズ処理
			UpDownFrame_Resize();
		}
		
		//ドラッグイベント
		private function move(e:MouseEvent):void
		{
			e.updateAfterEvent();
		}
		
		//マウス　アップイベント
		private function up(e:MouseEvent):void
		{
			//ドラッグ　停止
			Bit_mc.stopDrag();
			
			//上下リサイズ処理
			UpDownFrame_Resize();
			
			//イベント　登録解除
			Bit_mc.removeEventListener(Event.ENTER_FRAME, drawingHandler);
			Bit_mc.removeEventListener(MouseEvent.MOUSE_MOVE, move);
			Bit_mc.removeEventListener(MouseEvent.MOUSE_UP, up);
			Main.mainStage.removeEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		/************
		 * ボタンイベント
		 * **********/
		
		private function setButton ():void
		{
			//マウス　ダウンイベント群
			UpClose_mc.addEventListener(MouseEvent.MOUSE_DOWN, Button_down);
			UpMin_mc.addEventListener(MouseEvent.MOUSE_DOWN, Button_down);
			DownMin_mc.addEventListener(MouseEvent.MOUSE_DOWN, Button_down);
			Re_UpMin_mc.addEventListener(MouseEvent.MOUSE_DOWN, Button_down);
			Re_DownMin_mc.addEventListener(MouseEvent.MOUSE_DOWN, Button_down);
			
			//マウス　クリックイベント群
			UpClose_mc.addEventListener(MouseEvent.CLICK, Upclose_click);
			UpMin_mc.addEventListener(MouseEvent.CLICK, UpMin_click);
			DownMin_mc.addEventListener(MouseEvent.CLICK, DownMin_click);
			Re_UpMin_mc.addEventListener(MouseEvent.CLICK, Re_UpMin_click);
			Re_DownMin_mc.addEventListener(MouseEvent.CLICK, Re_DownMin_click);
		}

		//マウス　ダウンイベント
		private function Button_down(e:MouseEvent):void
		{
			//上段クローズボタン
			if (e.target.name == "UpClose")
			{
				UpClose_mc.x += 1;
				UpClose_mc.y += 1;
				UpClose_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
				UpClose_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//上段最小化ボタン
			else if (e.target.name == "UpMin")
			{
				UpMin_mc.x += 1;
				UpMin_mc.y += 1;
				UpMin_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
				UpMin_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//下段最小化ボタン
			else if (e.target.name == "DownMin")
			{
				DownMin_mc.x += 1;
				DownMin_mc.y += 1;
				DownMin_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
				DownMin_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//上段復元化ボタン
			else if (e.target.name == "Re_UpMin")
			{
				Re_UpMin_mc.x += 1;
				Re_UpMin_mc.y += 1;
				Re_UpMin_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
				Re_UpMin_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//下段復元化ボタン
			else if (e.target.name == "Re_DownMin")
			{
				Re_DownMin_mc.x += 1;
				Re_DownMin_mc.y += 1;
				Re_DownMin_mc.addEventListener(MouseEvent.MOUSE_UP, Button_up);
				Re_DownMin_mc.addEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
		}
		
		//マウス　アップイベント
		private function Button_up(e:MouseEvent):void
		{
			//上段クローズボタン
			if (e.target.name == "UpClose")
			{
				UpClose_mc.x -= 1;
				UpClose_mc.y -= 1;
				UpClose_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
				UpClose_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//上段最小化ボタン
			else if (e.target.name == "UpMin")
			{
				UpMin_mc.x -= 1;
				UpMin_mc.y -= 1;
				UpMin_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
				UpMin_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//下段最小化ボタン
			else if (e.target.name == "DownMin")
			{
				DownMin_mc.x -= 1;
				DownMin_mc.y -= 1;
				DownMin_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
				DownMin_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//上段復元化ボタン
			else if (e.target.name == "Re_UpMin")
			{
				Re_UpMin_mc.x -= 1;
				Re_UpMin_mc.y -= 1;
				Re_UpMin_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
				Re_UpMin_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
			
			//下段復元化ボタン
			else if (e.target.name == "Re_DownMin")
			{
				Re_DownMin_mc.x -= 1;
				Re_DownMin_mc.y -= 1;
				Re_DownMin_mc.removeEventListener(MouseEvent.MOUSE_UP, Button_up);
				Re_DownMin_mc.removeEventListener(MouseEvent.MOUSE_OUT, Button_up);
			}
		}
		
		/******************
		 * ボタン　クリックイベント
		 * ****************/
		
		//上段クローズボタン
		protected function Upclose_click(e:MouseEvent):void
		{
			
		}
		
		//上段最小化ボタン
		protected function UpMin_click(e:MouseEvent):void
		{
			UpMin_mc.visible = false;
			Re_UpMin_mc.visible = true;
			UpMinBotton_Flag = false;
			
			Up_mc.visible = false;
			Bit_mc.visible = false;
			Before_Bit_y = Bit_mc.y;
			Bit_mc.y = UpBar.height - 6;
			UpDownFrame_Resize();
		}
		
		//下段最小化ボタン
		protected function DownMin_click(e:MouseEvent):void
		{
			DownMin_mc.visible = false;
			Re_DownMin_mc.visible = true;
			DownMinBotton_Flag = false;
			
			Down_mc.visible = false;
			DownMin_Flag = true;
			Side_mc.height = DownBar.y + DownBar.height;
			SideBit_mc.height = Side_mc.height;
//			Frame.height = SideBit_mc.height;
			Frame.height = Bit_mc.y;
		}
		
		//上段復元化ボタン
		protected function Re_UpMin_click(e:MouseEvent):void
		{
			Re_UpMin_mc.visible = false;
			UpMin_mc.visible = true;
			UpMinBotton_Flag = true;
			
			Bit_mc.y = Before_Bit_y;
			UpDownFrame_Resize();
			Up_mc.visible = true;
			Bit_mc.visible = true;
		}
		
		//下段復元化ボタン
		protected function Re_DownMin_click(e:MouseEvent):void
		{
			Re_DownMin_mc.visible = false;
			DownMin_mc.visible = true;
			DownMinBotton_Flag = true;
			
			Down_mc.visible = true;
			DownMin_Flag = false;
			Side_mc.height = Main.mainStage.stageHeight;
			SideBit_mc.height = Side_mc.height;
//			Frame.height = SideBit_mc.height;
			Frame.height = Bit_mc.y;
		}
		
		/**************
		 * リサイズ処理群
		 * ************/
		
		//上下フレームサイズ変更
		protected function UpDownFrame_Resize():void
		{
			Frame.height = Bit_mc.y;
			DownBar.y = Bit_mc.y + Bit_mc.height;
			if (Bit_mc.y - UpBar.height - 10 > 0)
			{
				Up_bg.height = Bit_mc.y - UpBar.height - 10;
			}
			else
			{
				Up_bg.height = 0;
			}
//			Down_mc.y = DownBar.y + DownBar.height + 5;
			Down_mc.y = DownBar.y + DownBar.height;
			if (Down_bg_height - DownBar.y > 0)
			{
				Down_bg.height = Down_bg_height - DownBar.y;
			}
			else
			{
				Down_bg.height = 0;
			}
			DownMin_mc.y = DownBar.y + 5;
			Re_DownMin_mc.y = DownMin_mc.y;
			if (DownMin_Flag)
			{
				Side_mc.height = DownBar.y + DownBar.height;
//				Frame.height = Side_mc.height;
				Frame.height = Bit_mc.y;
				if (Side_mc.height < Main.mainStage.stageHeight)
				{
					SideBit_mc.height = Side_mc.height;
				}
				else
				{
					SideBit_mc.height = Main.mainStage.stageHeight;
				}
			}
		}
		
		//ブラウザサイズ変更
		override protected function Resize(e:Event):void
		{
			super.Resize(e);
			
			Frame_mc.x = Side_mc.x;
			Frame.width = Side_mc.width;
//			Frame.height = h;
			Frame.height = Bit_mc.y;
			Bit_mc.x = Side_mc.x;
			bitmap.width = Side_mc.width;
			UpBar.width = Frame.width;
			DownBar.y = Bit_mc.y + Bit_mc.height;
			DownBar.width = UpBar.width;
			Up_bg.width = Frame.width - 16;
			Up_bg.height = Bit_mc.y - UpBar.height - 10;
//			Down_mc.y = DownBar.y + DownBar.height + 5;
			Down_mc.y = DownBar.y + DownBar.height;
//			Down_bg.width = Up_bg.width;
			Down_bg.width = Frame.width;
//			Down_bg.height =  h  - DownBar.y - DownBar.height - 15;
			Down_bg.height =  h  - DownBar.y - DownBar.height;
			if (UpBar.width - 20 > 0)
			{
				UpClose_mc.x = UpBar.width - 20;
				UpClose_mc.visible = true;
				DownMin_mc.x = UpClose_mc.x;
				Re_DownMin_mc.x = DownMin_mc.x;
				if (DownMinBotton_Flag == true)
				{
					DownMin_mc.visible = true;
				}
				else
				{
					Re_DownMin_mc.visible = true;
				}
			}
			else
			{
				UpClose_mc.visible = false;
				if (DownMinBotton_Flag == true)
				{
					DownMin_mc.visible = false;
				}
				else
				{
					Re_DownMin_mc.visible = false;
				}
			}
			if (UpClose_mc.x - 20 > 0)
			{
				UpMin_mc.x = UpClose_mc.x - 20;
				Re_UpMin_mc.x = UpMin_mc.x;
				if (UpMinBotton_Flag == true)
				{
					UpMin_mc.visible = true;
				}
				else
				{
					Re_UpMin_mc.visible = true;
				}
			}
			else
			{
				if (UpMinBotton_Flag == true)
				{
					UpMin_mc.visible = false;
				}
				else
				{
					Re_UpMin_mc.visible = false;
				}
			}
			DownMin_mc.y = DownBar.y + 5;
			Re_DownMin_mc.y = DownMin_mc.y;
//			Down_bg_height = Frame_mc.height - 5  - DownBar.height - 10;
			Down_bg_height = Frame_mc.height - DownBar.height;
			if (DownMin_Flag)
			{
				Side_mc.height = DownBar.y + DownBar.height;
//				Frame.height = Side_mc.height;
				Frame.height = Bit_mc.y;
				if (Side_mc.height < Main.mainStage.stageHeight)
				{
					SideBit_mc.height = Side_mc.height;
				}
				else
				{
					SideBit_mc.height = Main.mainStage.stageHeight;
				}
			}
		}
		
		//左右フレームサイズ変更
		override protected function Side_Resize():void
		{
			super.Side_Resize();
			
			Frame_mc.x = Side_mc.x;
			Frame.width = Side_mc.width;
			Bit_mc.x = Side_mc.x;
			bitmap.width = Side_mc.width;
			UpBar.width = Frame.width;
			DownBar.width = UpBar.width;
			Up_bg.width = Frame.width - 16;
//			Down_bg.width = Up_bg.width;
			Down_bg.width = Frame.width;
			if (UpBar.width - 20 > 0)
			{
				UpClose_mc.x = UpBar.width - 20;
				UpClose_mc.visible = true;
				DownMin_mc.x = UpClose_mc.x;
				Re_DownMin_mc.x = DownMin_mc.x;
				if (DownMinBotton_Flag == true)
				{
					DownMin_mc.visible = true;
				}
				else
				{
					Re_DownMin_mc.visible = true;
				}
			}
			else
			{
				UpClose_mc.visible = false;
				if (DownMinBotton_Flag == true)
				{
					DownMin_mc.visible = false;
				}
				else
				{
					Re_DownMin_mc.visible = false;
				}
			}
			if (UpClose_mc.x - 20 > 0)
			{
				UpMin_mc.x = UpClose_mc.x - 20;
				Re_UpMin_mc.x = UpMin_mc.x;
				if (UpMinBotton_Flag == true)
				{
					UpMin_mc.visible = true;
				}
				else
				{
					Re_UpMin_mc.visible = true;
				}
			}
			else
			{
				if (UpMinBotton_Flag == true)
				{
					UpMin_mc.visible = false;
				}
				else
				{
					Re_UpMin_mc.visible = false;
				}
			}
		}
	}

}