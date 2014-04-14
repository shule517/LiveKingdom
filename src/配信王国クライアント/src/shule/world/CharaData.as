package shule.world 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import LBB.LiveScreen;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.tweens.ITween;
	import org.libspark.betweenas3.easing.Cubic;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.getTimer;
	import flash.events.MouseEvent;
	import shule.net.NetWork;
	import org.libspark.betweenas3.easing.*;
	import flash.events.TimerEvent;
	
	
	/**
	 * ...
	 * @author shule
	 */
	public class CharaData
	{
		/******************************
		* 変数
		*******************************/
		public var id:String = "";
		public var x:int = 0;
		public var y:int = 0;
		public var dir:int = 0;
		public var tweenMove:ITween = BetweenAS3.tween(null, null);
		public var tweenOxOx:ITween = BetweenAS3.tween(null, null);
		public var bmpChat:BitmapData = new BitmapData(416, 250, true, 0xffffff);
		public var bmpLiveChat:BitmapData = new BitmapData(416, 250, true, 0xffffff);
		
		public var bmpName:BitmapData = new BitmapData(416, 50, true, 0xffffff);
		public var spriteName:Sprite = new Sprite();
		public var chatY:int = 0;
		
		public var liveChatTime:int = -10000;
		public var liveChatX:int = 0;
		public var liveChatY:int = 0;
		
		public var chatTime:int = -10000;
		public var oxoxTime:int = -10000;
		public var isLive:Boolean = false;
		private var chatTween:ITween = BetweenAS3.tween(null, null);
		public var liveID:String = "";
		
		private var title:String = "";
		private var detail:String = "";
		
		public var spriteLive:Sprite = new Sprite();
		
		private var liveBallon:LiveBalloon = null;
		
		[Embed(source='/data/stream.png')]
		private var imageStream:Class;
		private var bmpStream:Bitmap = new imageStream;
		
		/******************************
		* コンストラクタ
		*******************************/
		public function CharaData(id:String) 
		{
			// 代入
			this.id = id;
			
			// 初期化
			liveBallon = new LiveBalloon(id);
			
			// 名前作成
			showName();
		}
		
		/******************************
		* デストラクタ
		*******************************/
		public function close():void
		{
			// 含まれていたら削除
			if (Main.world.contains(spriteLive))
				Main.world.removeChild(spriteLive);
		}
		
		/******************************
		* キャラ移動
		*******************************/
		public function move(moveX:int, moveY:int):void
		{
			// 移動
			var dx:int = moveX - x;
			var dy:int = moveY - y;
			if (dy > dx)
			{
				if (dy > dx * -1)
				{
					dir = 0;
				}
				else
				{
					dir = 2;
				}
			}
			else
			{
				if (dy > dx * -1)
				{
					dir = 3;
				}
				else
				{
					dir = 1;
				}			
			}
			
			if (tweenMove.isPlaying)
			{
				tweenMove.stop();
			}
			tweenMove = BetweenAS3.parallel(
				BetweenAS3.tween(this, { x: moveX }, null, 1, Cubic.easeInOut),
				BetweenAS3.tween(this, { y: moveY }, null, 1, Cubic.easeInOut)
			);
			tweenMove.play();
		}
		
		/******************************
		* チャット
		*******************************/
		public function showChat(message:String):void
		{
			var chat:TextField = new TextField();
			chat.text = message.slice(0, 35);
			
			// chat初期化
			//chat.multiline = true;
			chat.textColor = 0x000000;
			//chat.textColor = 0xFFFFFF;
			//chat.wordWrap = true;
			chat.selectable = false;
			chat.autoSize = "center";
			
			chat.x = 200 - chat.textWidth / 2;
			chat.y = 2;
			
			// 背景更新
			var back:Sprite = new Sprite();
			back.graphics.clear();
			//back.graphics.beginFill(0x000000);
			back.graphics.beginFill(0xffffff);
			back.graphics.drawRoundRect(chat.x - 10, chat.y - 2, chat.textWidth + 20, chat.height + 4, 15, 15);
			back.graphics.drawTriangles(Vector.<Number>([chat.x + chat.textWidth / 2 - 11, 10, chat.x + chat.textWidth / 2 + 11, 10, chat.x + chat.textWidth / 2, 30]));
			back.graphics.endFill();
			back.alpha = 0.85;
			back.addChild(chat);
			
			bmpChat.fillRect(bmpChat.rect, 0xffffff);
			bmpChat.draw(back);
			
			// 影
			var shadow:BitmapData = new BitmapData(bmpChat.width, bmpChat.height, true, 0xffffff);
			shadow.applyFilter(bmpChat, bmpChat.rect, new Point(), new DropShadowFilter(20, 15, 0, 0.5, 4, 4, 1, 1, false, false, true));
			var matrix:Matrix = new Matrix();
			matrix.scale(0.8, 0.7);
			matrix.rotate(0.4);
			//matrix.tx = 100;
			//matrix.ty = -90;
			matrix.tx = 70;
			matrix.ty = -50;
			bmpChat.draw(shadow, matrix, null, null, null, true);
			
			bmpChat.draw(back);
			
			// チャットトゥイーン
			if (chatTween.isPlaying)
				chatTween.stop();
			chatY = 0;
			chatTween = BetweenAS3.parallel(
				BetweenAS3.tween(this, { chatY: 15 }, null, 0.5)
			);
			chatTween.play();
			
			// 表示時間
			chatTime = getTimer();
		}
		
		/******************************
		* 配信用チャット
		*******************************/
		public function showLiveChat(liveID:String, message:String):void
		{
			// chat初期化
			var chat:TextField = new TextField();
			//chat.multiline = true;
			chat.textColor = 0x000000;
			//chat.textColor = 0xFFFFFF;
			//chat.wordWrap = true;
			chat.selectable = false;
			chat.autoSize = "center";
			
			chat.x = 200 - chat.textWidth / 2;
			chat.y = 2;
			
			// フォーマット
			var fmt:TextFormat = new TextFormat();
			fmt.bold = true;
			fmt.color = 0x0000ff;

			var fmt2:TextFormat = new TextFormat();
			fmt2.bold = false;
			fmt2.color = 0x767676;

			var text:String = String.fromCharCode(0x40) + liveID;
			var text2:String = " by " + id;
			var start:int = (text + " " + message).length;
			chat.text = text + " " + message + text2;
			chat.setTextFormat(fmt, 0, text.length);
			chat.setTextFormat(fmt2, start, start + text2.length);
			
			// 背景更新
			var back:Sprite = new Sprite();
			back.graphics.clear();
			//back.graphics.beginFill(0x000000);
			back.graphics.beginFill(0xffffff);
			back.graphics.drawRoundRect(chat.x - 10, chat.y - 2, chat.textWidth + 20, chat.height + 4, 15, 15);
			back.graphics.drawTriangles(Vector.<Number>([chat.x + chat.textWidth / 2 - 11, 10, chat.x + chat.textWidth / 2 + 11, 10, chat.x + chat.textWidth / 2, 30]));
			back.graphics.endFill();
			back.alpha = 0.85;
			back.addChild(chat);
			
			bmpLiveChat.fillRect(bmpChat.rect, 0xffffff);
			bmpLiveChat.draw(back);
			bmpLiveChat.applyFilter(bmpLiveChat, bmpLiveChat.rect, new Point(), new GlowFilter(0, 1, 6, 6, 4));
			
			// 影
			var shadow:BitmapData = new BitmapData(bmpLiveChat.width, bmpLiveChat.height, true, 0xffffff);
			shadow.applyFilter(bmpLiveChat, bmpLiveChat.rect, new Point(), new DropShadowFilter(20, 15, 0, 0.5, 4, 4, 1, 1, false, false, true));
			var matrix:Matrix = new Matrix();
			matrix.scale(0.8, 0.7);
			matrix.rotate(0.4);
			//matrix.tx = 100;
			//matrix.ty = -90;
			matrix.tx = 70;
			matrix.ty = -50;
			bmpLiveChat.draw(shadow, matrix, null, null, null, true);
			
			bmpLiveChat.draw(back);
			
			// チャットトゥイーン
			if (chatTween.isPlaying)
				chatTween.stop();
			
			//var dx:int = Network.charaList[liveID].x - World.myChara.x;
			//var dy:int = Network.charaList[liveID].y - World.myChara.y;
			
			//　初期位置
			liveChatX = x;
			liveChatY = y;
			
			if (liveID == Main.myID)
			{
				chatTween = BetweenAS3.serial(
					BetweenAS3.parallel(
						BetweenAS3.tween(this, { liveChatX: x }, null, 0.5),
						BetweenAS3.tween(this, { liveChatY: y - 15 }, null, 0.5)
						//BetweenAS3.tween(this, { liveChatX: World.myChara.x }, null, 0.5),
						//BetweenAS3.tween(this, { liveChatY: World.myChara.y - 15 }, null, 0.5)
					),
					BetweenAS3.parallel(
						BetweenAS3.tween(this, { liveChatX: World.myChara.x }, null, 1),
						BetweenAS3.tween(this, { liveChatY: World.myChara.y - 50 }, null, 1)
					)
				);
			}
			else
			{
				if (!Network.charaList[liveID])
					return;

				chatTween = BetweenAS3.serial(
					BetweenAS3.parallel(
						BetweenAS3.tween(this, { liveChatX: x }, null, 0.5),
						BetweenAS3.tween(this, { liveChatY: y - 15 }, null, 0.5)
						//BetweenAS3.tween(this, { liveChatX: World.myChara.x }, null, 0.5),
						//BetweenAS3.tween(this, { liveChatY: World.myChara.y - 15 }, null, 0.5)
					),
					BetweenAS3.parallel(
						BetweenAS3.tween(this, { liveChatX: Network.charaList[liveID].x }, null, 1),
						BetweenAS3.tween(this, { liveChatY: Network.charaList[liveID].y - 50 }, null, 1)
					)

				);
			}
			chatTween.play();
			
			// 表示時間
			liveChatTime = getTimer();
		}
		
		/******************************
		* 名前
		*******************************/
		public function showName():void
		{
			/*
			drawName( 1,  0, 0xFFFFFF);
			drawName(-1,  0, 0xFFFFFF);
			drawName( 0,  1, 0xFFFFFF);
			drawName( 0, -1, 0xFFFFFF);
			drawName( 0,  0, 0xFF0000);
			
			bmpName.draw(spriteName);
			*/
			var name:TextField = new TextField();
			name.text = id;
			//name.textColor = 0xff0000;
			name.filters = [new GlowFilter(0xffffff, 1, 2, 2, 4)];
			//name.x = 200 - name.textWidth / 2;
			//name.y = 25;
			
			var format:TextFormat = new TextFormat();
			format.color = 0xff0000;	// 文字色
			format.bold = true;		// 太字（デフォルトfalse）
			name.setTextFormat(format);

			var matrix:Matrix = new Matrix();
			matrix.tx = 200 - name.textWidth / 2;
			//matrix.ty = 45;
			bmpName.draw(name, matrix);
		}
		
		/******************************
		* 配信開始
		*******************************/
		public function startLive(title:String, detail:String):void
		{
			// 代入
			this.title = title;
			this.detail = detail;
			
			spriteLive.visible = false;
			
			bmpStream.x = -15;
			bmpStream.y = -55;
			spriteLive.addChild(bmpStream);
			
			spriteLive.buttonMode = true;
			Main.world.addChild(spriteLive);
			
			Main.world.addChild(liveBallon);
			
			spriteLive.addEventListener(MouseEvent.CLICK, onClick);
			spriteLive.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			spriteLive.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			isLive = true;
		}
		
		// 配信者クリック
		private function onClick(event:Event):void
		{
			if (World.myChara.isLive == false)
			{
				// 視聴開始
				NetWork.sendListenStart(id);
				Main.liveScreen.play(id);
				World.myChara.liveID = id;
			}
		}

		// 配信者マウスオーバー
		private function onMouseMove(event:Event):void
		{
			liveBallon.show(title, detail);
		}

		// マウスオーバーからはずれた
		private function onMouseOut(event:Event):void
		{
			if (liveBallon != null)
				liveBallon.visible = false;
		}
		
		public function showOxOx():void
		{
			// 表示時間
			oxoxTime = getTimer();
		}
		
		// おっおっ
		private var startY:Number = 0;
		public function playOxOx():void
		{
			startY = y;

			if (tweenOxOx.isPlaying || tweenMove.isPlaying)
			{
				return;
				tweenOxOx.stop();
			}
			
			// チャットルバルーン表示
			//showChat("（ ＾ω＾）おっおっ");
			showOxOx();

			tweenOxOx = BetweenAS3.serial(
				BetweenAS3.tween(this, { y: y - 100 }, null, 0.1, Quart.easeOut),
				BetweenAS3.tween(this, { y: y }, null, 0.1, Quart.easeOut),
				BetweenAS3.tween(this, { y: y - 100 }, null, 0.1, Quart.easeOut),
				BetweenAS3.tween(this, { y: y }, null, 0.1, Quart.easeOut)
			);
			tweenOxOx.play();
			
			/*
			var timer:Timer = new Timer(16, 1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			*/
		}

		/*
		private var dy:Number = 10;
		private var py:Number = 0;
		private function onTimer(event:Event):void
		{
			if (py < 0) dy = 10;

			py -= dy;
			dy -= 2;
			y = startY + py;
		}
		*/
		
		/******************************
		* 配信終了
		*******************************/
		public function stopLive():void
		{
			// 含まれているなら削除
			liveBallon = null;
			
			if (Main.world.contains(spriteLive))
				Main.world.removeChild(spriteLive);
			
			isLive = false;
		}
	}
}
