package shule.net 
{
	import flash.net.Socket;
	import flash.system.Security;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import LBB.Chat;
	
	/**
	 * ...
	 * @author shule
	 */
	public class ServerConnect
	{
		// ソケット
		static private var socket:Socket = new Socket();
		
		////////////////////
		// 関数
		////////////////////
		
		// サーバへ接続
		static public function connect(host:String, netwalkPort:int, policyPort:int):void
		{
			socket.timeout = 5000;
			
			// ポリシーファイルを取得する
			Security.loadPolicyFile("xmlsocket:" + host + ":" + policyPort);
			//Security.loadPolicyFile("http://shule517.ddo.jp/NetWalk/PolicyFile.xml");
			
			// イベントの追加 
			socket.addEventListener(Event.CONNECT, onConnect); // サーバへ接続完了
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onReceive);  // サーバからデータを受信
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIoError); // IOエラー
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError); // セキュリティエラー
			socket.addEventListener(Event.CLOSE, onDisconnect); // 切断
			
			// サーバへ接続
			socket.connect(host, netwalkPort);
		}
		
		// サーバへ送信
		static public function send(packet:String):void
		{
			try
			{
				socket.writeMultiByte(packet + '\n', "shift_jis");
				socket.flush();
			}
			catch (e:Error)
			{
				trace("SocketError:" + e.message);
			}
		}
		
		////////////////////
		// サーバイベント関数
		////////////////////
		
		// サーバへ接続完了
		static private function onConnect(event:Event):void
		{
			trace("onConnect");
		}
		
		// サーバからデータを受信
		static private function onReceive(event:Event):void
		{
			//trace("onReceive");
			
			// データ受信
			var packet:String = socket.readMultiByte(socket.bytesAvailable, "utf-8");
			
			// パケット処理
			var pa:PacketAnalyzer = new PacketAnalyzer(packet);

			// イベント発生
			NetWork.dispatchEvent(new NetWorkEvent(pa));
		}
		
		// IOエラー
		static private function onIoError(event:Event):void
		{
			//Chat.outputChat.appendText("onIoError");
			trace("onIoError");
			ServerConnect.connect("shule517.ddo.jp", 2236, 843);
		}
		
		// セキュリティエラー
		static private function onSecurityError(event:Event):void
		{
			//Chat.outputChat.appendText("onSecurityError");
			trace("onSecurityError");
			ServerConnect.connect("shule517.ddo.jp", 2236, 843);
		}
		
		// 切断
		static private function onDisconnect(event:Event):void
		{
			//Chat.outputChat.appendText("onDisconnect + ServerConnect.connect");
			trace("onDisconnect");
			ServerConnect.connect("shule517.ddo.jp", 2236, 843);
		}
	}
}
