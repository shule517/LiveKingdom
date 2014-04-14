package Server;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.ServerSocket;
import java.net.Socket;

import Frame.Frame;

public class PolicyServer extends Thread
{
	/******************************
	 * メンバ変数
	*******************************/
	private int portNo = 0;			// ポート番号
	static boolean isClose = false;	// 終了判定

	/******************************
	 * コンストラクタ
	*******************************/
	public PolicyServer(int portNo)
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
			//Frame.appendPolicyText("サーバ(Port:" + portNo + ")を起動しました");
			
			// 接続待ちループ
			while (isClose == false)
			{
				Socket socket = server.accept();
				//Frame.appendPolicyText("接続 " + socket.getInetAddress().getHostAddress());
				
				new PolicyClient(socket);
			}
		}
		catch (IOException e)
		{
			Frame.appendPolicyText(e.toString());
		}
	}
	
	/******************************
	 * 終了処理
	*******************************/
	static public void close()
	{
		isClose = true;
	}
}

/******************************
 * ポリシークライアントスレッド
*******************************/
class PolicyClient extends Thread
{
	/******************************
	 * メンバ変数
	*******************************/

	// ソケット
	private Socket socket = null;
	
	/******************************
	 * コンストラクタ
	*******************************/
	PolicyClient(Socket socket)
	{
		this.socket = socket;
		
		start();
	}
	/******************************
	 * メインループ
	*******************************/
	public void run()
	{
		// 出力ストリームを作成
		PrintWriter out = null;

		try
		{
			out = new PrintWriter( new OutputStreamWriter(socket.getOutputStream(), "UTF8"), true);
		}
		catch (UnsupportedEncodingException e)
		{
			Frame.appendPolicyText(e.toString());
		}
		catch (IOException e)
		{
			Frame.appendPolicyText(e.toString());
		}
		
		// Policyファイルを送信
		out.print("<cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"*\" /></cross-domain-policy>");
		out.flush();

		// 終了
		out.close();
		
		try
		{
			socket.close();
		}
		catch (IOException e)
		{
			Frame.appendPolicyText(e.toString());
		}
	}
}
