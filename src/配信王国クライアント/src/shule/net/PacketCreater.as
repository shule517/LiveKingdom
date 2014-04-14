package shule.net 
{
	/**
	 * ...
	 * @author shule
	 */
	public class PacketCreater
	{
		// ヘッダ番号
		private var headerNo:int = 0;
		
		// パケットデータ
		private var packetData:String = "";
		
		// コンストラクタ
		public function PacketCreater(headerNo:int)
		{
			this.headerNo = headerNo;
		}
		
		// 文字データ追加
		public function addStrData(strData:String):void
		{
			// (int)データサイズの長さ | (StrInt)データサイズ | (str)文字データ
			var dataSizeLength:int = (String)(strData.length).length;
			var dataSize:int = strData.length;

			// データ追加
			packetData += String.fromCharCode(dataSizeLength) + dataSize + strData;
		}
		
		// 数値データ追加
		public function addIntData(intData:int):void
		{
			// (int)データサイズ | (StrInt)数値データ
			var dataSize:int = (String)(intData).length;

			packetData += String.fromCharCode(dataSize) + intData;
		}
		
		// 文字データへ変換
		public function toString():String
		{
			var packetSize:String = "" + (packetData.length);
			var str:String = String.fromCharCode(packetSize.length) + packetSize + String.fromCharCode(headerNo) + packetData;
			
			return str;
		}
	}
}
