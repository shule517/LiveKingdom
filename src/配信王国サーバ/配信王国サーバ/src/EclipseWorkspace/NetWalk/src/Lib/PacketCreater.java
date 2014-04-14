package Lib;
import Lib.PacketHeader;

public class PacketCreater
{
	/******************************
	 * メンバ変数
	*******************************/
	private PacketHeader header = PacketHeader.None;
	private String packetData = "";

	/******************************
	 * コンストラクタ
	*******************************/
	public PacketCreater(PacketHeader header)
	{
		// ヘッダー
		this.header = header;
	}

	/******************************
	 * 数値データを追加
	*******************************/
	public void addIntData(int num)
	{
		// (int)データサイズ | (StrInt)数値データ
		String numStr = "" + num;
		char dataSize = (char)numStr.length();

		packetData += dataSize + numStr;
	}

	/******************************
	 * 文字データを追加
	*******************************/
	public void addStrData(String str)
	{
		// (int)データサイズの長さ | (StrInt)データサイズ | (str)文字データ
		int dataSize = str.length();
		String dataSizeStr = "" + dataSize;
		char dataSizeLength = (char)dataSizeStr.length();
		
		packetData += dataSizeLength + dataSizeStr + str;
	}

	/******************************
	 * パケット作成
	*******************************/
	public String createPacket()
	{
		// 「パケットサイズの長さ」(1byte) + 「パケットサイズ」 + 「ヘッダー」(1byte) + 「データサイズ」
		
		int packetSize = packetData.length();
		String packetSizeStr = "" + packetSize;
		char packetSizeLength = (char)packetSizeStr.length();
		char headerByte = (char)header.toInt();

		return new String(packetSizeLength + packetSizeStr + headerByte + packetData);
	}
}

/*
public class PacketCreater
{
	/******************************
	 * メンバ変数
	*******************************
	private PacketHeader header = PacketHeader.None;
	private List<byte[]> dataList = new ArrayList<byte[]>();
	
	/******************************
	 * コンストラクタ
	*******************************
	public PacketCreater(PacketHeader header)
	{
		// ヘッダー
		this.header = header;
	}

	/******************************
	 * 数値データを追加
	*******************************
	public void addIntData(int num)
	{
		// (int)データサイズ | (StrInt)数値データ
		String numStr = "" + num;
		byte numBytes[] = numStr.getBytes();
		int size = numBytes.length;
		byte packetBytes[] = new byte[size + 1];
		
		// データサイズ
		packetBytes[0] = (byte)size;

		// データ
		for (int i = 0; i < numBytes.length; i++)
		{
			packetBytes[i + 1] = numBytes[i];
		}
		
		// データ追加
		dataList.add(packetBytes);
	}

	/******************************
	 * 文字データを追加
	*******************************
	public void addStrData(String str)
	{
		// (int)データサイズの長さ | (StrInt)データサイズ | (str)文字データ
		
		
		int size = str.length();
		String sizeStr = "" + size;
		
		String packetData = size + str;
		
		
		byte packetDataByte[] = packetData.getBytes();
		
		byte packetBytes[] = new byte[packetDataByte.length + 1];
		
		// データサイズの長さ
		packetBytes[0] = (byte)sizeStr.length();
		
		// データサイズ
		for (int i = 0; i < packetDataByte.length; i++)
		{
			packetBytes[i + 1] = packetDataByte[i];
		}
		
		dataList.add(packetDataByte);
		
		/*
		byte strBytes[] = str.getBytes();
		int size = strBytes.length;
		String sizeStr = "" + size;
		byte sizeBytes[] = sizeStr.getBytes();
		byte packetBytes[] = new byte[size + sizeBytes.length + 1];
		
		// データサイズの長さ
		packetBytes[0] = (byte)sizeBytes.length;
		
		// データサイズ
		for (int i = 0; i < sizeBytes.length; i++)
		{
			packetBytes[i + 1] = sizeBytes[i];
		}
		
		// データ
		for (int i = 0; i < strBytes.length; i++)
		{
			packetBytes[i + 1 + sizeBytes.length] = strBytes[i];
		}
		
		// データ追加
		dataList.add(packetBytes);
		*
	}

	/******************************
	 * パケット作成
	*******************************
	public String createPacket()
	{
		int dataSize = 0;
	
		// データの長さを追加
		for (int i = 0; i < dataList.size(); i++)
		{
			byte[] bytes = (dataList.get(i));
			dataSize += bytes.length;
		}
		
		String dataSizeStr = "" + dataSize;
		byte[] dataSizeBytes = dataSizeStr.getBytes();
		int packetSizeLength = dataSizeBytes.length; // 「パケットサイズの長さ」を追加
		
		// 「パケットサイズの長さ」(1byte) + 「パケットサイズ」 + 「ヘッダー」(1byte) + 「データサイズ」
		byte packetBytes[] = new byte[1 + packetSizeLength + 1 + dataSize];
	
		int index = 0;
		
		// パケットサイズの長さ
		packetBytes[index] = (byte)packetSizeLength;
		index++;
		
		// パケットサイズ
		for (int i = 0; i < dataSizeBytes.length; i++)
		{
			packetBytes[index] = dataSizeBytes[i];
			index++;
		}
		
		// ヘッダ
		packetBytes[index] = (byte)header.toInt();
		index++;
		
		// データ
		for (int i = 0; i < dataList.size(); i++)
		{
			byte[] bytes = (dataList.get(i));
			for (int j = 0; j < bytes.length; j++)
			{
				packetBytes[index] = (byte)bytes[j];
				index++;
			}
		}
		
		return new String(packetBytes);
	}
}
*/