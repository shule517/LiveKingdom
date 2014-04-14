package shule.net 
{
	/**
	 * ...
	 * @author shule
	 */
	public class PacketAnalyzer
	{
		private var packet:String = ""; // 生データ
		private var index:Number = 0; // データのインデックス
		private var header:Number = 0; // ヘッダ
		
		// コンストラクタ
		public function PacketAnalyzer(packet:String)
		{
			this.packet = packet;
			analyze();
		}
		
		////////////////////
		// private : 解析
		////////////////////
		
		// パケットを解析
		public function analyze():void
		{
			// パケットサイズの長さを取得
			var packetSizeLength:Number = getPacketInt();
			
			// パケットサイズを取得
			var packetSize:int = getPacketStrNum(packetSizeLength);
			
			// ヘッダ取得
			header = getPacketInt();
			
			// 実際に取得したパケットのサイズ
			var realPacketLength:int = packet.length - index;
			
			trace("「ヘッダ：" + header + "」 「サイズ(実際)： " + packetSize + "(" + realPacketLength + ")」 「サイズの長さ：" + packetSizeLength + "」\t\t「" + packet + "」");
			
			if (realPacketLength == packetSize)
			{
				trace("パケットサイズ一致");
			}
			else if (realPacketLength > packetSize)
			{
				trace("パケットサイズが大きい サイズ(実際)： " + packetSize + "(" + realPacketLength + ")");
				
				var data:String = "";
				for (var i:int = 1 + packetSizeLength + 1 + packetSize; i < packet.length; i++)
				{
					data += packet.charAt(i);
				}
				
				// パケット処理
				var pa:PacketAnalyzer = new PacketAnalyzer(data);
				
				// イベント発生
				NetWork.dispatchEvent(new NetWorkEvent(pa));
			}
			else if (realPacketLength < packetSize)
			{
				trace("パケットサイズが小さい サイズ(実際)： " + packetSize + "(" + realPacketLength + ")");
			}
		}
		
		////////////////////
		// public : データ取得関数
		////////////////////
		
		// ヘッダを取得
		public function getHeader():int
		{
			return header;
		}
		
		// 生データから「文字」を取得
		public function getPacketStr(size:int):String
		{
			var str:String = "";
			
			for (var i:int = 0; i < size; i++)
			{
				str += packet.charAt(index);
				index++;
			}
			
			return str;
		}
		
		// 生データから「数値」を取得
		public function getPacketInt():int
		{
			var n:Number = packet.charCodeAt(index);
			index++;
		
			return n;
		}
		
		// 生データから「数値（文字）」を取得
		public function getPacketStrNum(size:int):int
		{
			var str:String = "";
			var num:int = 0;
			
			for (var i:int = 0; i < size; i++)
			{
				str += packet.charAt(index);
				index++;
			}
			
			try
			{
				num = parseInt(str);
			}
			catch (e:ArgumentError)
			{
				trace("getPacketInt : " + e.message + e.name);
			}
			
			return num;
		}
	}
}
