package Server;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

import Frame.Frame;

/******************************
 * NetWalk待ち受けスレッド
*******************************/
public class NetWalkServer extends Thread
{
	/******************************
	 * メンバ変数
	*******************************/
	private int portNo = 0;			// ポート番号
	static boolean isClose = false;	// 終了判定
	
	/******************************
	 * コンストラクタ
	*******************************/
	public NetWalkServer(int portNo)
	{		
		// ポート番号を代入
		this.portNo = portNo;
		
		// スレッドを開始
		start();
	}
	
	/******************************
	 * メインループ
	*******************************/
	public void run()
	{
		try
		{
			ServerSocket server = new ServerSocket(portNo);
			Frame.appendDebugText("サーバ(Port:" + portNo + ")を起動しました");
			
			// 接続待ちループ
			while (isClose == false)
			{
				Socket socket = server.accept();
				Frame.appendDebugText("接続 ：" + socket.getInetAddress().getHostAddress());
				
				new NetWalkClient(socket);
			}
		}
		catch (IOException e)
		{
			Frame.appendDebugText(e.toString());
		}
	}
	
	/******************************
	 * 終了処理
	*******************************/
	static void close()
	{
		Frame.appendDebugText("NetWalkServer : 終了処理");
		isClose = true;
	}
}
