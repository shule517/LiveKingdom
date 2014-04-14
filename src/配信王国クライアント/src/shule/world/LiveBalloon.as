package shule.world 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import shule.world.World;
	import flash.utils.escapeMultiByte;
	import flash.events.IOErrorEvent;
	/**
	 * ...
	 * @author shule
	 */
	public class LiveBalloon extends Sprite
	{
		private var thumbnail:Loader = new Loader();
		private var live:TextField = new TextField();
		private var back:Sprite = new Sprite();
		private var id:String = "";
		
		public function LiveBalloon(id:String) 
		{
			this.id = id;
			
			// 消しておく
			visible = false;
			
			// chat初期化
			live.x = - 150 / 2;
			live.multiline = true;
			live.textColor = 0xFFFFFF;
			live.wordWrap = true;
			live.selectable = false;
			live.autoSize = "center";
			live.width = 150;
			
			addChild(back);
			addChild(live);
			addChild(thumbnail);
		}
		
		/******************************
		* バルーンを表示
		*******************************/
		public function show(title:String, detail:String):void
		{
			// 表示
			visible = true;
			
			// サムネをロード
			var url:String = "http://shule517.ddo.jp/NetWalk/thumbnail/" + escapeMultiByte(id) + ".jpg";
			thumbnail.load(new URLRequest(url));
			
			var info:LoaderInfo = thumbnail.contentLoaderInfo;
			info.addEventListener(IOErrorEvent.IO_ERROR, error);
			
			thumbnail.x = mouseX - live.width / 2 - 5;
			thumbnail.y = mouseY + 50;
			thumbnail.scaleX = 0.5;
			thumbnail.scaleY = 0.5;
			
			// テキスト更新
			live.htmlText = "<b><font color='#ff1493'>" + title + "</font></b>\n" + detail;
			live.x = mouseX - live.width / 2 - 10;
			live.y = mouseY + 50 + 190/2 - 5 + 30;
			live.width = 150;
			//live.x = -(live.textWidth + 10) / 2;
			
			// 背景更新
			back.graphics.clear();
			back.graphics.beginFill(0x000000);
			back.graphics.drawRoundRect(live.x - 5, live.y - 2 - 190/2 - 30, 150 + 25, live.height + 4 + 90 + 40, 15, 15);
			//back.graphics.drawRoundRect(live.x - 5, live.y - 2 - 190/2, live.textWidth + 15, live.height + 4 + 190/2, 15, 15);
			back.graphics.endFill();
			back.alpha = 0.85;
			
			// 最前列表示
			//World.balloon.setChildIndex(this, World.balloon.numChildren - 1);
			
			/*
			// 非表示タイマー
			timer.stop();
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			*/
		}
		
		private function error(event:Event):void
		{
			var url:String = "http://shule517.ddo.jp/NetWalk/data/Noimage.png";
			thumbnail.load(new URLRequest(url));
		}
	}
}
