package poo
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import org.aswing.*;
	import org.aswing.event.*;
	import org.aswing.ext.Form;
	import org.aswing.geom.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import poo.MeterGraphic;
	import poo.LiveStreamClass;
	import shule.Capture;
	import shule.net.NetWork;
	import shule.world.World;
	//import shule.Capture;
	
    public class LiveWindow extends Sprite
    {
		//public var frame:JFrame;//ウインドウフレーム
		public var form:Form;
		//パネル
		public var tabpane:JTabbedPane;//タブパネル
		private var Setting_pane:JLoadPane;//設定タブ
		private var Video_pane:JPanel;//映像タブ
		//コンボボックス
		private var Camera_cb:JComboBox;//カメラ選択コンボボックス
		private var CameraSize_cb:JComboBox;//カメラサイズ選択コンボボックス
		private var Audio_cb:JComboBox;//オーディオ選択コンボボックス
		private var Fps_cb:JComboBox;//fpsコンボボックス
		//テキストフィールド
		private var title:JTextField;//タイトル
		private var content:JTextField;//内容
		//スライダー
		private var Video_slider:JSlider;//画質スライダー
		private var Audio_slider:JSlider;//音質スライダー
		private var Miclevel_slider:JSlider;//音量スライダー
		//ボタン
		private var LiveStartButton:JButton;//配信開始ボタン
		//メディア
		private var video:Video;//映像パネルに表示
		private var camera:Camera;//カメラ
		private var mic:Microphone;//マイク
		//タイマー
		private var Meter_timer:Timer;//マイクの出力検知用
		private var Vslider_timer:Timer;//画質スライダー用
		private var Aslider_timer:Timer;//音質スライダー用
		private var Capture_timer:Timer;//サムネイルupload用
		//チェックボックス
		private var Video_check:JCheckBox;//映像配信チェックボックス
		private var Audio_check:JCheckBox;//音声配信チェックボックス
		//フラグ
		private var StartFlag:Boolean;//配信をしている:true 配信をしていない:false
		//メーター
		private var MG:MeterGraphic;//ＶＵメーター

		//空のネットストリーム(マイクを入れる)
		private var nc:NetConnection;
		private var ns:NetStream;
		
		private var LS:LiveStreamClass;//動画通信
		//ラベル
		private var Cbyte:JLabel;//カメラのバイト数表示
		private var Abyte:JLabel;//マイクのバイト数表示
		/****************
		 * コンストラクタ
		 * *************/
        public function LiveWindow():void{
            super();
            createUI();
        }
		/******************
		 * デストラクタ
		 * ***************/
		public function LiveWindow_Destructor():void {
			Capture_timer.stop();
			LS.clearNetGroup();
			video.clear();
			camera = null;
			mic = null;
			/*//配信開始ボタンに表示切り替え
			LiveStartButton.setBackground(new ASColor(0x99ff00, 1));
			LiveStartButton.setText("配信開始");
			LiveEnd();*/
		}
       /*********************
        * 配信ウインドウの初期化
        *********************/
        private function createUI() : void {
            LS = new LiveStreamClass();
			LS.addEventListener("LIVESTREAM_EVENT_START", StartEvent);
			/*frame = new JFrame( this, "配信ウインドウ" );
            frame.setSizeWH(480, 320);*/
			//ドラッグ有無
			//frame.setDragable(false);
			//サイズ変更の有無
			//frame.setResizable(false);
			//削除の有無
			//frame.setClosable(false);
			form = new Form();
			form.setSizeWH(460, 275);
			form.setOpaque(true);
			form.setBackground(new ASColor(0xcccccc,1));
			tabpane = new JTabbedPane();
			tabpane.setSize(new IntDimension(460, 275));
			StartFlag = new Boolean(false);
			initPane();
			initVar();
			tabpane.append(Setting_pane);
			tabpane.append(Video_pane);
			//frame.setContentPane(tabpane);
			//frame.show();
			form.append(tabpane);
			addChild(form);
			//tabpane.setSelectedIndex(1);
			//tabpane.setSelectedIndex(0);
		}
		/**************************
		 * タブごとの描画情報の初期設定を行う
		 *************************/
		private function initPane():void {
			/*****************
			 * 設定パネルの初期設定
			 *****************/
			Setting_pane = new JLoadPane();
			Setting_pane.setLocation(new IntPoint(0, 0));
			Setting_pane.setSize(new IntDimension(400, 300));
			Setting_pane.setName("設定");
			/****************
			 * ラベル
			 ****************/
			var Title_label:JLabel = new JLabel("タイトル");
			Title_label.setLocation(new IntPoint(0, 0));
			Title_label.setSize(new IntDimension(100,20));
			var Content_label:JLabel = new JLabel("内容");
			Content_label.setLocation(new IntPoint(0, 30));
			Content_label.setSize(new IntDimension(100,20));
			var Camera_label:JLabel = new JLabel("ビデオソース");
			Camera_label.setLocation(new IntPoint(0, 70));
			Camera_label.setSize(new IntDimension(100, 20));
			var CameraSize_label:JLabel = new JLabel("カメラサイズ");
			CameraSize_label.setLocation(new IntPoint(0, 100));
			CameraSize_label.setSize(new IntDimension(100, 20));
			var Audio_label:JLabel = new JLabel("オーディオソース");
			Audio_label.setLocation(new IntPoint(0, 130));
			Audio_label.setSize(new IntDimension(100, 20));
			var Vs_label:JLabel = new JLabel("画質");
			Vs_label.setLocation(new IntPoint(258, 70));
			Vs_label.setSize(new IntDimension(40, 20));
			var fps_label:JLabel = new JLabel("fps");
			fps_label.setLocation(new IntPoint(262, 100));
			fps_label.setSize(new IntDimension(40, 20));
			var As_label:JLabel = new JLabel("音質");
			As_label.setLocation(new IntPoint(258, 130));
			As_label.setSize(new IntDimension(40, 20));
			var Ms_label:JLabel = new JLabel("音量");
			Ms_label.setLocation(new IntPoint(30, 210));
			Ms_label.setSize(new IntDimension(40, 20));
			var Meter_label:JLabel = new JLabel("VUメーター");
			Meter_label.setLocation(new IntPoint(15, 180));
			Meter_label.setSize(new IntDimension(60, 20));
			Cbyte = new JLabel();
			Cbyte.setLocation(new IntPoint(345,88));
			Cbyte.setSize(new IntDimension(120, 20));
			Abyte = new JLabel()
			Abyte.setLocation(new IntPoint(310, 148));
			Abyte.setSize(new IntDimension(150, 20));

			Setting_pane.append(Content_label);
			Setting_pane.append(Title_label);
			Setting_pane.append(Camera_label);
			Setting_pane.append(CameraSize_label);
			Setting_pane.append(Audio_label);
			Setting_pane.append(Vs_label);
			Setting_pane.append(fps_label);
			Setting_pane.append(As_label);
			Setting_pane.append(Ms_label);
			Setting_pane.append(Meter_label);
			Setting_pane.append(Cbyte);
			Setting_pane.append(Abyte);
			/**************
			 * テキストフィールド
			***************/
			title = new JTextField();
			title.setLocation(new IntPoint(100, 0));
			title.setSize(new IntDimension(240, 20));
			title.setMaxChars(50);//文字数制限
			Setting_pane.append(title);
			content = new JTextField();
			content.setLocation(new IntPoint(100, 30));
			content.setSize(new IntDimension(240, 20));
			content.setMaxChars(100);//文字数制限			
			Setting_pane.append(content);			
			/***************
			 * チェックボックス
			 ***************/
			//映像配信
			Video_check = new JCheckBox("映像配信");
			Video_check.setSelected(true);
			Video_check.setLocation(new IntPoint(350, 0));
			Video_check.setSize(new IntDimension(100, 20));
			Video_check.setPreferredSize(new IntDimension(100, 20));
			Video_check.addEventListener(ClickCountEvent.CLICK_COUNT, Video_check_Click);
			Setting_pane.append(Video_check);
			//音声配信
			Audio_check = new JCheckBox("音声配信");
			Audio_check.setSelected(true);
			Audio_check.setLocation(new IntPoint(350, 30));
			Audio_check.setSize(new IntDimension(100, 20));
			Audio_check.setPreferredSize(new IntDimension(100, 20));
			Audio_check.addEventListener(ClickCountEvent.CLICK_COUNT, Audio_check_Click);
			Setting_pane.append(Audio_check);
			/*************
			 * スライダー
			*************/
			//画質
			Video_slider = new JSlider();
			Video_slider.setLocation(new IntPoint(300, 70));
			Video_slider.setSize(new IntDimension(150, 20));
			Video_slider.setPreferredSize(new IntDimension(150, 20));
			Video_slider.addEventListener(InteractiveEvent.STATE_CHANGED, Video_slider_Serect);
			Setting_pane.append(Video_slider);
			//音質
			Audio_slider = new JSlider();
			Audio_slider.setLocation(new IntPoint(300, 130));
			Audio_slider.setSize(new IntDimension(150, 20));			
			Audio_slider.setPreferredSize(new IntDimension(150, 20));
			Audio_slider.addEventListener(InteractiveEvent.STATE_CHANGED, Audio_slider_Serect);
			Setting_pane.append(Audio_slider);
			//音量
			Miclevel_slider = new JSlider();
			Miclevel_slider.setLocation(new IntPoint(75, 210));
			Miclevel_slider.setSize(new IntDimension(200, 20));
			Miclevel_slider.setPreferredSize(new IntDimension(150, 20));
			Miclevel_slider.addEventListener(InteractiveEvent.STATE_CHANGED, Miclevel_slider_Serect);
			Setting_pane.append(Miclevel_slider);
			/**************
			 * コンボボックス
			**************/
			//カメラ選択
			Camera_cb = new JComboBox();
			if(null != Camera.getCamera()){
				Camera_cb.setSelectedItem(Camera.getCamera().name);
			}else {
				Camera_cb.setSelectedItem("カメラがありません");
			}
			Camera_cb.setLocation(new IntPoint(100, 70));
			Camera_cb.setSize(new IntDimension(150, 20));
			Camera_cb.setListData(Camera.names);
			Camera_cb.setPreferredSize(new IntDimension(150, 20));
			Camera_cb.addEventListener(ClickCountEvent.CLICK_COUNT, Camera_cb_Click);
			Camera_cb.addActionListener(Camera_cb_Serect);
			Setting_pane.append(Camera_cb);			
			//カメラサイズ
			CameraSize_cb = new JComboBox(['240×180', '320×240', '480×320', '640×480']);
			CameraSize_cb.setSelectedItem("320×240");
			CameraSize_cb.setLocation(new IntPoint(100, 100));
			CameraSize_cb.setSize(new IntDimension(150, 20));
			CameraSize_cb.setPreferredSize(new IntDimension(150, 20));
			CameraSize_cb.addActionListener(CameraSize_cb_Serect);
			Setting_pane.append(CameraSize_cb);
			//マイク選択
			Audio_cb = new JComboBox();
			if(null != Microphone.getMicrophone()){
				Audio_cb.setSelectedItem(Microphone.getMicrophone().name);
			}else {
				Audio_cb.setSelectedItem("マイクがありません");
			}
			Audio_cb.setLocation(new IntPoint(100, 130));
			Audio_cb.setSize(new IntDimension(150, 20));
			Audio_cb.setListData(Microphone.names);
			Audio_cb.setPreferredSize(new IntDimension(150, 20));
			Audio_cb.addEventListener(ClickCountEvent.CLICK_COUNT, Audio_cb_Click);
			Audio_cb.addActionListener(Audio_cb_Serect);
			Setting_pane.append(Audio_cb);
			//ＦＰＳ
			Fps_cb = new JComboBox(['10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60']);
			Fps_cb.setSelectedItem("23");
			Fps_cb.setLocation(new IntPoint(300, 100));
			Fps_cb.setSize(new IntDimension(40, 20));
			Fps_cb.setPreferredSize(new IntDimension(40, 20));
			Fps_cb.addActionListener(Fps_cb_Serect);
			Setting_pane.append(Fps_cb);
			/*************
			 * 配信開始ボタン
			 *************/
			LiveStartButton = new JButton();
			LiveStartButton.setFont(new ASFont("Tahoma", 18, true, false, false, false));
			LiveStartButton.setBackground(new ASColor(0x99ff00, 1));
			LiveStartButton.setLocation(new IntPoint(315, 185));
			LiveStartButton.setSize(new IntDimension(140, 30));
			LiveStartButton.setPreferredSize(new IntDimension(140, 30));
			LiveStartButton.setText("配信開始");
			LiveStartButton.addEventListener(ClickCountEvent.CLICK_COUNT, LiveStartButton_Serect);
			Setting_pane.append(LiveStartButton);
			/*****************
			 * VUメーター
			 ****************/
			MG = new MeterGraphic(75, 180);
			Setting_pane.addChild(MG);
			/******************
			 * 映像パネルの初期設定
			 *****************/
			Video_pane = new JPanel();
			Video_pane.setSize(new IntDimension(400, 300));
			Video_pane.setName("映像");
			//テキストフィールド（デバック用）
			LS.Text.x = 330;
			LS.Text.y = 0;
			LS.Text.width = 120;
			LS.Text.height = 240;
			Video_pane.addChild(LS.Text);
		}
		/***********************
		 * 初期化（タイマー、カメラ、ビデオ、マイク）
		 * *********************/
		private function initVar():void {
			//タイマー
			Meter_timer = new Timer(100, 0);//0.1秒毎
			Meter_timer.addEventListener(TimerEvent.TIMER, MicMeter_Timer);
			Vslider_timer = new Timer(1000, 0);//1秒毎
			Vslider_timer.addEventListener(TimerEvent.TIMER, Change_Vslider);
			Aslider_timer = new Timer(1000, 0);//1秒毎
			Aslider_timer.addEventListener(TimerEvent.TIMER, Change_Aslider);
			Capture_timer = new Timer(30000, 0);//30秒毎
			Capture_timer.addEventListener(TimerEvent.TIMER, Capture_Event);
			//カメラ
			camera = new Camera();
			camera = Camera.getCamera();
			initCamera();
			//ビデオ
			video = new Video(320, 240);
			video.x = 5;
			AttachCamera();//ビデオにカメラを入れる
			Video_pane.addChild(video);
			//マイク
			mic = new Microphone();
			mic = Microphone.getMicrophone();
			initMic();
			nc = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			ns.attachAudio(mic);
		}
		/************
		 * カメラ初期化
		 ************/
		private function initCamera():void {
			SetMode_Camera();
			SetQuality_Camera();
		}
		//カメラのサイズ、ｆｐｓを設定する
		private function SetMode_Camera():void {
			if (null == camera) return;
			//if (camera.name != "SCFH DSF"){
				switch(CameraSize_cb.getSelectedIndex()) {
					case 0:
					camera.setMode(240, 180,Fps_cb.getSelectedItem());				
					break;
					case 1:
					camera.setMode(320, 240, Fps_cb.getSelectedItem());
					break;
					case 2:
					camera.setMode(480, 320, Fps_cb.getSelectedItem());
					break;
					case 3:
					camera.setMode(640, 480, Fps_cb.getSelectedItem());
					break;
				}
			//}
		}
		//カメラの画質を設定する
		private function SetQuality_Camera():void {
			var byte:int = (Video_slider.getValue() * 2000 + 50000) / 1024 *8;
			Cbyte.setText(byte.toString() + " kbps");
			if (null == camera) return;
			//if(camera.name != "SCFH DSF"){
				byte = byte * 1024 / 8;
				camera.setQuality(byte, 0);
			//}
		}
		//カメラをビデオに入れる
		private function AttachCamera():void {
			if (camera != null)
			{
				video.attachCamera(camera);
			}else {
				trace("カメラがありません");
			}
		}
		/*************
		 * マイク初期化
		 *************/
		private function initMic():void {
			if(null != mic){
				mic.gain = Miclevel_slider.getValue();//マイクの検知音量
				SetQuality_Mic();//マイクの音の設定
				mic.setUseEchoSuppression(true);//エコー抑制を有効にする
				mic.setSilenceLevel(0, -1);
				if(false == StartFlag){//配信中でなければ
					Meter_timer.start();
				}
			}
		}
		//マイクの音質の変更
		private function SetQuality_Mic():void {
			if (null == mic) return;
			var value:int = Audio_slider.getValue();
			if (value < 15){
				mic.rate = 5;
			}
			else if (value < 30){
				mic.rate = 8;
			}
			else if (value < 60){
				mic.rate = 11;
			}
			else if (value < 85){
				mic.rate = 22;
			}else{
				mic.rate = 44;
			}
			value = mic.rate * 4 * 8;
			Abyte.setText(mic.rate.toString()+" kHz  "+value.toString()+" kbps");
		}
		//************************************************************
		//設定パネルイベント
		/********************
		 * チェックボックスイベント群
		 ********************/
		//映像配信　選択
		private function Video_check_Click(e:ClickCountEvent):void {
			trace("Video_check_Click");
			if (Video_check.isSelected()){
				LS.Set_CameraStream(camera);
			}else {
				LS.Set_CameraStream(null);
			}
		}
		//音声配信　選択
		private function Audio_check_Click(e:ClickCountEvent):void {
			trace("Audio_check_Click");
			if (Audio_check.isSelected()) {
				LS.Set_AudioStream(mic);
			}else {
				LS.Set_AudioStream(null);
			}
		}
		/******************************
		 * コンボボックスイベント群
		 * 選択　or クリック　時に呼ばれる
		 ******************************/
		/**********
		  * カメラ選択
		 *********/
		//クリック時
		private function Camera_cb_Click(e:ClickCountEvent):void {
			trace("Camera_cb_Click");
			Camera_cb.setListData(Camera.names);
		}
		//選択時
		private function Camera_cb_Serect(obj:Object):void {
			trace("CameraSerect");
			trace(Camera_cb.getSelectedItem());
			camera = Camera.getCamera(Camera_cb.getSelectedIndex().toString());
			initCamera();//再設定
			AttachCamera();
			if (StartFlag) {
				LS.Set_CameraStream(camera);
			}
		}
		/*************
		 * カメラサイズ選択
		 * ***********/
		//選択時
		private function CameraSize_cb_Serect(obj:Object) :void {
			trace("CameraSize_cb_Serect");
			trace(CameraSize_cb.getSelectedItem());
			SetMode_Camera();
			AttachCamera();
		}
		/**************
		 * マイク選択
		 *************/
		//クリック時
		private function Audio_cb_Click(e:ClickCountEvent):void {
			trace("Audio_cb_Click");
			Audio_cb.setListData(Microphone.names);
		}
		//選択時
		private function Audio_cb_Serect(obj:Object):void {
			trace("Audio_cb_Ｓｅｒｅｃｔ");
			trace(Audio_cb.getSelectedItem());
			mic = Microphone.getMicrophone(Audio_cb.getSelectedIndex());
			initMic();
			if(StartFlag){
				LS.Set_AudioStream(mic);
			}
		}
		/**************
		 * ＦＰＳ選択
		 * ***********/
		//選択時
		private function Fps_cb_Serect(obj:Object):void {
			trace("Fps_cb_Serect");
			trace(Fps_cb.getSelectedItem());
			SetMode_Camera();
			AttachCamera();
		}
		
		/********************
		 * スライダーイベント群
		 * ******************/
		//画質スライダー
		private function Video_slider_Serect(e:InteractiveEvent):void {
			trace("Video_slider_Serect");
			trace(Video_slider.getValue());
			Vslider_timer.start();
		}
		//音質スライダー
		private function Audio_slider_Serect(e:InteractiveEvent):void {
			trace("Audio_slider_Serect");
			trace(Audio_slider.getValue());
			Aslider_timer.start();
		}
		//音量スライダー
		private function Miclevel_slider_Serect(e:InteractiveEvent):void {
			trace("Miclevel_slider_Serect");
			if(null != mic){
				mic.gain = Miclevel_slider.getValue();
			}
		}
		/********************
		 * ボタンイベント
		 * ******************/
		//配信開始ボタン
		private function LiveStartButton_Serect(e:ClickCountEvent):void {
			trace("LiveStartButton_Serect");
			if (false == StartFlag) {
				//配信終了ボタンに表示切り替え
				LiveStartButton.setBackground(new ASColor(0xCC0000, 1));
				LiveStartButton.setText("配信終了");
				LiveStart();
			}else {
				//配信開始ボタンに表示切り替え
				LiveStartButton.setBackground(new ASColor(0x99ff00, 1));
				LiveStartButton.setText("配信開始");
				LiveEnd();
			}
		}
		/************
		 * タイマーイベント
		 ************/
		//VUメーターを動かすためのタイマー
		private function MicMeter_Timer(e:TimerEvent):void {
			if (mic == null) {
				//trace("マイクがありません");
				Meter_timer.stop();
				return;
			}
			MG.DrawMeter(mic.activityLevel);//VUメーターを描画する
		}
		//画質スライダーの値が変更されたため、Cameraに反映させる
		private function Change_Vslider(e:TimerEvent):void {
			Vslider_timer.stop();
			SetQuality_Camera();
			AttachCamera();
			trace("Vslider:call Change");
		}
		//音質スライダーの値が変更されたため、マイクに反映させる
		private function Change_Aslider(e:TimerEvent):void {
			Aslider_timer.stop();
			SetQuality_Mic();
			trace("Aslider:call Change");
		}
		//サムネイルをupload
		private function Capture_Event(e:TimerEvent):void {
			/*※重要 shule処理
			* サムネイル取得処理を入れる
			* videoからサムネを取得*/
			
			//映像配信中ならば
			if(Video_check.isSelected()){
				Capture.up(video);
				trace("サムネUP");
			}
		}
		//LiveStream_Classから、配信を始めたイベントを取得
		private function StartEvent(e:Event):void {
			if(Video_check.isSelected())
				LS.Set_CameraStream(camera);
			if(Audio_check.isSelected())
				LS.Set_AudioStream(mic);
		}
		//*************************************************************
		private function LiveStart():void {
			Capture_timer.start();
			StartFlag = true;
			title.setRestrict("");//入力を制限
			content.setRestrict("");//入力を制限
			
			/**※重要　LBB処理
			 * dispatchEvent記述
			 * */
			dispatchEvent(new Event("LiveStart"));
			
			/**※重要　shule処理
			 * タイトル　title.getText()　と
			 * 本文　content.getText()　をサーバに送信 
			 * LS.initSndに配信者自身のIDを渡す
			 * ↓↓↓↓↓↓↓↓↓↓
			 */
			NetWork.sendLiveStart(title.getText(), content.getText());
			World.myChara.startLive(title.getText(), content.getText());
			
			trace("題名："+title.getText());
			trace("内容："+content.getText());
			LS.initSnd(Main.myID);
		}
		private function LiveEnd():void {
			Capture_timer.stop();
			StartFlag = false;
			title.setRestrict(null);//入力制限を解除
			content.setRestrict(null);//入力制限を解除
			LS.clearNetGroup();
		}
    }
}