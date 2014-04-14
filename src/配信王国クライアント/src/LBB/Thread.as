package LBB
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.*;
	import shule.net.NetWork;
	import shule.net.Header;
	import shule.net.NetWorkEvent;
	import shule.world.World;
	
	/**
	 * ...
	 * @author LBB
	 */
	public class Thread extends Sprite
	{
		private var thread_format:TextFormat;
		public var output_thread:TextField;
		public var input_thread:TextField;
		
		static public var liveID:String = "";
		
		public function Thread(Down_mc:MovieClip):void
		{
			setThread(Down_mc);
			
			// Networkイベント
			NetWork.addEventListener(Header.PacketLiveChat, onLiveChat);
		}
		
		// 配信用チャット表示
		public function onLiveChat(event:NetWorkEvent):void
		{
			// 同じ配信見てたらスレッドに表示
			if (liveID == event.liveID)
			{
				// 過去スレ
				if (event.id == "")
				{
					output_thread.appendText(event.message);
				}
				// 通常
				else
				{
					output_thread.appendText(event.id + " : " + event.message + "\n");
				}
				output_thread.scrollV = output_thread.maxScrollV;
			}
		}
		
		// 視聴している配信IDを受け取る
		public function setLiveID(id:String):void
		{
			liveID = id;
			
			// スレッド初期化
			output_thread.text = "";
		}
		
		private function setThread(Down_mc:MovieClip):void
		{
			thread_format = new TextFormat();
			output_thread = new TextField();
			input_thread = new TextField();
			
			thread_format.leading = 1.5;
			
			//output_thread.background = true;
			//output_thread.backgroundColor = 0x000000;
			output_thread.border = true;
			output_thread.wordWrap = true;
			output_thread.textColor = 0xffffff;
			output_thread.filters = [new GlowFilter(0, 1, 2, 2, 6)];
			output_thread.defaultTextFormat = thread_format;
			//output_thread.alpha = 0.7;
			
			Down_mc.addChild(output_thread);
			
			input_thread.type = TextFieldType.INPUT;
			input_thread.background = true;
			input_thread.border = true;
			input_thread.wordWrap = true;
			
			Down_mc.addChild(input_thread);
			
			input_thread.addEventListener(KeyboardEvent.KEY_DOWN, Enter);
		}
		
		public function setSize(Down_bg:Sprite):void
		{
			output_thread.width = Down_bg.width;
			output_thread.height = Down_bg.height - 20;
			
			input_thread.y = output_thread.height;
			input_thread.width = Down_bg.width;
			input_thread.height = 20;
		}
		
		// スレッド書き込みイベント
		private function Enter(e:KeyboardEvent):void
		{
			if ((e.keyCode == Keyboard.ENTER) && (input_thread.text.length > 0))
			{
				// サーバーへスレッド書き込み送信
				NetWork.sendLiveChat(liveID, input_thread.text);

				// チャットバルーン表示
				World.myChara.showLiveChat(liveID, input_thread.text);
				
				// スレッドへ表示
				output_thread.appendText(Main.myID + " : " + input_thread.text + "\n");
				input_thread.text = "";
				output_thread.scrollV = output_thread.maxScrollV;
			}
		}
	}
}