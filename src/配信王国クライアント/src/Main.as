package 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import LBB.Chat;
	import net.hires.debug.Stats;
	import shule.LoginScreen;
	import shule.world.World;
	import shule.net.ServerConnect;
	import shule.net.NetWork;
	import shule.net.Header;
	import shule.net.NetWorkEvent;
	import LBB.LiveScreen;
	/**
	 * ...
	 * @author shule
	 */
	[SWF(backgroundColor = 0xDCECFF)]
	public class Main extends Sprite 
	{
		static public var myID:String = "";
		static public var mainStage:Stage = null;
		static public var liveScreen:LiveScreen = null;
		static public var world:World = null;
		//static public var mainButton:mainbutton = null;
		private var login:LoginScreen = null;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			// mainStage
			mainStage = stage;

			// サーバ接続
			ServerConnect.connect("shule517.ddo.jp", 2236, 843);
			//ServerConnect.connect("192.168.0.3", 2236, 843);
			
			// ログイン画面表示
			login = new LoginScreen(stage);
			addChild(login);
			
			// ログイン認証イベント
			NetWork.addEventListener(Header.PacketLoginResult, onLoginResult);
		}
		
		// ログイン認証された
		public function onLoginResult(event:NetWorkEvent):void
		{
			if (event.result)
			{
				trace("ログイン成功");
				
				login.loginTimer.stop();
				
				// ID取得
				myID = login.getID();
				
				// ログイン画面を消す
				removeChild(login);
				
				stage.align = "left";
				stage.scaleMode = "noScale";
			
				// メインボタン初期化
				//mainButton = new mainbutton();

				// Map表示
				world = new World(stage, myID);
				addChild(world);
				addChild(new Chat());
				liveScreen = new LiveScreen();
				addChild(liveScreen);
				addChildAt(liveScreen.Tittle, getChildIndex(liveScreen) - 1);
				//addChild(new LiveScreen());
				//addChild(mainButton);

				// ステータス
				//addChild(new Stats());
			}
			else
			{
				trace("ログインＥｒｒｏｒ ： ＩＤが重複しています。");
				login.loginTimer.stop();
				login.setReadOnly(false, "<font size = \"20\"><b>同じ名前ノ人ガイマス</b></font>");
			}
		}
	}
}
