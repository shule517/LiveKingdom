package Lib;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Map;

import Data.Data;
import Data.UserData;
import Frame.Frame;
import Thread.SendThread;
import Lib.PacketHeader;

public class Network
{
	/******************************
	 * メンバ変数
	*******************************/
	private SendThread sendThread = null; // 送信スレッド
	private BufferedReader in = null;	// 入力ストリーム
	private PrintWriter out = null;		// 出力ストリーム
	private Socket socket = null;		// ソケット
	public boolean isAlive = true;		// 終了フラグ
	private String myId = "";			// id
	
	/******************************
	 * コンストラクタ
	*******************************/
	public Network(Socket socket)
	{
		// ソケット
		this.socket = socket;
		
		// 初期化
		try
		{
			out = new PrintWriter( new OutputStreamWriter(socket.getOutputStream(), "UTF8"), true);
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			sendThread = new SendThread(out);
		}
		catch (IOException e)
		{
			Frame.appendDebugText("Network.Network " + e.getMessage());
		}
	}

	/******************************
	 * パケット受信
	*******************************/
	public PacketAnalyzer receive()
	{
		// パケット処理
		PacketAnalyzer pa = null;
		
		try
		{
			String packet = "";
			int c = in.read();
			
			// １パケット読み込む
			while (c != '\n')
			{
				// 切断チェック
				if (c == -1)
				{
					throw new IOException("切断");
				}
				
				packet += (char)c;
				c = in.read();
			}
			
			Frame.appendDebugText("受信(" + packet + ") ID(" + myId + ") " + socket);

			// パケット処理
			pa = new PacketAnalyzer(packet);
		}
		catch (IOException e)
		{
			// 切断
			close();
		}
		catch (Exception e)
		{
			Frame.appendDebugText("Network.receive " + e.getMessage());
			
			// 切断
			close();
		}
		
		return pa;
	}
	
	/******************************
	 * 終了処理
	*******************************/
	private void close()
	{
		Frame.appendDebugText("切断：ID(" + myId + ")" + socket);
		
		// クライアントデータを消す
		Data.user.remove(myId);
		
		// 周りの人に伝える　（とりあえず自分以外の全員に送る）
		for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
		{
			if (myId != user.getKey())
				user.getValue().network.sendRemoveCharactor(myId);
		}
		
		// 解放
		try
		{
			in.close();
			out.close();
			socket.close();
			sendThread.close();
		}
		catch (IOException e)
		{
			Frame.appendDebugText("Network.close : " + e.getMessage());
		}
		
		// 終了フラグ
		isAlive = false;
	}

	/******************************
	 * パケット送信：キャラクター削除
	*******************************/
	private void sendRemoveCharactor(String id)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketRemoveCharactor);
		
		// メッセージ
		pc.addStrData(id);
	
		// 送信
		sendThread.addPacket(pc);
	}

	/******************************
	 * パケット送信：ログイン結果
	 * 1 :　ログイン成功
	 * 0 : ログイン失敗
	*******************************/
	public void sendLoginResult(boolean result)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketLoginResult);
		
		if (result)
		{
			// ログイン認証
			pc.addIntData(1);
		}
		else
		{
			// ログイン失敗
			pc.addIntData(0);
		}
		
		// 送信
		sendThread.addPacket(pc);
	}

	/******************************
	 * IDを受け取る
	*******************************/
	public void setID(String id)
	{
		this.myId = id;
	}

	/******************************
	 * パケット送信：チャット
	*******************************/
	public void sendChat(String id, String chatMessage)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketChat);
	
		// メッセージ
		pc.addStrData(id);
		pc.addStrData(chatMessage);
	
		// 送信
		sendThread.addPacket(pc);
	}

	/******************************
	 * パケット送信：キャラクター追加
	*******************************/
	public void sendAddCharactor(String id, int x, int y)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketAddCharactor);
		
		// メッセージ
		pc.addStrData(id);
		pc.addIntData(x);
		pc.addIntData(y);
	
		// 送信
		sendThread.addPacket(pc);
	}

	/******************************
	 * パケット送信：キャラクター移動
	*******************************/
	public void sendMoveCharactor(String id, int x, int y)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketMoveCharactor);
		
		// メッセージ
		pc.addStrData(id);
		pc.addIntData(x);
		pc.addIntData(y);
	
		// 送信
		sendThread.addPacket(pc);
	}

	/******************************
	 * パケット送信：配信開始
	*******************************/
	public void sendLiveStart(String id, String title, String detail)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketLiveStart);
		
		// メッセージ
		pc.addStrData(id);
		pc.addStrData(title);
		pc.addStrData(detail);
	
		// 送信
		sendThread.addPacket(pc);
	}

	/******************************
	 * パケット送信：配信終了
	*******************************/
	public void sendListStop(String id)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketLiveStop);
		
		// メッセージ
		pc.addStrData(id);
	
		// 送信
		sendThread.addPacket(pc);
	}

	/******************************
	 * パケット送信：配信用チャット
	 * id : 自分のID
	 * liveID : 配信者ID
	 * livechatMessage : チャット内容
	*******************************/
	public void sendLiveChat(String id, String liveID, String livechatMessage)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketLiveChat);
		
		// メッセージ
		pc.addStrData(id);
		pc.addStrData(liveID);
		pc.addStrData(livechatMessage);
	
		// 送信
		sendThread.addPacket(pc);
	}

	/******************************
	 * パケット送信：視聴開始
	 * id : 自分のID
	 * liveID : 配信者ID
	*******************************/
	public void sendListenStart(String id, String liveID)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketListenStart);
		
		// メッセージ
		pc.addStrData(id);
		pc.addStrData(liveID);
	
		// 送信
		sendThread.addPacket(pc);
	}

	/******************************
	 * パケット送信：視聴終了
	 * id : 自分のID
	*******************************/
	public void sendListenStop(String id)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketListenStop);
		
		// メッセージ
		pc.addStrData(id);
	
		// 送信
		sendThread.addPacket(pc);
	}
	
	/******************************
	 * パケット送信：おっおっ
	 * id : 自分のID
	*******************************/
	public void sendOxOx(String id)
	{
		PacketCreater pc = new PacketCreater(PacketHeader.PacketOxOx);
		
		// メッセージ
		pc.addStrData(id);
	
		// 送信
		sendThread.addPacket(pc);
	}
}
