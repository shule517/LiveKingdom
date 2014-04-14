package shule.world 
{
	import adobe.utils.CustomActions;
	import com.adobe.images.BitString;
	import com.quasimondo.geom.ColorMatrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import LBB.Thread;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Cubic;
	import org.libspark.betweenas3.tweens.ITween;
	import flash.events.ContextMenuEvent;
	import shule.net.NetWork;
	import org.libspark.betweenas3.easing.*;
	import flash.filters.DropShadowFilter;
	import flash.utils.getTimer;
	import org.libspark.betweenas3.BetweenAS3;
	
	/**
	 * ...
	 * @author shule
	 */
	public class World extends Sprite
	{
		/******************************
		* 画像
		*******************************/
		// Map
		[Embed(source='/data/map.png')]
		private var imageMap:Class;
		private var bmpMap:Bitmap = new imageMap;
		private var bmpdataMap:BitmapData = new BitmapData(2150, 2650, true, 0xffffff);
		
		// 雲
		[Embed(source='/data/雲（ニコ）.png')]
		private var imageCloud:Class;
		private var bmpCloud:Bitmap = new imageCloud;
		private var bmpdataCloud:BitmapData = new BitmapData(600, 600, true, 0xffffff);
		private var cloudPos:Point = new Point(1000, 1000);
		
		// おっおっ
		[Embed(source='/data/おっおっ.gif')]
		private var imageOxOx:Class;
		private var bmpOxOx:Bitmap = new imageOxOx;

				// キャラ
		[Embed(source='/data/chara2D.png')]
		private var imageChara2D:Class;
		private var bmpChara2D:Bitmap = new imageChara2D;

		[Embed(source='/data/chara2U.png')]
		private var imageChara2U:Class;
		private var bmpChara2U:Bitmap = new imageChara2U;
		
		[Embed(source='/data/chara2L.png')]
		private var imageChara2L:Class;
		private var bmpChara2L:Bitmap = new imageChara2L;
		
		[Embed(source='/data/chara2R.png')]
		private var imageChara2R:Class;
		private var bmpChara2R:Bitmap = new imageChara2R;

		// オーラ
		[Embed(source='/data/オーラ前.png')]
		private var imageAuraForth:Class;
		private var bmpAuraForth:Bitmap = new imageAuraForth;
		private var bmpdataAuraForth:BitmapData = new BitmapData(120, 120, true, 0xffffff);
		
		[Embed(source='/data/オーラ後.png')]
		private var imageAuraBack:Class;
		private var bmpAuraBack:Bitmap = new imageAuraBack;
		private var bmpdataAuraBack:BitmapData = new BitmapData(120, 120, true, 0xffffff);
				
		// 滝
		[Embed(source='/data/water1.png')]
		private var imageWater1:Class;
		private var bmpWater1:Bitmap = new imageWater1;

		[Embed(source='/data/water2.png')]
		private var imageWater2:Class;
		private var bmpWater2:Bitmap = new imageWater2;

		[Embed(source='/data/water3.png')]
		private var imageWater3:Class;
		private var bmpWater3:Bitmap = new imageWater3;

		[Embed(source='/data/water4.png')]
		private var imageWater4:Class;
		private var bmpWater4:Bitmap = new imageWater4;

		// 配信画像
		[Embed(source='/data/stream.png')]
		private var imageStream:Class;
		private var bmpStream:Bitmap = new imageStream;
		private var bmpdataStream:BitmapData = new BitmapData(65, 75, true, 0xffffff);
		
		// Water画像リスト
		private var imageWater:Vector.<BitmapData> = new Vector.<BitmapData>();

		// Charar画像リスト
		private var imageChara:Vector.<BitmapData> = new Vector.<BitmapData>();

		// 描画BitmapData
		private var buffer:BitmapData;
		private var screen:Bitmap;
		
		/******************************
		* 変数
		*******************************/
		// MainのStage
		private var mainStage:Stage;
		
		// キャラ位置
		//private var CharaPos:Point = new Point(1220, 600);
		static public var myChara:CharaData;
		
		// 画面位置
		private var pos:Point = new Point(1220, 600);
		private var moveTween:ITween = BetweenAS3.tween(null, null);
		private var scaleTween:ITween = BetweenAS3.tween(null, null);
		public var scale:Number = 1;
		//public var scale:Number = 0.4;
		
		// 弾リスト
		private var bulletList:Vector.<Point> = new Vector.<Point>();
		
		// 滝位置
		private const waterPos:Point = new Point(1090, 490);
		
		// 見渡しモード
		private var OverLookMove:Boolean = false;
		
		// データ
		private var charaList:Dictionary = new Dictionary();

		// 通信
		private var network:Network = new Network(charaList);
		
		// 使いまわし
		private var mapRect:Rectangle = new Rectangle();
		private const zeroPoint:Point = new Point(0, 0);
		private var charaPoint:Point = new Point(0, 0);
		
		// アニメカウント
		private var animeCount:Number = 0;
		
		// 滝から落ちるtween
		private var tweenFall:ITween = BetweenAS3.tween(null, null);
		
		/******************************
		* コンストラクタ
		*******************************/
		public function World(mainStage:Stage, myID:String) 
		{
			// 代入
			this.mainStage = mainStage;
			myChara = new CharaData(myID);
			
			// キャラ初期化
			myChara.x = 1220;
			myChara.y = 600;
			//myChara.chat("ああああああああああああああああああいいいいいいいいいいいいいいいいいい");
		
			// 最大値でbuffer作成
			//buffer = new BitmapData(480, 360, false, 0xffffff);
			buffer = new BitmapData(mainStage.fullScreenWidth, mainStage.fullScreenHeight, false, 0xffffff);
			screen = new Bitmap()

			// 画像作成
			createScaleBmp();
			
			// screenを適応
			addChild(screen);
			
			// ダブルクリック可能
			doubleClickEnabled = true;

			// イベント
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mainStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			/*
			BetweenAS3.parallel(
				BetweenAS3.tween(this, { scale: 1 }, null, 1.5, Cubic.easeInOut)
			).play();
						
			// 移動
			*/
			
			/*
			BetweenAS3.parallel(
				BetweenAS3.tween(pos, { y: 1550 }, null, 4, Bounce.easeOut),
				BetweenAS3.tween(myChara, { y: 1550 }, null, 4, Bounce.easeOut)
				/*
				BetweenAS3.tween(pos, { y: 1550 }, null, 4, Cubic.easeInOut),
				BetweenAS3.tween(myChara, { y: 1550 }, null, 4, Cubic.easeInOut)
				*
			).play();
			
			
			BetweenAS3.parallel(
				BetweenAS3.serial(
					BetweenAS3.tween(pos, { y: 1450 }, null, 2, Quint.easeIn),
					BetweenAS3.tween(pos, { y: 1550 }, null, 3, Elastic.easeOut)
				),
				BetweenAS3.serial(
					BetweenAS3.tween(myChara, { y: 1450 }, null, 2, Quint.easeIn),
					BetweenAS3.tween(myChara, { y: 1550 }, null, 3, Elastic.easeOut)
				)
			).play();
			
			/*
			BetweenAS3.parallel(
				BetweenAS3.serial(
					BetweenAS3.tween(pos, { y: 1450 }, null, 4, Quint.easeInOut),
					BetweenAS3.tween(pos, { y: 1550 }, null, 3, Elastic.easeOut)
				),
				BetweenAS3.serial(
					BetweenAS3.tween(myChara, { y: 1450 }, null, 4, Quint.easeInOut),
					BetweenAS3.tween(myChara, { y: 1550 }, null, 3, Elastic.easeOut)
				)
			).play();
			
			
			/*
			BetweenAS3.parallel(
				BetweenAS3.serial(
					BetweenAS3.tween(pos, { y: 1450 }, null, 3, Quart.easeIn),
					BetweenAS3.slice(BetweenAS3.tween(pos, { y: 1550 }, null, 3, Elastic.easeOut), 0, 3)
				),
				BetweenAS3.serial(
					BetweenAS3.tween(myChara, { y: 1450 }, null, 3, Quart.easeIn),
					BetweenAS3.slice(BetweenAS3.tween(myChara, { y: 1550 }, null, 3, Elastic.easeOut), 0, 3)
				)
			).play();
			
			/*
			// 縮小
			scaleTween = BetweenAS3.serial(
				BetweenAS3.tween(this, { scale: 0.3 }, null, 3, null),
				BetweenAS3.tween(this, { scale: 1 }, null, 3, Bounce.easeOut)
			);
			scaleTween.play();
			
			
			// 滝から落ちる
			 BetweenAS3.serial(
				BetweenAS3.tween(pos, { x: 1220 }, null, 3, Bounce.easeOut),
				BetweenAS3.parallel(
					BetweenAS3.tween(pos, { y: 1550 }, null, 3, Bounce.easeOut),
					BetweenAS3.tween(myChara, { y: 1550 }, null, 3, Bounce.easeOut)
				)
			).play();
			
			/*
			// 縮小
			scaleTween = BetweenAS3.serial(
				BetweenAS3.tween(null, null, null, 6, null),
				BetweenAS3.tween(this, { scale: 1 }, null, 0.5, null)
			//	BetweenAS3.tween(this, { scale: 1 }, null, 4, null),
			//	BetweenAS3.tween(this, { scale: 1 }, null, 0.5, Bounce.easeOut)
			);
			scaleTween.play();
			*/

			//pos.y = 1550;
			
			// 滝から落ちる
			tweenFall = BetweenAS3.serial(
				BetweenAS3.tween(this, { alpha: 1 }, null, 1),
				BetweenAS3.parallel(
					BetweenAS3.tween(pos, { y: 1550 }, null, 3, Bounce.easeOut),
					BetweenAS3.tween(myChara, { y: 1550 }, null, 3, Bounce.easeOut)
				)
			);
			tweenFall.play();
		}
		
		private var amplitude:Number = 0;
		
		/******************************
		* 描画イベント
		*******************************/
		private function onEnterFrame(event:Event):void
		{
			// 拡大用Bitmap作成
			if (scaleTween.isPlaying)
			{
				createScaleBmp()
			}
			
			// スクリーン削除
			buffer.fillRect(new Rectangle(0, 0, mainStage.stageWidth, mainStage.stageHeight), 0xDCECFF);

			// 雲描画
			amplitude += 0.01;
            cloudPos.y = 1100 + 30 * Math.sin(amplitude);
			buffer.copyPixels(bmpdataCloud, bmpdataCloud.rect, new Point((cloudPos.x - pos.x) * scale + (mainStage.stageWidth / 2) - 1000 * scale, (cloudPos.y - pos.y) * scale + (mainStage.stageHeight / 2)));
			
			// 背景描画
			mapRect.x = pos.x * scale - mainStage.stageWidth / 2;
			mapRect.y = pos.y * scale - mainStage.stageHeight / 2;
			mapRect.width = mainStage.stageWidth;
			mapRect.height = mainStage.stageHeight;
			buffer.copyPixels(bmpdataMap, mapRect, zeroPoint);
			
			// キャラソート
			var sortList:Vector.<CharaData> = new Vector.<CharaData>();
			for each(var chara:CharaData in charaList)
			{
				var posx:int = (chara.x - pos.x) * scale + (mainStage.stageWidth / 2) + 100;
				var posy:int = (chara.y - pos.y) * scale + (mainStage.stageHeight / 2) + 100;

				// 範囲内なら追加
				if (0 < posx && posx < mainStage.stageWidth + 200 &&
				0 < posy && posy < mainStage.stageHeight + 200)
					sortList.push(chara);
			}
			sortList.push(myChara);
			sortList.sort(sortFunc);

			// キャラ描画
			var leng:int = sortList.length;
			for (var i:int = 0; i < leng; i++)
			{
				var x:int = (sortList[i].x - pos.x) * scale + (mainStage.stageWidth / 2) - (bmpChara2D.bitmapData.width * scale / 2);
				var y:int = (sortList[i].y - pos.y) * scale + (mainStage.stageHeight / 2) - (bmpChara2D.bitmapData.height * scale / 2);
				
				if (Thread.liveID != "" && Thread.liveID == sortList[i].liveID)
				{
					// オーラ後ろ
					buffer.copyPixels(bmpdataAuraBack, bmpdataAuraBack.rect, new Point(x - 4*scale, y - 12*scale));
				}
				
				// キャラ
				buffer.copyPixels(imageChara[sortList[i].dir], imageChara[sortList[i].dir].rect, new Point(x, y));
				
				if (Thread.liveID != "" && Thread.liveID == sortList[i].liveID)
				{
					// オーラ前
					buffer.copyPixels(bmpdataAuraForth, bmpdataAuraForth.rect, new Point(x - 4 * scale, y - 12 * scale));
				}
				
				if (sortList[i].isLive)
				{
					sortList[i].spriteLive.scaleX = scale;
					sortList[i].spriteLive.scaleY = scale;
					sortList[i].spriteLive.visible = true;
					sortList[i].spriteLive.x = x;
					sortList[i].spriteLive.y = y;
					// buffer.copyPixels(bmpdataStream, bmpdataStream.rect, new Point(x, y - bmpdataStream.rect.width / 2 * scale));
				}
			}
			
			/*
			// 弾描画
			leng = bulletList.length;
			for (i = 0; i < leng; i++)
			{
				x = (bulletList[i].x - pos.x) * scale + (mainStage.stageWidth / 2) - (bmpChara2D.bitmapData.width * scale / 2);
				y = (bulletList[i].y - pos.y) * scale + (mainStage.stageHeight / 2) - (bmpChara2D.bitmapData.height * scale / 2);
				buffer.copyPixels(imageChara[0], imageChara[0].rect, new Point(x, y));
			}
			*/

			// 滝
			animeCount += 0.2;
			var num:int = int(animeCount);
			buffer.copyPixels(imageWater[num % 4], bmpWater1.bitmapData.rect, new Point((waterPos.x - pos.x) * scale + (mainStage.stageWidth / 2) - (bmpChara2D.bitmapData.width * scale / 2), (waterPos.y - pos.y) * scale + (mainStage.stageHeight / 2) - (bmpChara2D.bitmapData.height * scale / 2)));

			// 現在時間取得 表示時間10秒
			var chatTime:int = getTimer() - 10000;
			var oxoxTime:int = getTimer() - 1000;
			
			// チャット吹き出し描画
			sortList.sort(sortFunc3);
			
			for (i = 0; i < leng; i++)
			{
				var x2:int = (sortList[i].x - pos.x) * scale + (mainStage.stageWidth / 2) - (bmpChara2D.bitmapData.width / 2);
				var y2:int = (sortList[i].y - pos.y) * scale + (mainStage.stageHeight / 2) - (bmpChara2D.bitmapData.height * scale / 2);
				buffer.copyPixels(sortList[i].bmpName, sortList[i].bmpName.rect, new Point(x2 - 180, y2 + 37 * scale));

				if (sortList[i].chatTime > chatTime)
				{
					buffer.copyPixels(sortList[i].bmpChat, sortList[i].bmpChat.rect, new Point(x2 - 180, y2 - 13 - sortList[i].chatY));
				}

				/*
				if (sortList[i].liveChatTime > chatTime)
				{
					buffer.copyPixels(sortList[i].bmpLiveChat, sortList[i].bmpLiveChat.rect, new Point((sortList[i].liveChatX - pos.x) * scale + (mainStage.stageWidth / 2) - 200, (sortList[i].liveChatY - pos.y) * scale + (mainStage.stageHeight / 2) - 40));
				}
				*/
				
				if (sortList[i].oxoxTime > oxoxTime)
				{
					buffer.copyPixels(bmpOxOx.bitmapData, bmpOxOx.bitmapData.rect, new Point(x2 - 80, y2 - 50));
				}
			}
			
			// 配信用チャット吹き出し描画
			sortList.sort(sortFunc2);
			
			for (i = 0; i < leng; i++)
			{
				if (sortList[i].liveChatTime > chatTime)
				{
					buffer.copyPixels(sortList[i].bmpLiveChat, sortList[i].bmpLiveChat.rect, new Point((sortList[i].liveChatX - pos.x) * scale + (mainStage.stageWidth / 2) - 200, (sortList[i].liveChatY - pos.y) * scale + (mainStage.stageHeight / 2) - 40));
				}
			}
			
			// 適応
			screen.bitmapData = buffer;
		}
		
		/******************************
		* ソート
		*******************************/
		private function sortFunc(a:CharaData, b:CharaData):int
		{
			if (a.y < b.y)
				return -1;
			else if (a.y > b.y)
				return 1;
			else
				return 0;
        }
		
		/******************************
		* ソート
		*******************************/
		private function sortFunc2(a:CharaData, b:CharaData):int
		{
			if (a.liveChatTime < b.liveChatTime)
				return -1;
			else if (a.liveChatTime > b.liveChatTime)
				return 1;
			else
				return 0;
        }
		
		/******************************
		* ソート
		*******************************/
		private function sortFunc3(a:CharaData, b:CharaData):int
		{
			if (a.chatTime < b.chatTime)
				return -1;
			else if (a.chatTime > b.chatTime)
				return 1;
			else
				return 0;
        }
		
		/******************************
		* マウスイベント
		*******************************/
		private function onMouseMove(event:MouseEvent):void
		{

			/*
			if (OverLookMove)
			{
				posX = event.stageX;
				posY = event.stageY;
			}
			else
			{
				posX = CharaPosX;
				posY = CharaPosY;
			}
			*/
		}
		
		/******************************
		* Mapサイズ変更
		*******************************/
		public function setMapSize(num:Number):void
		{
			if (scaleTween.isPlaying)
				scaleTween.stop();

			scaleTween = BetweenAS3.parallel(
				BetweenAS3.tween(this, { scale: num }, null, 1.5, Cubic.easeInOut)
			);
			scaleTween.play();
		}
		
		/******************************
		* キーボードイベント
		*******************************/
		private function onKeyDown(event:KeyboardEvent):void
		{
			/*
 			switch (event.keyCode)
			{
				// 見渡しモード切り替え（スペース）
				case 32:
					OverLookMove = !OverLookMove;

					if (scaleTween.isPlaying)
						scaleTween.stop();
						
					if (OverLookMove)
					{
						scaleTween = BetweenAS3.parallel(
							BetweenAS3.tween(this, { scale: 0.3 }, null, 1.5, Cubic.easeInOut)
						);
						scaleTween.play();
					}
					else
					{
						scaleTween = BetweenAS3.parallel(
							BetweenAS3.tween(this, { scale: 1 }, null, 1.5, Cubic.easeInOut)
						);
						scaleTween.play();
					}
			break;
			/*
					OverLookMove = !OverLookMove;

					if (OverLookMove)
					{
						posX = mouseX;
						posY = mouseY;
					}
					else
					{
						posX = CharaPosX;
						posY = CharaPosY;
					}
					
					break;
				/*
				case 37: posX -= 4; break;
				case 39: posX += 4; break;
				case 38: posY -= 4; break;
				case 40: posY += 4; break;
				*
			}
			*/
		}
		
		/******************************
		* マウスイベント
		*******************************/
		private function onMouseDown(event:MouseEvent):void
		{
			// 滝から落ちてる間は移動不可能
			if (tweenFall.isPlaying)
				return;
				
			// 移動可能か判定
			if (bmpdataMap.hitTest(new Point(-pos.x * scale + mainStage.stageWidth / 2, -pos.y * scale + mainStage.stageHeight / 2), 255, new Point(mouseX, mouseY)) == false)
				return;
			
			// 画面移動
			if (moveTween.isPlaying)
			{
				moveTween.stop();
			}
			
			// 移動パケット送信
			NetWork.sendMoveCharactor(pos.x + (mouseX - mainStage.stageWidth / 2) / scale, pos.y + (mouseY - mainStage.stageHeight / 2) / scale);
			
			// キャラの向き画像設定
			var dx:int = pos.x + (mouseX - mainStage.stageWidth / 2) / scale - myChara.x;
			var dy:int = pos.y + (mouseY - mainStage.stageHeight / 2) / scale - myChara.y;
			if (dy > dx)
			{
				if (dy > dx * -1)
				{
					myChara.dir = 0;
				}
				else
				{
					myChara.dir = 2;
				}
			}
			else
			{
				if (dy > dx * -1)
				{
					myChara.dir = 3;
				}
				else
				{
					myChara.dir = 1;
				}			
			}
			
			
			// 移動
			/*
			if ((mainStage.stageWidth / 5 < mouseX && mouseX < mainStage.stageWidth / 5 * 4) &&
			(mainStage.stageHeight / 5 < mouseY && mouseY < mainStage.stageHeight / 5 * 4))
			{
				moveTween = BetweenAS3.parallel(
					BetweenAS3.tween(myChara, { x: pos.x + (mouseX - mainStage.stageWidth / 2) / scale }, null, 1, Cubic.easeInOut),
					BetweenAS3.tween(myChara, { y: pos.y + (mouseY - mainStage.stageHeight / 2) / scale }, null, 1, Cubic.easeInOut)
				);
			}
			else
			*/
			{
				moveTween = BetweenAS3.parallel(
					BetweenAS3.tween(pos, { x: pos.x + (mouseX - mainStage.stageWidth / 2) / scale }, null, 1.5, Cubic.easeInOut),
					BetweenAS3.tween(pos, { y: pos.y + (mouseY - mainStage.stageHeight / 2) / scale }, null, 1.5, Cubic.easeInOut),
					BetweenAS3.tween(myChara, { x: pos.x + (mouseX - mainStage.stageWidth / 2) / scale }, null, 1, Cubic.easeInOut),
					BetweenAS3.tween(myChara, { y: pos.y + (mouseY - mainStage.stageHeight / 2) / scale }, null, 1, Cubic.easeInOut)
				);
			}

			moveTween.play();
		}
		
		/******************************
		* マウスホイールイベント
		*******************************/
		private function onMouseWheel(event:MouseEvent):void
		{
			// 拡大縮小
			if (event.delta < 0)
			{
				scale -= 0.05;
			}
			else
			{
				scale += 0.05;
			}
			
			// 拡大縮小制限
			if (scale >= 1)
			{
				scale = 1;
			}
			else if (scale <= 0.1)
			{
				scale = 0.1;
			}

			// 拡大用Bitmap作成
			createScaleBmp();
		}
		
		/******************************
		* マウスホイールクリックイベント
		*******************************/
		private function onDoubleClick(event:MouseEvent):void
		{
		//	bulletList.push(new Point(mouseX, mouseY));
		}

		/******************************
		*　拡大用Bitmap作成
		*******************************/
		private function createScaleBmp():void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);

			// 背景
			bmpdataMap.fillRect(bmpdataMap.rect, 0xDCECFF);
			bmpdataMap.draw((new imageMap as Bitmap).bitmapData, matrix, null, null, null, true);
			bmpdataMap.applyFilter(bmpdataMap, bmpdataMap.rect, new Point(), new DropShadowFilter(50, 45, 0, 0.7, 20, 20, 1, 1));

			// キャラ
			for (var i:int = 0; i < 4; i++)
			{
				imageChara[i] = new BitmapData(310, 1174, true, 0xffffff);
			}
			imageChara[0].draw(bmpChara2D.bitmapData, matrix, null, null, null, true);
			imageChara[1].draw(bmpChara2U.bitmapData, matrix, null, null, null, true);
			imageChara[2].draw(bmpChara2L.bitmapData, matrix, null, null, null, true);
			imageChara[3].draw(bmpChara2R.bitmapData, matrix, null, null, null, true);
			for (i = 0; i < 4; i++)
			{
				imageChara[i].applyFilter(imageChara[i], imageChara[i].rect, new Point(), new DropShadowFilter(4, 25, 0, 1, 10, 4, 1, 1));
			}
			
			// オーラ
			var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
			var colorMatrix:ColorMatrix = new ColorMatrix();
			//colorMatrix.adjustHue(0);
			colorMatrix.adjustHue(120);
			colorMatrixFilter.matrix = colorMatrix.matrix;
			bmpdataAuraForth.fillRect(bmpdataAuraForth.rect, 0xffffff);
			bmpdataAuraForth.draw(bmpAuraForth.bitmapData, matrix, null, null, null, true);
			bmpdataAuraForth.applyFilter(bmpdataAuraForth, bmpdataAuraForth.rect, new Point(), colorMatrixFilter);

			bmpdataAuraBack.fillRect(bmpdataAuraBack.rect, 0xffffff);
			bmpdataAuraBack.draw(bmpAuraBack.bitmapData, matrix, null, null, null, true);
			bmpdataAuraBack.applyFilter(bmpdataAuraBack, bmpdataAuraBack.rect, new Point(), colorMatrixFilter);

			// 配信
			bmpdataStream.fillRect(bmpdataStream.rect, 0xDCECFF);
			bmpdataStream.draw(bmpStream, matrix, null, null, null, true);
			
			// 滝
			for (i = 0; i < 4; i++)
			{
				imageWater[i] = new BitmapData(310, 1174, true, 0xffffff);
			}
			imageWater[0].draw(bmpWater1.bitmapData, matrix, null, null, null, true);
			imageWater[1].draw(bmpWater2.bitmapData, matrix, null, null, null, true);
			imageWater[2].draw(bmpWater3.bitmapData, matrix, null, null, null, true);
			imageWater[3].draw(bmpWater4.bitmapData, matrix, null, null, null, true);
			for (i = 0; i < 4; i++)
			{
				imageWater[i].applyFilter(imageWater[i], imageWater[i].rect, new Point(), new DropShadowFilter(50, 0, 0, 1, 20, 20, 1, 1));
			}
			
			// 雲
			bmpdataCloud.fillRect(bmpdataCloud.rect, 0xDCECFF);
			bmpdataCloud.draw(bmpCloud.bitmapData, matrix, null, null, null, true);
			bmpdataCloud.applyFilter(bmpdataCloud, bmpdataCloud.rect, new Point(), new DropShadowFilter(50, 45, 0, 0.7, 20, 20, 1, 1));
		}
	}
}
