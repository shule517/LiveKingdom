package LBB
{
	import com.bit101.components.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.text.*;
	import flash.geom.Rectangle;
	import poo.EndSprite;
	import poo.LiveWindow;
	import poo.LoaderSprite;
	import poo.LiveStreamClass;
	import shule.net.NetWork;
	import shule.world.World;
	
	/**
	 * ...
	 * @author LBB
	 */
	public class LiveScreen extends UpDownFrame
	{
		/***************
		 * 動画視聴フレーム
		 * *************/
		
		//動画各種必要項目
		private var video:Video;
		private var LSClass:LiveStreamClass;
		private var NowLoading:LoaderSprite;
		
		//音量バー
		private var volume:HSlider;
		
		//動画視聴フレーム(=true) 配信フレーム(=false)
		private var Screen_Flag:Boolean = true;
		
		/************
		 * 配信フレーム
		 * **********/
		
		//バイソン　ウィンドウ
		private var Livewindow:LiveWindow;
		private var END:EndSprite;
		
		//Side_mc 高さ
		private var Side_mc_height:Number;
		
		//Frame 高さ
		private var Frae_height:Number;
		
		//thread 生成後(=true) 生成前(=false)
		private var CreateThread:Boolean = false;
		
		/*******
		 * 共通
		 * *****/
		
		//スレッド
		private var thread:Thread;
		
		/***********
		 * タイトルバー
		 * *********/
		
		public var Tittle:TittleBar;
		
		public function LiveScreen():void
		{
			//動画視聴フレーム　初期値設定
			setScreen();
			
			Tittle = new TittleBar();
			Tittle.addEventListener("open", setWindow);
			
			//デバック用
			//Tittle.addEventListener("play", play);
		}
		
	/*************************
	 * 動画視聴フレーム　初期値設定
	 * ***********************/
		
		private function setScreen():void
		{
			this.visible = false;
			
			/*************
			 * 動画 初期値
			 * ***********/
			
			video = new Video(480, 320);
			LSClass = new LiveStreamClass();
			Up_mc.addChild(video);
			
			//video　幅＆高さ
			if (Up_bg.height - 25 > 3 * Up_bg.width / 4)
			{
				video.width = Up_bg.width;
				video.height = 3 * video.width / 4;
			}
			else
			{
				video.width = 4 * (Up_bg.height - 25) / 3;
				video.height = Up_bg.height - 25;
				if (Up_bg.width > video.width)
				{
					video.x = Up_bg.width / 2 - video.width / 2;
				}
			}
			
			//NowLoading 終了イベント
			LSClass.addEventListener("STREAM_EVENT_PLAY", Delete_NowLoading);
			
			//配信終了時　画像表示イベント
			LSClass.addEventListener("STREAM_EVENT_END", Stream_END);
			
			/**************
			 * バッファ　初期値
			 * ************/
			
			LSClass.BufferText.width = 100;
			LSClass.BufferText.height = 20;
			Up_mc.addChild(LSClass.BufferText);
			
			/***************
			 * 音量バー初期値
			 * *************/
			volume = new HSlider(Up_mc, (Up_bg.width / 2) - 100, Up_bg.height - 20);
			volume.value = 50;
			
			//スライダー　音量　同期イベント
			volume.addEventListener(Event.CHANGE, onHSliderChange);
			
			/********
			 * スレッド
			 * ******/
			
			thread = new Thread(Down_mc);
			thread.setSize(Down_bg);
		}
		
		
		/**************
		 * 動画各種処理
		 * ************/
		
		//動画再生
		public function play(id:String):void
		//public function play(e:Event):void
		{
			// スレッドに視聴している配信IDを渡す
			thread.setLiveID(id);
			
			this.visible = true;
			Tittle.Not_mc.visible = false;
			LSClass.BufferText.visible = true;
			video.visible = true;
			volume.visible = true;
			volume.value = 50;
			volume.setVolume();
			
			
			if (null != END)
			{
				Clear_Stream_END();
			}
			
			if (Screen_Flag)
			{
				Screen_Flag = true;
				if (null == NowLoading)
				{
					NowLoading = new LoaderSprite();
					NowLoading.width = video.width;
					NowLoading.height = video.height;
					NowLoading.x = video.x;
					NowLoading.y = video.y;
					Up_mc.addChild(NowLoading);
				}
				//バイソンのプロｸﾞﾗﾑへidを渡す
				LSClass.initRcv(video, id);
				
				//デバック用
				//LSClass.initRcv(video, "poo");
				
				//デバック用
				//netStream.play("http://shule517.ddo.jp/NetWalk/data/SampleMovie.flv");
			}
			else
			{
				Screen_Flag = true;
				EndLive();
				
				Side_mc.height = Side_mc_height;
				Frame.height = Frae_height;
				UpDownFrame_Resize();
				Side_Resize();
				thread.setSize(Down_bg);
				
				UpMin_mc.visible = true;
				DownBar.visible = true;
				DownMin_mc.visible = true;
				Down_mc.visible = true;
				SideBit_mc.visible = true;
				Bit_mc.visible = true;
				
				if (null == NowLoading)
				{
					NowLoading = new LoaderSprite();
					NowLoading.width = video.width;
					NowLoading.height = video.height;
					NowLoading.x = video.x;
					NowLoading.y = video.y;
					Up_mc.addChild(NowLoading);
				}
				
				//バイソンのプロｸﾞﾗﾑへidを渡す
				LSClass.initRcv(video, id);
				
				//デバック用
				//LSClass.initRcv(video, "poo");
			}
		}
		
		//スライダー　音量　同期
		private function onHSliderChange(e:Event):void
		{
			LSClass.Set_volume(volume.value / 50);
		}
		
		//NowLoading 終了
		private function Delete_NowLoading(e:Event):void
		{
			Up_mc.removeChild(NowLoading);
			NowLoading = null;
		}
		
		//配信終了時　画像
		private function Stream_END(e:Event):void
		{
			END = new EndSprite();
			END.x = video.x;
			END.y = video.y;
			END.width = video.width;
			END.height = video.height;
			Up_mc.addChild(END);
		}
		
		//配信終了時　画像　削除
		private function Clear_Stream_END():void
		{
			Up_mc.removeChild(END);
			END = null;
		}
		
		//動画停止
		private function stop():void
		{
			// 配信視聴終了
			NetWork.sendListenStop();
			World.myChara.liveID = "";
			
			LSClass.clearNetGroup();
			
			//デバック用
			//netStream.close();
		}
		
		
	/**********************
	 * 配信フレーム　初期値設定
	 * ********************/
		
		private function setWindow(e:Event):void
		{
			this.visible = true;
			Screen_Flag = false;
			LSClass.BufferText.visible = false;
			video.visible = false;
			volume.visible = false;
			if (NowLoading)
			{
				Up_mc.removeChild(NowLoading);
				NowLoading = null;
			}
			if (null != END)
			{
				Clear_Stream_END();
			}
			
			stop();
			
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
//			Frame.height = Bit_mc.y + Bit_mc.height;
			Frame.height = Bit_mc.y;
			super.UpDownFrame_Resize();
			super.Side_Resize();
			thread.setSize(Down_bg);
			
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
			Livewindow.form.width = Up_bg.width;
			Livewindow.form.height = Up_bg.height;
			Livewindow.tabpane.width = Up_bg.width;
			Livewindow.tabpane.height = Up_bg.height;
			Up_mc.addChild(Livewindow);
			Livewindow.tabpane.setSelectedIndex(1);
			Livewindow.tabpane.setSelectedIndex(0);
			
			//スレッド表示イベント
			Livewindow.addEventListener("LiveStart", thread_oppen);
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
			// 配信IDを自分のIDに設定
			thread.setLiveID(Main.myID);
			
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
			
			thread.setSize(Down_bg);
			CreateThread = true;
		}
		
		/**************
		 * 配信終了処理
		 * ************/
		
		private function EndLive():void
		{
			if (Livewindow != null)
			{
				Livewindow.LiveWindow_Destructor();
				Livewindow.removeEventListener("LiveStart", thread_oppen);
				Up_mc.removeChild(Livewindow);
				Livewindow = null;
			}
		}
		
	/******************
	 * ボタン クリックイベント
	 * ****************/
		
		//上段クローズボタン　オーバーライド
		override protected function Upclose_click(e:MouseEvent):void
		{
			if (Screen_Flag)
			{
				//動画停止
				stop();
				
				if (null != END)
				{
					Clear_Stream_END();
				}
				
				//フレーム非表示
				this.visible = false;
			}
			else
			{
				//配信終了処理
				EndLive();
				
				//配信禁止　非表示
				Tittle.Not_mc.visible = false;
				
				//フレーム非表示
				this.visible = false;
			}
		}
		
	/**************
	 * リサイズ処理群
	 * ************/
		
		//ブラウザサイズ変更
		override protected function Resize(e:Event):void
		{
			super.Resize(e);
			
			if (Screen_Flag)
			{
				if (Up_bg.height - 25 > 3 * Up_bg.width / 4)
				{
					video.x = 0;
					video.width = Up_bg.width;
					video.height = 3 * video.width / 4;
				}
				else
				{
					video.width = 4 * (Up_bg.height - 25) / 3;
					video.height = Up_bg.height - 25;
					if (Up_bg.width > video.width)
					{
						video.x = Up_bg.width / 2 - video.width / 2;
					}
				}
				if (Up_bg.width > volume.width)
				{
					volume.x = (Up_bg.width / 2) - 100;
					volume.visible = true;
				}
				else
				{
					volume.visible = false;
				}
				thread.output_thread.width = Down_bg.width;
				thread.output_thread.height = Down_bg.height - 20;
				thread.input_thread.y = thread.output_thread.height;
				thread.input_thread.width = Down_bg.width;
				if (null != NowLoading)
				{
					NowLoading.width = video.width;
					NowLoading.height = video.height;
					NowLoading.x = video.x;
				}
				if (null != END)
				{
					END.width = video.width;
					END.height = video.height;
					END.x = video.x;
				}
			}
			else
			{
				Livewindow.form.width = Up_bg.width;
				Livewindow.tabpane.width = Up_bg.width;
				Livewindow.form.height = Up_bg.height;
				Livewindow.tabpane.height = Up_bg.height;
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
//					Frame.height = Bit_mc.y + Bit_mc.height;
					Frame.height = Bit_mc.y;
					Side_mc.height = Bit_mc.y + Bit_mc.height;
				}
			}
		}
		
		//左右フレームサイズ変更
		override protected function Side_Resize():void
		{
			super.Side_Resize();
			
			if (Screen_Flag)
			{
				if (Up_bg.height - 25 > 3 * Up_bg.width / 4)
				{
					video.x = 0;
					video.width = Up_bg.width;
					video.height = 3 * video.width / 4;
				}
				else
				{
					video.width = 4 * (Up_bg.height - 25) / 3;
					video.height = Up_bg.height - 25;
					if (Up_bg.width > video.width)
					{
						video.x = Up_bg.width / 2 - video.width / 2;
					}
				}
				if (Up_bg.width > volume.width)
				{
					volume.x = (Up_bg.width / 2) - 100;
					volume.visible = true;
				}
				else
				{
					volume.visible = false;
				}
				if (Down_bg.width > 0)
				{
					thread.output_thread.width = Down_bg.width;
					thread.output_thread.visible = true;
					thread.input_thread.width = Down_bg.width;
					thread.input_thread.visible = true;
				}
				else
				{
					thread.output_thread.visible = false;
					thread.input_thread.visible = false;
				}
				if (null != NowLoading)
				{
					NowLoading.width = video.width;
					NowLoading.height = video.height;
					NowLoading.x = video.x;
				}
				if (null != END)
				{
					END.width = video.width;
					END.height = video.height;
					END.x = video.x;
				}
			}
			else
			{
				if (Down_bg.width > 0)
				{
					Livewindow.form.width = Up_bg.width;
					Livewindow.tabpane.width = Up_bg.width;
					thread.output_thread.width = Down_bg.width;
					thread.output_thread.visible = true;
					thread.input_thread.width = Down_bg.width;
					thread.input_thread.visible = true;
				}
				else
				{
					thread.output_thread.visible = false;
					thread.input_thread.visible = false;
				}
			}
		}
		
		//上下フレームサイズ変更
		override protected function UpDownFrame_Resize():void
		{
			super.UpDownFrame_Resize();
			
			if (Screen_Flag)
			{
				if (Up_bg.height - 25 > 0)
				{
					if (Up_bg.height - 25 > 3 * Up_bg.width / 4)
					{
						video.x = 0;
						video.width = Up_bg.width;
						video.height = 3 * video.width / 4;
						video.visible = true;
					}
					else
					{
						video.width = 4 * (Up_bg.height - 25) / 3;
						video.height = Up_bg.height - 25;
						video.visible = true;
						if (Up_bg.width > video.width)
						{
							video.x = Up_bg.width / 2 - video.width / 2;
						}
					}
				}
				else
				{
					video.visible = false;
				}
				if (Up_bg.width > volume.width)
				{
					if (Up_bg.height - 20 > 0)
					{
						volume.y = Up_bg.height - 20;
						volume.visible = true;
					}
					else
					{
						volume.visible = false;
					}
				}
				else
				{
					if (Up_bg.height - 20 > 0)
					{
						volume.y = Up_bg.height - 20;
					}
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
				if (null != NowLoading)
				{
					NowLoading.width = video.width;
					NowLoading.height = video.height;
					NowLoading.x = video.x;
				}
				if (null != END)
				{
					END.width = video.width;
					END.height = video.height;
					END.x = video.x;
				}
			}
			else
			{
				Livewindow.form.height = Up_bg.height;
				Livewindow.tabpane.height = Up_bg.height;
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
}