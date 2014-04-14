package Lib;

public enum PacketHeader
{
	None(0),

	// ログイン
	PacketLoginAuth(1),			// ログイン
	PacketLoginResult(2),		// ログイン結果

	// なぜかヘッダー10番は使えない
	
	// チャット
	PacketChat(11),				// チャット
	PacketChatPersonal(12),		// 個人宛チャット
	PacketLiveChat(13),			// 配信用チャット
	
	// キャラクター
	PacketAddCharactor(20),		// キャラ追加
	PacketRemoveCharactor(21),	// キャラ削除
	PacketMoveCharactor(22),	// キャラ移動
	PacketOxOx(23),				// おっおっ
	
	// 配信
	PacketLiveStart(30),		// 配信開始
	PacketLiveStop(31),			// 配信終了
	
	// 視聴
	PacketListenStart(40),		// 視聴開始
	PacketListenStop(41);		// 視聴終了
	
	/*	
	PacketGetMap(40),
	
	PAcketGetFriend(50);
	*/
	
	
	
	private int value;
	
	private PacketHeader(int n)
	{
		this.value = n;
	}
	
	// enum定数から整数へ変換
    public int toInt()
	{
        return value;
    }
	
    // 数値からenum定数へ変換
    public static PacketHeader toEnum(final int anIntValue)
	{
        for (PacketHeader d : values())
        {
            if (d.toInt() == anIntValue)
            {
                return d;
            }
        }
        return null;
    }
}
