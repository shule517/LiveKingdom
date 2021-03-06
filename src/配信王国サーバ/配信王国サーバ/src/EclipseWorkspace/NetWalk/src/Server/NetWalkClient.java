package Server;
import java.awt.Desktop;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.net.URI;
import java.net.URLEncoder;
import java.util.Map;

import javax.swing.JOptionPane;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.http.AccessToken;
import twitter4j.http.RequestToken;

import Frame.Frame;
import Lib.Network;
import Lib.PacketAnalyzer;
import Data.Data;
import Data.UserData;

/******************************
 * NetWalkクライアントスレッド
*******************************/
class NetWalkClient extends Thread
{
	/******************************
	 * メンバ変数
	*******************************/
	private Network network = null;
	private String myId = "";
		
	/******************************
	 * コンストラクタ
	*******************************/
	NetWalkClient(Socket socket)
	{
		network = new Network(socket); // 初期化
		
		start(); // スレッド開始
	}
	
	/******************************
	 * パケット処理
	*******************************/
	void processPacket(PacketAnalyzer pa)
	{
		if (pa.header == null)
		{
			Frame.appendDebugText("ヘッダーがnull：");
			return;
		}
		
		switch (pa.header)
		{
			/******************************
			 * ログイン認証
			 * id : ログインID
			 * pw : ログインPW
			*******************************/
			case PacketLoginAuth:
			{
				// 「ログインデータ」を受信
				String id = pa.getStrData(); // ID
				String pw = pa.getStrData(); // PW
				
				// デバッグ表示
				Frame.appendDebugText("PacketLoginAuth ：  id(" + id + ")　pw(" + pw + ")");
				
				// ID重複 & 32文字以下チェック
				if (Data.user.checkID(id) == false && id.length() < 32)
				{
					// IDを登録
					network.setID(id);
					this.myId = id;
					
					// データ追加
					Data.user.add(id, network);
	
					// ログイン結果を送信 (成功)
					network.sendLoginResult(true);
					
					// 周りの人に伝える（自分以外の全員に送る）
					for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
					{
						// 自分以外
						if (myId != user.getKey())
						{
							// 「自分以外」に「自分のデータ」を送る
							user.getValue().network.sendAddCharactor(myId, 750, 900);
						}
					}
	
					// 自分にデータを送る
					for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
					{
						// 自分以外のデータの場合
						if (myId != user.getKey())
						{
							// キャラ追加
							Data.user.get(myId).network.sendAddCharactor(user.getKey(), user.getValue().x, user.getValue().y);
	
							// 配信開始
							if (user.getValue().liveState == LiveState.Live)
							{
								Data.user.get(myId).network.sendLiveStart(user.getKey(), user.getValue().liveTitle, user.getValue().liveDetail);
							}
							// 視聴開始
							else if (user.getValue().liveState == LiveState.Listen)
							{
								Data.user.get(myId).network.sendListenStart(user.getKey(), user.getValue().listenLiveID);
							}
						}
					}
					
					// ホーム同期
					//Data.user.synck(id);
				}
				else
				{
					// ログイン結果を送信 (失敗)
					network.sendLoginResult(false);
				}
			}
			break;
			
			/******************************
			 * チャット
			 * text : チャット内容
			*******************************/
			case PacketChat:
			{
				// 「チャットデータ」を受信
				String chatMessage = pa.getStrData();

				// デバッグ表示
				Frame.appendDebugText("チャット(" + myId + " : " + chatMessage + ")");
				Frame.appendPolicyText("チャット(" + myId + " : " + chatMessage + ")");
				
				// 「チャットデータ」を自分以外の全員に送る
				for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
				{
					// 自分以外
					if (myId != user.getKey())
						user.getValue().network.sendChat(myId, chatMessage);
				}
			}
			break;
			
			/******************************
			 * キャラ移動
			 * x : 移動位置x
			 * y : 移動位置y
			*******************************/
			case PacketMoveCharactor:
			{
				// 「移動先位置データ」を受信
				int x = pa.getIntData();
				int y = pa.getIntData();
				
				// 「移動先位置データ」を代入
				Data.user.get(myId).x = x;
				Data.user.get(myId).y = y;
				
				// 「移動先位置データ」を自分以外の全員に送る
				for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
				{
					// 自分以外
					if (myId != user.getKey())
						user.getValue().network.sendMoveCharactor(myId, x, y);
				}
			}
			break;
			
			/******************************
			 * おっおっ
			*******************************/
			case PacketOxOx:
			{				
				// 「移動先位置データ」を自分以外の全員に送る
				for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
				{
					// 自分以外
					if (myId != user.getKey())
						user.getValue().network.sendOxOx(myId);
				}
			}
			break;
			
			/******************************
			 * 配信開始
			 * title : 配信タイトル
			 * detail : 配信詳細
			*******************************/
			case PacketLiveStart:
			{
				// 「配信データ」を受信
				String title = pa.getStrData();		// タイトル
				String detail = pa.getStrData();	// 詳細
				
				// 「配信データ」を代入
				Data.user.get(myId).liveState = LiveState.Live;
				Data.user.get(myId).liveTitle = title;
				Data.user.get(myId).liveDetail = detail;
				
				// 「配信データ」を全員に送る
				for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
				{
					user.getValue().network.sendLiveStart(myId, title, detail);
				}
				
				// ツイッターにPOSTする
				try {
//					Twitter twitter = loginOAuth();           	//毎回暗証番号を入力
					Twitter twitter = loginOAuth("LiveKingdom");	//初回だけ暗証番号を入力[2010-09-12]

					try {
						twitter.updateStatus(myId + "さんが【" + title + "】「" + detail + "」 配信を始めたよ http://shule517.ddo.jp/NetWalk/thumbnail/" + URLEncoder.encode(myId, "UTF-8") + ".jpg");
					} catch (UnsupportedEncodingException e) {
						twitter.updateStatus(myId + "さんが【" + title + "】「" + detail + "」 配信を始めたよ");
						e.printStackTrace();
					}
//					twitter.updateStatus("リツィートする実験 RT @hishidama 実験", ステータスID);

				} catch (TwitterException e) {
					System.err.println(e.getMessage());
					e.printStackTrace();
				}
			}
			break;
			
			/******************************
			 * 配信終了
			*******************************/
			case PacketLiveStop:
			{
				// 配信終了フラグ代入
				Data.user.get(myId).liveState = LiveState.Nothing;
				
				// 全員に送る
				for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
				{
					user.getValue().network.sendListStop(myId);
				}
			}
			break;
			
			/******************************
			 * 配信用チャット
			 * id : 配信者ID
			 * text : 配信者用チャット内容
			*******************************/
			case PacketLiveChat:
			{
				// 「チャットデータ」を受信
				String LiveID = pa.getStrData();
				String LivechatMessage = pa.getStrData();

				// デバッグ表示
				Frame.appendDebugText("配信用チャット(" + myId + " : " + LivechatMessage + ")");
				Frame.appendPolicyText("配信用チャット(" + myId + " : " + LivechatMessage + ")");
				
				// スレッドへ書き込み
				Data.user.get(LiveID).threadData += myId + " : " + LivechatMessage + "\n";
				
				// 「チャットデータ」を自分以外の全員に送る
				for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
				{
					// 自分以外
					if (myId != user.getKey())
						user.getValue().network.sendLiveChat(myId, LiveID, LivechatMessage);
				}
			}
			break;
			
			/******************************
			* パケット送信：配信視聴
			* id : 視聴する配信者ID
			*******************************/
			case PacketListenStart:
			{
				// 「配信者ID」を受信
				String LiveID = pa.getStrData();

				// デバッグ表示
				Frame.appendDebugText("視聴開始(" + myId + " : " + LiveID + "さんを視聴開始)");

				// 自分に過去スレを送る
				Data.user.get(myId).network.sendLiveChat("", LiveID, Data.user.get(LiveID).threadData);
				
				// 視聴データを追加
				Data.user.get(myId).listenLiveID = LiveID;
				Data.user.get(myId).liveState = LiveState.Listen;
				
				// 「視聴開始パケット」を自分以外の全員に送る
				for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
				{
					// 自分以外
					if (myId != user.getKey())
						user.getValue().network.sendListenStart(myId, LiveID);
				}
			}
			break;
			
			/******************************
			* パケット送信：配信視聴終了
			*******************************/
			case PacketListenStop:
			{
				// デバッグ表示
				Frame.appendDebugText("視聴終了(" + myId + ")");
				
				// 視聴データを追加
				Data.user.get(myId).listenLiveID = "";
				Data.user.get(myId).liveState = LiveState.Nothing;
				
				// 「視聴終了パケット」を自分以外の全員に送る
				for(Map.Entry<String, UserData> user : Data.user.get().entrySet())
				{
					// 自分以外
					if (myId != user.getKey())
						user.getValue().network.sendListenStop(myId);
				}
			}
			break;
		}
	}

