package shule.net 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author shule
	 */
	public dynamic class NetWorkEvent extends Event
	{
		// データ
		private var pa:PacketAnalyzer;
		
		// コンストラクタ
		public function NetWorkEvent(pa:PacketAnalyzer) 
		{
			// コピー
			this.pa = pa;
			
			// 親コンストラクタ起動
			super(pa.getHeader().toString(), false, false);
			
			switch (pa.getHeader())
			{	
				// 配信終了
				case Header.PacketLiveStop:
					this.id = getStrData();
				break;
				
				// 配信開始
				case Header.PacketLiveStart:
					this.id = getStrData();
					this.title = getStrData();
					this.detail = getStrData();
				break;

				// ログイン結果
				case Header.PacketLoginResult:
					this.result = (getIntData() == 1);
				break;
				
				// チャット
				case Header.PacketChat:
					this.id = getStrData();
					this.message = getStrData();
				break;
				
				// 配信用チャット
				case Header.PacketLiveChat:
					this.id = getStrData();
					this.liveID = getStrData();
					this.message = getStrData();
				break;
				
				// 視聴開始
				case Header.PacketListenStart:
					this.id = getStrData();
					this.liveID = getStrData();
				break;
				
				// 視聴終了
				case Header.PacketListenStop:
					this.id = getStrData();
				break;
				
				// キャラ追加
				case Header.PacketAddCharactor:
					this.id = getStrData();
					this.x = getIntData();
					this.y = getIntData();
					
					/*
					// 配列作成
					var array:Array = new Array();
					
					// データ取得
					var n:int = getIntData();
					for (var i:int = 0; i < n; i++)
					{
						var obj:Object = new Object();
						
						obj.id = getStrData();
						obj.x = getIntData();
						obj.y = getIntData();
						
						array.push(obj);
					}
					
					// 代入
					this.array = array;
					*/
				break;
				
				// キャラ削除
				case Header.PacketRemoveCharactor:
					this.id = getStrData();
				break;
				
				// キャラ移動
				case Header.PacketMoveCharactor:
					this.id = getStrData();
					this.x = getIntData();
					this.y = getIntData();
				break;
				
				// おっおっ
				case Header.PacketOxOx:
					this.id = getStrData();
				break;
				
				// 視聴開始
				case Header.PacketListenStart:
					this.id = getStrData();
					this.liveID = getStrData();
				break;
			}
		}
		
		////////////////////
		// private : データ取得関数
		////////////////////
		
		// 数値データを取得
		private function getIntData():int
		{
			var dataSize:int = pa.getPacketInt();
			return pa.getPacketStrNum(dataSize);
		}
		
		// 文字データを取得
		private function getStrData():String
		{
			var dataSizeLength:int = pa.getPacketInt();
			var dataSize:int = pa.getPacketStrNum(dataSizeLength);
			return pa.getPacketStr(dataSize);
		}
	}
}
