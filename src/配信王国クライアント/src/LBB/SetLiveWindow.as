package LBB
{
	import flash.events.*;
	import flash.geom.Rectangle;
	import poo.LiveWindow;
	
	/**
	 * ...
	 * @author LBB
	 */
	public class SetLiveWindow extends UpDownFrame
	{
		//バイソン　ウィンドウ
		private var Livewindow:LiveWindow;
		
		//Side_mc 高さ
		private var Side_mc_height:Number;
		
		//Frame 高さ
		private var Frae_height:Number;
		
		//スレッド
		private var thread:Thread;
		
		//thread 生成後(=true) 生成前(=false)
		private var CreateThread:Boolean = false;
		
		public function SetLiveWindow():void
		{
			//各種初期設定
			setWindow();
		}
		
		/***************
		 * 各種初期値設定
		 * *************/
		
		private function setWindow():void
		{
			/*************
			 * 上段　初期値
			 * ***********/
			
			Side_mc.x = Main.mainStage.stageWidth - 500;
			Side_bg.width = 500;
			SideBit_mc.x = Main.mainStage.stageWidth - 500 - 7;
			Frame_mc.x = Main.mainStage.stageWidth - 500;
			Frame.width = 500;
			Bit_mc.y = 320 + 28;
			Side_mc_height = Side_mc.height;
			Side_mc.height = Bit_mc.y + Bit_mc.height;
			Frae_height = Frame.height;
			Frame.height = Bit_mc.y + Bit_mc.height;
			super.UpDownFrame_Resize();
			super.Side_Resize();
			
			/************
			 * 初期非表示
			 * **********/
			
			UpMin_mc.visible = false;
			DownBar.visible = false;
			DownMin_mc.visible = false;
			Down_mc.visible = false;
			SideBit_mc.visible = false;
			Bit_mc.visible = false;
			
			/*************
			 * 配信ウィンドウ
			 * ***********/
			
			Livewindow = new LiveWindow();
			Livewindow.frame.width = Up_bg.width;
			Livewindow.frame.height = Up_bg.height;
			Up_mc.addChild(Livewindow);
			Livewindow.addEventListener("LiveStart", thread_oppen);
		}
		
		/***************
		 * 左右スライド処理
		 * *************/
		
		//マウス　ダウンイベント オーバーライド
		override protected function Side_down(e:MouseEvent):void
		{
			super.Side_down(e);
			
			//スライドバー可動範囲指定
			Side_bounds = new Rectangle(0, 0, Main.mainStage.stageWidth - 93 - 7, 0);
			
			//ドラッグ開始
			SideBit_mc.startDrag(false, Side_bounds);
		}
		
		/***************
		 * 上下スライド処理
		 * *************/
		
		//マウス　ダウンイベント オーバーライド
		override protected function down(e:MouseEvent):void
		{
			super.down(e);
			
			//スライドバー可動範囲指定
			UpDown_bounds = new Rectangle(Side_mc.x, 122, 0, Frame_mc.height - 122 - Bit_mc.height - DownBar.height - 36);
			
			//ドラッグ開始
			Bit_mc.startDrag(false, UpDown_bounds);
		}
		
		/************************
		 * 配信開始　クリック時　イベント
		 * **********************/
		
		private function thread_oppen(e:Event):void
		{
			/**************
			 * 表示＆リサイズ
			 * ************/
			
			UpMin_mc.visible = true;
			DownBar.visible = true;
			DownMin_mc.visible = true;
			Down_mc.visible = true;
			SideBit_mc.visible = true;
			Bit_mc.visible = true;
			Side_mc.height = Side_mc_height;
			Frame.height = Frae_height;
			super.Resize(e);
			
			/********
			 * スレッド
			 * ******/
			
			thread = new Thread(Down_mc);
			thread.setSize(Down_bg);
			CreateThread = true;
		}
		
		/******************
		 * ボタン クリックイベント
		 * ****************/
		
		//上段クローズボタン　オーバーライド		
		override protected function Upclose_click(e:MouseEvent):void
		{
			//バイソンの配信終了処理を要追記
			Livewindow.LiveWindow_Destructor();
			
			/*************
			 * イベント 削除
			 * ***********/
			
			Livewindow.removeEventListener("LiveStart", thread_oppen);
			
			/***************
			 * 各種変数　削除
			 * *************/
			
			thread = null;
			Livewindow = null;

			super.Upclose_click(e);
		}
		
		/**************
		 * リサイズ処理群
		 * ************/
		
		//ブラウザサイズ変更
		override protected function Resize(e:Event):void
		{
			super.Resize(e);
			
			Livewindow.frame.width = Up_bg.width;
			Livewindow.frame.height = Up_bg.height;
			if (CreateThread)
			{
				thread.output_thread.width = Down_bg.width;
				thread.output_thread.height = Down_bg.height - 20;
				thread.input_thread.y = thread.output_thread.height;
				thread.input_thread.width = Down_bg.width;
			}
			else
			{
				UpMin_mc.visible = false;
				DownMin_mc.visible = false;
				Frame.height = Bit_mc.y + Bit_mc.height;
				Side_mc.height = Bit_mc.y + Bit_mc.height;
			}
		}
		
		//左右フレームサイズ変更
		override protected function Side_Resize():void
		{
			super.Side_Resize();
			if (Down_bg.width > 0)
			{
				Livewindow.frame.width = Up_bg.width;
				Livewindow.frame.visible = true;
				thread.output_thread.width = Down_bg.width;
				thread.output_thread.visible = true;
				thread.input_thread.width = Down_bg.width;
				thread.input_thread.visible = true;
			}
			else
			{
				Livewindow.frame.visible = false;
				thread.output_thread.visible = false;
				thread.input_thread.visible = false;
			}
		}
		
		//上下フレームサイズ変更
		override protected function UpDownFrame_Resize():void
		{
			super.UpDownFrame_Resize();
			
			if (Up_bg.height > 20)
			{
				Livewindow.frame.height = Up_bg.height;
				Livewindow.frame.visible = true;
			}
			else
			{
				Livewindow.frame.visible = false;
			}
			if (Down_bg.height - 20 > 0)
			{
				thread.output_thread.height = Down_bg.height - 20;
				thread.output_thread.visible = true;
				thread.input_thread.y = thread.output_thread.height;
			}
			else
			{
				thread.output_thread.visible = false;
			}
		}
	}
}