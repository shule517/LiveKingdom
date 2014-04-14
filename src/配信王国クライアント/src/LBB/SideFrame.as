package LBB
{
	import net.lifebird.ui.cursor.*;
	import net.lifebird.ui.cursor.plugins.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author LBB
	 */
	public class SideFrame extends Sprite
	{
		/*************
		 * 埋め込み画像
		 * ***********/
		
		 //左右スライドバー
		protected var SideBit_mc:MovieClip;
		[Embed(source='../data/SideTab.png')]
		private var imageSideBitmap:Class;
		protected var SideBitmap:Bitmap;
		
		/********
		 * その他
		 * ******/
		
		//左右バー可動範囲指定
		protected var Side_bounds:Rectangle;
		
		//最背面MC&背景
		protected var Side_mc:MovieClip;
		protected var Side_bg:Sprite

		//ウィンドウ幅
		protected var w:Number;
		
		//ウィンドウ高さ
		protected var h:Number;
		
		//SideBit_mc x値
		protected var SideBit_mc_x:Number;
		
		//フレーム最小化(=true) フレーム復元化(=false)
		protected var SideMin_Flag:Boolean = true;
		
		public function SideFrame():void
		{
			//各種初期値設定
			setSide_mc();
			
			//左右スライド処理
			moveSide_mc();
		}
		
		/***************
		 * 各種初期値設定
		 * *************/
		
		protected function setSide_mc():void
		{
			Side_mc = new MovieClip();
			SideBit_mc = new MovieClip();
			Side_bg = new Sprite();
			
			/**************
			 * 最背面初期値
			 * ************/
			
			Side_mc.x = Main.mainStage.stageWidth - 336;
			addChild(Side_mc);
			
			Side_bg.graphics.beginFill(0x00ff00,0);
			Side_bg.graphics.drawRect(0, 0, 336, Main.mainStage.stageHeight);
			Side_bg.graphics.endFill();
			Side_mc.addChild(Side_bg);
			
			/********************
			 * 左右スライドバー初期値
			 * ******************/
			
			SideBit_mc.x = Main.mainStage.stageWidth - 336 - 7;
			SideBit_mc.doubleClickEnabled = true;
			addChild(SideBit_mc);
			
			SideBitmap = new imageSideBitmap;
			SideBitmap.height = Main.mainStage.stageHeight;
			SideBit_mc.addChild(SideBitmap);
			
			//スライドバー　オーバー時　マウスカーソル変更イベント
			Cursors.init(Main.mainStage);
			FlexCursors.Set();
			Cursors.addDragCursor(SideBit_mc, CursorType.H_RESIZE, CursorType.H_RESIZE, CursorType.DEFAULT);
			
			/**************************
			 * stege　リサイズ時　イベント登録
			 * ************************/
			
			Main.mainStage.addEventListener(Event.RESIZE, Resize);
		}
		
		
		/***************
		 * 左右スライド処理
		 * *************/
		
		private function moveSide_mc():void
		{
			SideBit_mc.addEventListener(MouseEvent.MOUSE_DOWN, Side_down);
			SideBit_mc.addEventListener(MouseEvent.DOUBLE_CLICK, Min);
		}
		
		//マウス　ダウンイベント
		protected function Side_down(e:MouseEvent):void
		{
			//スライドバー可動範囲指定
			Side_bounds = new Rectangle(0, 0, Main.mainStage.stageWidth - 7, 0);
			
			//ドラッグ開始
			SideBit_mc.startDrag(false, Side_bounds);
			
			//マウス　ダウン時　イベント登録
			SideBit_mc.addEventListener(Event.ENTER_FRAME, drawingHandler);
			SideBit_mc.addEventListener (MouseEvent.MOUSE_MOVE, move);   
			SideBit_mc.addEventListener(MouseEvent.MOUSE_UP, up);
			Main.mainStage.addEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		//マウス　ダウン時　毎フレームイベント
		private function drawingHandler(e:Event):void
		{
			//左右リサイズ処理
			Side_Resize();
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
			SideBit_mc.stopDrag();
			
			//左右リサイズ処理
			Side_Resize();
			
			//イベント　登録解除
			SideBit_mc.removeEventListener(Event.ENTER_FRAME, drawingHandler);
			SideBit_mc.removeEventListener(MouseEvent.MOUSE_MOVE, move);
			SideBit_mc.removeEventListener(MouseEvent.MOUSE_UP, up);
			Main.mainStage.removeEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		//フレーム　最小化イベント
		protected function Min(e:MouseEvent):void
		{
			//フレーム　最小化
			if (SideMin_Flag)
			{
				SideBit_mc_x = SideBit_mc.x;
				SideBit_mc.x = Main.mainStage.stageWidth - 7;
				Side_Resize();
				SideMin_Flag = false;
			}
			
			//フレーム　復元
			else
			{
				SideBit_mc.x = SideBit_mc_x;
				Side_Resize();
				SideMin_Flag = true;
			}
		}
		
		/**************
		 * リサイズ処理群
		 * ************/
		
		//ブラウザサイズ変更
		protected function Resize(e:Event):void
		{
			w = Main.mainStage.stageWidth;
			h = Main.mainStage.stageHeight;
			
			Side_mc.x = w - Side_mc.width;
			Side_bg.width = w - Side_mc.x;
			Side_bg.height = h;
			SideBit_mc.x = Side_mc.x - 7;
			SideBitmap.height = h;
		}
		
		//左右フレームサイズ変更
		protected function Side_Resize():void
		{
			Side_mc.x = SideBit_mc.x + 7;
			if (Main.mainStage.stageWidth - Side_mc.x > 0)
			{
				Side_bg.width = Main.mainStage.stageWidth - Side_mc.x;
			}
			else
			{
				Side_bg.width = 0;
			}
		}
	}

}