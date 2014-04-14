package Lib;

import Frame.Frame;

public class PacketAnalyzer
{
	/******************************
	 * メンバ変数
	*******************************/
	public PacketHeader header = PacketHeader.toEnum(0);
	private String packet = "";
	private int index = 0;

	/******************************
	 * コンストラクタ
	*******************************/
	public PacketAnalyzer(String packet)
	{
		this.packet = packet;
		
		analyze();
	}

	/******************************
	 * データ（Int）を取得
	*******************************/
	public int getIntData()
	{
		// (int)データサイズ | (StrInt)数値データ

		int num = 0;
		int dataSize = getDataInt();
		String strNum = getDataStr(dataSize);

		try
		{
			num = Integer.parseInt(strNum);
		}
		catch (Exception e)
		{
			System.out.println("getPacketInt : " + e.toString());
		}
		
		return num;
	}

	/******************************
	 * データ（Str）を取得
	*******************************/
	public String getStrData()
	{
		// (int)データサイズの長さ | (StrInt)データサイズ | (str)文字データ

		int dataSizeLength = getDataInt();
		int dataSize = getDataInt(dataSizeLength);
		
		return getDataStr(dataSize);
	}
	
	/******************************
	 * 処理
	*******************************/
	private void analyze()
	{
		// パケットサイズの長さを取得
		int packetSizeLength = getDataInt();
		//Frame.appendDebugText("packetSizeLength : " + packetSizeLength);

		// パケットサイズを取得
		int packetSize = getDataInt(packetSizeLength);
		//Frame.appendDebugText("packetSize : " + packetSize);

		// 実際に取得したパケットのサイズ
		int realPacketLength = packet.length() - index - 1;
		//Frame.appendDebugText("realPacketLength : " + realPacketLength);
		
		// データサイズが一致
		if (realPacketLength == packetSize)
		{
			//Frame.appendDebugText("エンドマーカ一致");
		}
		// データが多い
		else if (realPacketLength > packetSize)
		{
			// 調整する
			Frame.appendDebugText("PacketAnalyzer.analyze : データが多い（エンドマーカ不一致）");
		}
		// データが少ない
		else if (realPacketLength < packetSize)
		{
			Frame.appendDebugText("PacketAnalyzer.analyze : データが少ない（エンドマーカ不一致）");
			//throw new Exception("パケットのサイズが少ないです");
		}
		
		// ヘッダーを取得
		int headerNo = getDataInt();
		//Frame.appendDebugText("headerNo : " + headerNo);
		header = PacketHeader.toEnum(headerNo);
		//Frame.appendDebugText("header : " + header);
	}

	/******************************
	 * 文字列データを取得(size byte)
	*******************************/
	private String getDataStr(int size)
	{
		String str = "";
		
		for (int i = 0; i < size; i++)
		{
			str += (char)packet.charAt(index);
			index++;
		}
		
		return str;
	}
	
	/******************************
	 * 数値データを取得(1byte)
	*******************************/
	private int getDataInt()
	{
		char n = 0;
		
		try
		{
			n = packet.charAt(index);
			index++;
		}
		catch (Exception e)
		{
			Frame.appendDebugText("PacketAnalyzer.getDataInt : " + e.getMessage());
		}
		
		return n;
	}
	
	/******************************
	 * 数値データを取得(size byte)
	*******************************/
	private int getDataInt(int size)
	{
		String str = "";
		int num = 0;
		
		try
		{
			for (int i = 0; i < size; i++)
			{
				str += (char)packet.charAt(index);
				index++;
			}
		
			num = Integer.parseInt(str);
		}
		catch (Exception e)
		{
			Frame.appendDebugText("PacketAnalyzer.getDataInt : " + e.getMessage());
		}
		
		return num;
	}
}
