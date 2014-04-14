package shule.net
{
	/**
	 * ...
	 * @author shule
	 */
	public class Header
	{
		// なし
		public static const None:int = 0;
		
		// ログイン
		public static const PacketLoginAuth:int = 1;		// ログイン
		public static const PacketLoginResult:int = 2;		// ログイン結果

		// なぜかヘッダー10番は使えない
		
		// チャット
		public static const PacketChat:int = 11;			// チャット
		public static const PacketChatPersonal:int = 12;	// 個人宛チャット
		public static const PacketLiveChat:int = 13;		// 配信用チャット
		
		// キャラクター
		public static const PacketAddCharactor:int = 20;	// キャラ追加
		public static const PacketRemoveCharactor:int = 21;	// キャラ削除
		public static const PacketMoveCharactor:int = 22;	// キャラ移動
		public static const PacketOxOx:int = 23;			// おっおっ
		
		// 配信
		public static const PacketLiveStart:int = 30;		// 配信開始
		public static const PacketLiveStop:int = 31;		// 配信終了
		
		// 視聴
		public static const PacketListenStart:int = 40;		// 視聴開始
		public static const PacketListenStop:int = 41;		// 視聴終了
	}
}
