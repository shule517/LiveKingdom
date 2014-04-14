package shule.world 
{
	import flash.utils.Dictionary;
	import org.libspark.betweenas3.tweens.ITween;
	import shule.net.NetWork;
	import shule.net.NetWorkEvent;
	import shule.net.Header;
	import org.libspark.betweenas3.easing.Cubic;
	import org.libspark.betweenas3.BetweenAS3;
	/**
	 * ...
	 * @author shule
	 */
	public class Network
	{
		// キャラリスト
		static public var charaList:Dictionary;
		
		// コンストラクタ
		public function Network(charaList:Dictionary) 
		{
			// 代入
			Network.charaList = charaList;
						
			// イベント追加
			NetWork.addEventListener(Header.PacketAddCharactor, onAddCharactor);
			NetWork.addEventListener(Header.PacketRemoveCharactor, onRemoveCharactor);
			NetWork.addEventListener(Header.PacketMoveCharactor, onMoveCharactor);
			NetWork.addEventListener(Header.PacketOxOx, onOxOx);
			NetWork.addEventListener(Header.PacketChat, onChat);
			NetWork.addEventListener(Header.PacketLiveChat, onLiveChat);
			NetWork.addEventListener(Header.PacketLiveStart, onLiveStart);
			NetWork.addEventListener(Header.PacketLiveStop, onLiveStop);
			NetWork.addEventListener(Header.PacketListenStart, onListenStart);
			//NetWork.addEventListener(Header.PacketListenStop, onListenStop);
		}
		
		/******************************
		* 視聴開始
		*******************************/
		private function onListenStart(event:NetWorkEvent):void
		{
			// いなければキャラ追加
			if (!charaList[event.id])
			{
				charaList[event.id] = new CharaData(event.id);
			}
			
			// 視聴データ代入
			var chara:CharaData = charaList[event.id];
			chara.liveID = event.liveID;
		}
		
		/******************************
		* おっおっ
		*******************************/
		private function onOxOx(event:NetWorkEvent):void
		{
			// いなければキャラ追加
			if (!charaList[event.id])
			{
				charaList[event.id] = new CharaData(event.id);
			}
			
			// 移動する
			var chara:CharaData = charaList[event.id];
			chara.playOxOx();
		}
		
		/******************************
		* キャラ追加
		*******************************/
		private function onAddCharactor(event:NetWorkEvent):void
		{
			// いなければキャラ追加
			if (!charaList[event.id])
			{
				charaList[event.id] = new CharaData(event.id);
			}
			
			// 初期値
			var chara:CharaData = charaList[event.id];
			chara.x = event.x;
			chara.y = event.y;
		}
		
		/******************************
		* キャラ削除
		*******************************/		
		private function onRemoveCharactor(event:NetWorkEvent):void
		{
			if (event.id != "" && charaList[event.id])
			{
				charaList[event.id].close();
				delete charaList[event.id];
			}
		}
		
		/******************************
		* キャラ移動
		*******************************/
		private function onMoveCharactor(event:NetWorkEvent):void
		{
			// いなければキャラ追加
			if (!charaList[event.id])
			{
				charaList[event.id] = new CharaData(event.id);
			}
			
			// 移動する
			var chara:CharaData = charaList[event.id];
			chara.move(event.x, event.y);
		}
		
		/******************************
		* チャット
		*******************************/
		public function onChat(event:NetWorkEvent):void
		{
			// いなければキャラ追加
			if (!charaList[event.id])
			{
				charaList[event.id] = new CharaData(event.id);
			}

			// チャット発言
			var chara:CharaData = charaList[event.id];
			chara.showChat(/*event.id + " : " + */event.message);
		}
		
		/******************************
		* 配信用チャット
		*******************************/
		public function onLiveChat(event:NetWorkEvent):void
		{
			// いなければキャラ追加
			if (!charaList[event.id])
			{
				charaList[event.id] = new CharaData(event.id);
			}

			// チャット発言
			var chara:CharaData = charaList[event.id];
			chara.showLiveChat(event.liveID, event.message);
		}
		
		/******************************
		* 配信開始
		*******************************/
		public function onLiveStart(event:NetWorkEvent):void
		{
			// いなければキャラ追加
			if (!charaList[event.id])
			{
				charaList[event.id] = new CharaData(event.id);
			}
			
			// 配信開始
			if (Main.myID != event.id)
			{
				if (charaList[event.id])
				{
					var chara:CharaData = charaList[event.id];
					chara.startLive(event.title, event.detail);
					chara.liveID = event.id;
				}
			}
		}

		/******************************
		* 配信終了
		*******************************/
		public function onLiveStop(event:NetWorkEvent):void
		{
			// いなければキャラ追加
			if (!charaList[event.id])
			{
				charaList[event.id] = new CharaData(event.id);
			}
			
			// 配信終了
			if (Main.myID != event.id)
			{
				if (charaList[event.id])
				{
					charaList[event.id].stopLive();
				}
			}
		}
	}
}
