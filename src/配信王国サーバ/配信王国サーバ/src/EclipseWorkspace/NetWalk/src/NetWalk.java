
import Data.Data;
import Frame.Frame;
import Server.NetWalkServer;
import Server.PolicyServer;
import Thread.SyncThread;


public class NetWalk
{
	/******************************
	 * メイン
	*******************************/
	public static void main(String[] args)
	{
		// GUI起動
		new Frame();
		
		// ポリシーサーバ起動
		new PolicyServer(843);
		
		// NetWalkServer起動
		new NetWalkServer(2236);
		
		// Data初期化
		new Data();
		
		// 同期スレッド
		//new SyncThread();
	}
}
