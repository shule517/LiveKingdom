package poo
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.AsyncErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import LBB.Thread;
	import shule.net.NetWork;
	import shule.world.World;
	//import flash.filesystem.FileStream;
    import flash.media.Camera;
    import flash.media.Video;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.net.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;		
	/**
	 * 配信を送受信するためのクラス
	 * ...
	 * デストラクタの代わり
	 * 　clearNetGroup()
	 * @author poo
	 */
	public class LiveStreamClass extends EventDispatcher
	{
		//ストリーミングサーバのアドレス
		private const rtmfp_srv:String = "rtmfp://stratus.adobe.com/";
		//developerkey
		private const dev_key:String = "02b74c02c0d43883e5c00ac1-a17d7df2402f";
        private var _video:Video;		//受信した映像を入れる
        private var nc:NetConnection;	//ネットコネクション
        private var sendstream:NetStream;//送信用ストリーム
		public var recivestream:NetStream;//受信用ストリーム
		private var _groupSpec:String;
		//ピアストネットワーク
		private var GROUPNAME:String;//グループ名
		private var netgroup:NetGroup;
		private var groupSpecifier:GroupSpecifier;
		private var SendStream_FLAG:Boolean;//配信しているか、していないか
		private var ReciveStream_FLAG:Boolean;//受信しているか、していないか
		private var peer_count:Number;//隣人ノード数
		//デバック用テキストフィールド
		public var Text:TextField;
		public var BufferText:TextField;
		//タイマー
		private var BufferTimer:Timer;
		private var Bufferfull_Timer:Timer;
		private var Receive_Timer:Timer;
		//ストリームの経過時間を入れる
		private var Rectime:Number;
		//ロード画面に終了を知らせるためのフラグ
		private var load_Flag:Boolean; //false：イベントが未発生　true：イベント発生済み
		//音量
		private var trans:SoundTransform;
		/*コンストラクタ
		 * */
		public function LiveStreamClass():void {
			SendStream_FLAG = false;
			ReciveStream_FLAG = false;
			load_Flag = false;
			_groupSpec = "";
			peer_count = 0;			
			Text = new TextField();
			Text.background = true;
			Text.border = true;
			Text.mouseWheelEnabled = true;
			Text.selectable = false;
			Text.multiline = true;
			BufferText = new TextField();
			BufferText.textColor = 0xffc00;
			BufferTimer = new Timer(800, 0);
			BufferTimer.addEventListener(TimerEvent.TIMER, BufferCheck);
			Bufferfull_Timer = new Timer(4000, 0);
			Bufferfull_Timer.addEventListener(TimerEvent.TIMER, BufferEnd);
			Receive_Timer = new Timer(30000, 0);
			Receive_Timer.addEventListener(TimerEvent.TIMER, EndCheck);
			Rectime = -1;
		}
		/*ピアストネットワークへの接続
		 * ネットコネクションを確立した時に呼ばれる　関数netStatusHandler
		 * 引数　なし
		 * 戻り値　なし
		 * */
		private function onConnect():void {
			groupSpecifier = new GroupSpecifier(GROUPNAME);
			groupSpecifier.postingEnabled = true;
			groupSpecifier.serverChannelEnabled = true;	
			groupSpecifier.multicastEnabled = true;
			_groupSpec = groupSpecifier.groupspecWithAuthorizations();
			netgroup = new NetGroup(nc, groupSpecifier.toString());
			netgroup.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		/*ネットステータスイベント
		 * ネットコネクションや、隣人ノードとの接続情報を受け取る
		 * */
		private function netStatusHandler(e:NetStatusEvent):void {
			switch(e.info.code) {
				case "NetConnection.Connect.Success":
					this.Log("ネットコネクション:成功");
					onConnect();
					this.Log("グループ接続:成功");
					break;
                case "NetConnection.Connect.Closed":
                    this.Log("接続解除");
					clearNetGroup();
                    break;
                case "NetConnection.Connect.Faild":
                    this.Log("接続失敗");
					clearNetGroup();
                    break;
                case "NetConnection.Connect.Rejected":
                    this.Log("接続拒否");
					clearNetGroup();
					break;
				case"NetGroup.Connect.Success":
					if (SendStream_FLAG) {
						sendVideo();
					}else if (ReciveStream_FLAG) {
						receiveVideo();
					}
				case "NetGroup.Posting.Notify":
					//this.Log("onPosting");
					break;
				case "NetGroup.Connect.Rejected":
				case "NetGroup.Connect.Failed":
					//this.Log("doDisconnect; ");
					break;
				case "NetGroup.Neighbor.Connect"://隣人ノードに接続した　or　された
					peer_count++;
					this.Log("隣人ノード接続: "+peer_count+"人");
					break;
				case "NetGroup.Neighbor.Disconnect"://隣人ノードを切断した　or された
					peer_count--;
					this.Log("隣人ノード切断");
					break;
				case "NetGroup.MulticastStream.UnpublishNotify"://配信が終了した
					if (ReciveStream_FLAG) {
						SetBufferText("");
						clearNetGroup();
						dispatchEvent(new Event("STREAM_EVENT_END"));
					}
				default:
					//this.Log("netStatusHandler:" + e.info.code);
			}
		}
		/*グループから切断
		 * */
		public function clearNetGroup():void {
			BufferTimer.stop();
			Receive_Timer.stop();
			if (SendStream_FLAG)
				this.Log("配信終了");
			if(null != netgroup){
				netgroup.close();
				netgroup = null;
				this.Log("グループから切断");
			}

			/**※重要
			 * アバターにつけた色を消す処理
			 * */
			// 配信終了
			if (SendStream_FLAG)
			{
				World.myChara.stopLive();
				NetWork.sendLiveStop();
			}
			
			SendStream_FLAG = false;
			ReciveStream_FLAG = false;
			load_Flag = false;
			if(recivestream)
				recivestream.close();
			if(sendstream)
				sendstream.close();
			if (nc) {
				nc.close();
				nc = null;
			}
			if (_video) {
				_video.clear();
			}
			_groupSpec = "";
			peer_count = 0;
		}
		
		/*受信ボタンを押すことで呼ばれる
		 * 引数　　video と　配信者のユーザーID
		 * 戻り値　なし
		 * */
        public function initRcv(VIDEO:Video, userID:String):void {
			clearNetGroup();
			
			/**※重要　shule処理
			 * アバターに色をつける処理
			 */
			SetBufferText("");
			_video = new Video();
			_video = VIDEO;
			GROUPNAME = userID + "NetWalk";
			this.Log("グループID:"+GROUPNAME);
			//ネットコネクションとかの設定
            nc = new NetConnection();
            nc.objectEncoding = ObjectEncoding.AMF0;
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            //nc.addEventListener(NetStatusEvent.NET_STATUS,onRcvNetStatus);
            nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
            nc.connect(rtmfp_srv + dev_key);  //ストリーミングサーバーアドレス
			ReciveStream_FLAG = true;
        }
		/*関数netStatusHandler
		 * "NetGroup.Neighbor.Connect"より呼ばれる
		 * ストリーミング動画を受信する
		 * 引数　なし
		 * 戻り値　なし
		 * */
		private function receiveVideo():void {
            recivestream = new NetStream(nc, _groupSpec);//相手に接続
			trans = recivestream.soundTransform;
			//this.Log("receiveVideo:接続処理");
            _video.attachNetStream(recivestream);
			recivestream.bufferTime = 3;
			recivestream.play(_groupSpec);
			//this.Log("receiveVideo:再生開始");
			recivestream.addEventListener(NetStatusEvent.NET_STATUS, onRcvNetStatus);
			recivestream.addEventListener(IOErrorEvent.IO_ERROR, streamError);
        }
		/*送信するときの初期設定
		 * 引数　string 配信者のID
		 * 戻り値　なし
		 * Activeなカメラやマイクがないとreturnします
		 * */
        public function initSnd(ID:String):void {
			GROUPNAME = ID + "NetWalk"
			//this.Log("グループID：" + GROUPNAME);
            nc = new NetConnection();
            nc.objectEncoding = ObjectEncoding.AMF0; 
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
           // nc.addEventListener(NetStatusEvent.NET_STATUS,onSndNetStatus);
            nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
            nc.connect(rtmfp_srv + dev_key); // ストリーミングサーバーアドレス
			SendStream_FLAG = true;
        }
		/*ストリーミング動画配信を始める　onSndNetStatus関数から呼ばれる
		 * 引数　なし
		 * 戻り値　なし
		 * */
        private function sendVideo():void {
			//ピアと直接接続する
            sendstream = new NetStream(nc, _groupSpec);
			sendstream.publish(_groupSpec);
			this.Log("配信開始");
			sendstream.addEventListener(NetStatusEvent.NET_STATUS, onSndNetStatus);
			sendstream.addEventListener(IOErrorEvent.IO_ERROR, streamError);
			dispatchEvent(new Event("LIVESTREAM_EVENT_START"));//配信が始まったことを示す
        }		
		//ネットコネクション時のイベント（送信）
        public function onSndNetStatus(e:NetStatusEvent):void {
            switch(e.info.code){
                default:
                    //this.Log("onSndNetStatus:"+e.info.code);
            }
        }
		//ネットコネクション時のイベント（受信）
		public function onRcvNetStatus(e:NetStatusEvent):void {
            switch(e.info.code){
				case "NetStream.Buffer.Empty"://バッファ中
					//this.Log(e.info.code);
					BufferTimer.start();
					break;
				case "NetStream.Buffer.Full"://バッファが満たされました
					//this.Log(e.info.code);
					BufferTimer.stop();
					SetBufferText("バッファ完了");
					if(false == load_Flag){
						dispatchEvent(new Event("STREAM_EVENT_PLAY"));
						load_Flag = true;
						Receive_Timer.start();
					}
					Bufferfull_Timer.start();
                    break;
				case "NetStream.Play.UnpublishNotify"://配信が終了した
					SetBufferText("");
					clearNetGroup();
					dispatchEvent(new Event("STREAM_EVENT_END"));
					break;
                default:
                    //this.Log("onRcvNetStatus:"+e.info.code);
            }
        }
		//ストリーミング動画を受信する時にエラーが生じた
		private function streamError(e:IOErrorEvent):void {
			clearNetGroup();
			this.Log("ネットワーク処理に失敗");
		}
        private function onSecurityError(e:SecurityErrorEvent):void {
			clearNetGroup();
            this.Log("セキュリティエラー");
        }
        private function onAsyncError(e:AsyncErrorEvent):void {
			clearNetGroup();
            this.Log("同期エラー");
        }	
		//デバックに出力
		private function Log(str:String ):void
		{
			Text.appendText(str + "\n" );
			Text.scrollV = Text.maxScrollV;
		}
		//送信ストリームに映像を入れる
		public function Set_CameraStream(c:Camera):void {
			if(sendstream!=null)
				sendstream.attachCamera(c);
		}
		//送信ストリームに音声を入れる
		public function Set_AudioStream(m:Microphone):void {
			if(sendstream!=null)
				sendstream.attachAudio(m);
		}
		private function SetBufferText(str:String):void {
			BufferText.text = str;
		}
		//バッファ
		private function BufferCheck(e:TimerEvent):void {
			var i:int;
			if (recivestream.time) {
				i = recivestream.bufferLength / recivestream.bufferTime * 100;
				Math.floor(i);
				SetBufferText("バッファ中(" + i.toString() + "％ )");
			}
		}
		//バッファ完了
		private function BufferEnd(e:TimerEvent):void {
			SetBufferText("");
			Bufferfull_Timer.stop();
		}
		//音量設定
		public function Set_volume(num:Number):void{
			if (recivestream.time) {
				trans.volume = num;
				recivestream.soundTransform = trans;
			}
		}
		//配信が終了しているかの確認
		//recevestreamのタイマーが動いていなければ、終了と判断する
		private function EndCheck(e:TimerEvent):void {
			if (Rectime == recivestream.time) {
				SetBufferText("");
				clearNetGroup();
				dispatchEvent(new Event("STREAM_EVENT_END"));
				Receive_Timer.stop();
			}else {
				Rectime = recivestream.time;
			}
		}
	}
}