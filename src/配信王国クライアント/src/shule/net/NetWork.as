package shule.net
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author shule
	 */
	public class NetWork
	{
		/******************************
		* メンバ変数
		*******************************/
		static public var myId:String = "";
		
		////////////////////
		// パケット送信
		////////////////////
		
		/******************************
		* パケット送信：配信終了
		*******************************/
		static public function sendLiveStop():void
		{
			// パケットを作成
			var packet:PacketCreater = new PacketCreater(Header.PacketLiveStop);
			
			// パケットを送信
			ServerConnect.send(packet.toString());			
		}
		
		/******************************
		* パケット送信：ログイン認証
		* id : ログインID
		* pw : ログインPW
		*******************************/
		static public function login(id:String, pw:String):void
		{
			// IDを登録
			myId = id;
			
			// パケットを作成
			var packet:PacketCreater = new PacketCreater(Header.PacketLoginAuth);
			packet.addStrData(id); // ログインID
			packet.addStrData(pw); // ログインPW
			
			// パケットを送信
			ServerConnect.send(packet.toString());
		}
		
		/******************************
		* 配信開始
		* title : 配信タイトル
		* detail : 配信詳細
		*******************************/
		static public function sendLiveStart(title:String, detail:String):void
		{
			// パケットを作成
			var packet:PacketCreater = new PacketCreater(Header.PacketLiveStart);
			packet.addStrData(title); // 配信タイトル
			packet.addStrData(detail); // 配信詳細
			
			// パケットを送信
			ServerConnect.send(packet.toString());
		}
		
		/******************************
		* パケット送信：チャット
		* text : チャット内容
		*******************************/
		static public function sendChat(text:String):void
		{
			// パケットを作成
			var packet:PacketCreater = new PacketCreater(Header.PacketChat);
			packet.addStrData(text); // チャット内容
			
			// パケットを送信
			ServerConnect.send(packet.toString());
		}
		
		/******************************
		* パケット送信：配信用チャット
		* id : 配信者ID
		* text : 配信者用チャット内容
		*******************************/
		static public function sendLiveChat(id:String, text:String):void
		{
			// パケットを作成
			var packet:PacketCreater = new PacketCreater(Header.PacketLiveChat);
			packet.addStrData(id);	 // 配信者ID
			packet.addStrData(text); // チャット内容
			
			// パケットを送信
			ServerConnect.send(packet.toString());
		}
		
		/******************************
		* パケット送信：キャラ移動
		* x : 移動位置x
		* y : 移動位置y
		*******************************/
		static public function sendMoveCharactor(x:int, y:int):void
		{
			// パケットを作成
			var packet:PacketCreater = new PacketCreater(Header.PacketMoveCharactor);
			packet.addIntData(x); // 移動位置x
			packet.addIntData(y); // 移動位置y
			
			// パケットを送信
			ServerConnect.send(packet.toString());
		}
		
		/******************************
		* パケット送信：配信視聴
		* id : 視聴する配信者ID
		*******************************/
		static public function sendListenStart(id:String):void
		{
			// パケットを作成
			var packet:PacketCreater = new PacketCreater(Header.PacketListenStart);
			packet.addStrData(id);
			
			// パケットを送信
			ServerConnect.send(packet.toString());
		}
		
		/******************************
		* パケット送信：配信視聴終了
		*******************************/
		static public function sendListenStop():void
		{
			// パケットを作成
			var packet:PacketCreater = new PacketCreater(Header.PacketListenStop);
			
			// パケットを送信
			ServerConnect.send(packet.toString());
		}
		
		/******************************
		* パケット送信：おっおっ
		*******************************/
		static public function sendOxOx():void
		{
			// パケットを作成
			var packet:PacketCreater = new PacketCreater(Header.PacketOxOx);
			
			// パケットを送信
			ServerConnect.send(packet.toString());
		}
		
		////////////////////
		// 固定
		////////////////////
		
		/******************************
		* イベント
		*******************************/
		static protected var event:EventDispatcher;
		
		/******************************
		* 初期化
		*******************************/
		static public function init():void
		{
			// 初期化されていなければ、初期化
			if (!event)
			{
				event = new EventDispatcher();
			}
		}
		
		/******************************
		* イベント登録
		*******************************/
		static public function addEventListener(type:int, listener:Function):void
		{
			init();
			event.addEventListener(type.toString(), listener);
		}
		
		/******************************
		* イベント発生
		*******************************/
		static public function dispatchEvent(e:Event):void
		{
			init();
			event.dispatchEvent(e);
		}
	}
}
