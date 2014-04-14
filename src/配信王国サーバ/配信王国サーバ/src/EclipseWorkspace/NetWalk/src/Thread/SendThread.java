package Thread;

import java.io.PrintWriter;
import java.util.concurrent.ConcurrentLinkedQueue;
import Frame.Frame;
import Lib.PacketCreater;

public class SendThread extends Thread
{
	/******************************
	 * メンバ変数
	*******************************/
	private ConcurrentLinkedQueue<PacketCreater> queue = null;
	private PrintWriter out = null;		// 出力ストリーム
	private boolean isAlive = true;

	/******************************
	 * コンストラクタ
	 * @param out 
	*******************************/
	public SendThread(PrintWriter out)
	{
		this.out = out;
		queue = new ConcurrentLinkedQueue<PacketCreater>();
		
		start();
	}

	/******************************
	 * パケットを追加
	*******************************/
	public void addPacket(PacketCreater pc)
	{
		queue.add(pc);
	}
	
	/******************************
	 * メインループ
	*******************************/
	public void run()
	{
		while (isAlive)
		{
			if (queue.size() > 0)
			{
				PacketCreater pc = queue.poll();

				try
				{
					String packet = pc.createPacket();
					Frame.appendDebugText("送信(" + packet + ") out(" + out + ")");
					out.write(packet);
					out.flush();
				}
				catch (Exception e)
				{
					System.out.println(e.toString());
				}
			}
			
			// Sleep
			try
			{
				Thread.sleep(1);
			}
			catch (InterruptedException e)
			{
				Frame.appendDebugText("SendThread.run : " + e.getMessage());
			}
		}
	}

	/******************************
	 * 終了処理
	*******************************/
	public void close()
	{
		isAlive = false;
	}
}