	/******************************
	 * メインループ
	*******************************/
	public void run()
	{
		while (network.isAlive)
		{
			// パケット受信
			PacketAnalyzer pa = network.receive();
			
			// パケット処理
			if (pa != null) processPacket(pa);
		}
	}
		
	/******************************
	 * ツイッター
	*******************************/
	private static final String CONSUMER_KEY    = "uRCxf8OSEdWnOlXv9eZw";
	private static final String CONSUMER_SECRET = "drcCsySZYItqZWPE9LP5VX2gfc9skWbuoEbK3RjzKk";
	public Twitter loginOAuth() throws TwitterException {

		Twitter twitter = new TwitterFactory().getOAuthAuthorizedInstance(CONSUMER_KEY, CONSUMER_SECRET);

		getOAuthAccessToken(twitter);

		return twitter;
	}
	AccessToken getOAuthAccessToken(Twitter twitter) throws TwitterException {

		//■リクエストトークンの作成
		RequestToken requestToken = twitter.getOAuthRequestToken();
		String url = requestToken.getAuthorizationURL();
//		System.out.println("AuthorizationURL\t" + url);

		//■ブラウザーでTwitterの認証画面を表示する（ここでTwitterにログインすることにより、暗証番号が表示される）
		Desktop desktop = Desktop.getDesktop();
		try {
			desktop.browse(URI.create(url));
		} catch (IOException e) {
			throw new TwitterException(e);
		}

		//■暗証番号の入力を求めるダイアログ
		String pin = JOptionPane.showInputDialog("暗証番号を入力して下さい");
		if (pin == null) {
			throw new TwitterException("暗証番号の入力がキャンセルされました");
		}
		pin = pin.trim();

		//■アクセストークンの作成（認証）
		try {
			AccessToken accessToken = twitter.getOAuthAccessToken(requestToken, pin);
//			System.out.println("AccessToken\t" + accessToken);
			return accessToken;

		} catch (TwitterException e) {
//			System.out.println(e.getStatusCode()); //拒否されると401
			throw e;
		}
	}
	public Twitter loginOAuth(String name) throws TwitterException {
		Twitter twitter;

		AccessToken accessToken = loadAccessToken(name);
		if (accessToken != null) {
			// 保存されていたアクセストークンを使う
			twitter = new TwitterFactory().getOAuthAuthorizedInstance(CONSUMER_KEY, CONSUMER_SECRET, accessToken);
		} else {
			// 認証して暗証番号を入力してもらい、アクセストークンを保存する
			twitter = new TwitterFactory().getOAuthAuthorizedInstance(CONSUMER_KEY, CONSUMER_SECRET);
			accessToken = getOAuthAccessToken(twitter);
			storeAccessToken(name, accessToken);
		}

		return twitter;
	}
	// アクセストークンをファイルから読み込む
	AccessToken loadAccessToken(String name) {
		File f = createAccessTokenFileName(name);

		ObjectInputStream is = null;
		try {
			is = new ObjectInputStream(new FileInputStream(f));
			AccessToken accessToken = (AccessToken) is.readObject();
			return accessToken;

		} catch (IOException e) {
			return null; //ファイルが読めない（存在しない）場合はnullを返す

		} catch (Exception e) {
			e.printStackTrace();
			return null;

		} finally {
			if (is != null) {
				try { is.close(); } catch (IOException e) { e.printStackTrace(); }
			}
		}
	}
	// アクセストークンをファイルに保存する
	void storeAccessToken(String name, AccessToken accessToken) {
		File f = createAccessTokenFileName(name);
		File d = f.getParentFile();
		if (!d.exists()) {
			d.mkdirs();
		}

		ObjectOutputStream os = null;
		try {
			os = new ObjectOutputStream(new FileOutputStream(f));
			os.writeObject(accessToken);

		} catch (IOException e) {
			e.printStackTrace();

		} finally {
			if (os != null) {
				try { os.close(); } catch (IOException e) { e.printStackTrace(); }
			}
		}
	}
	// アクセストークンを保存するファイル名を生成する
	File createAccessTokenFileName(String name) {
		String s = System.getProperty("user.home") + "/.twitter/client/sample/accessToken_" + name + ".dat";
		return new File(s);
	}
}
