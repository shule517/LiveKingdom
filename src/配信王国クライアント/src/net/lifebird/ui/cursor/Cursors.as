package net.lifebird.ui.cursor
{
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import net.lifebird.ui.cursor.CursorData;
	
	/**
	 * カーソル拡張クラス
	 * @author airbird
	 * @link http://lifebird.net
	 * @version 4.2
	 */
	
	public class Cursors
	{
		private static var _stage:Stage;
		private static var container:Sprite = new Sprite();
		private static var cursors:Array = new Array();
		private static var isAbsolute:Boolean = false;
		private static var isGrip:Boolean = false;
		private static var clickGuard:Sprite = new Sprite();
		private static var latestTarget:DisplayObject;
		
		private static var lib:Dictionary = new Dictionary();
		
		/**
		 * コンストラクタ
		 */
		public function Cursors();
		
		/**
		 * カーソルの初期化
		 * @param	stage
		 */
		public static function init(stage:Stage):void {
			_stage = stage;
			stage.addChild(container);
			container.mouseEnabled = false;
			container.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, leaveHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			clickGuard.mouseEnabled = true;
			clickGuard.graphics.beginFill(0x000000, 0);
			clickGuard.graphics.drawCircle(0, 0, 30);
			clickGuard.graphics.endFill();
			clickGuard.visible = false;
			container.addChild(clickGuard);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stageUpHandler);
		}
		/**
		 * カーソルを絶対的に変更する
		 * @param	type
		 * @param	clickable
		 */
		public static function absolute(type:String = null,clickable:Boolean = true):void {
			if (type) {
				isAbsolute = true;
				Mouse.hide();
				setCursor(type);
				if (!clickable) {
					clickGuard.visible = true;
				}
			} else {
				isAbsolute = false;
				clickGuard.visible = false;
				cursor();
			}
		}
		/**
		 * カーソルを変更する
		 * @param	type
		 */
		public static function cursor(type:String = null):void {
			if (!isAbsolute) {
				if (type && cursors[type] && !CursorType.DEFAULT) {
					Mouse.hide();
					setCursor(type);
				} else {
					setCursor();
					Mouse.show();
				}
			}
		}
		/**
		 * ターゲットにオーバー時・アウト時のカーソルを設定する
		 * @param	target
		 * @param	over
		 * @param	out
		 */
		public static function addHoverCursor(target:DisplayObject,over:String=null, out:String=null):void {
			var data:CursorData = new CursorData();
			data.over = over;
			data.out = out;
			lib[target] = data;
			target.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			target.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		/**
		 * ターゲットにオーバー時・アウト時・ダウン時のカーソルを設定する
		 * ダウン状態でマウスアウトするとカーソルは戻る
		 * @param	target
		 * @param	over
		 * @param	down
		 * @param	out
		 */
		public static function addButtonCursor(target:DisplayObject, over:String=null, down:String=null, out:String = null):void {
			var data:CursorData = new CursorData();
			data.over = over;
			data.out = out;
			data.down = down;
			data.up = over;
			lib[target] = data;
			target.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			target.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			target.addEventListener(MouseEvent.MOUSE_DOWN, downhandler);
			target.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		/**
		 * ターゲットにオーバー時・アウト時・ダウン時のカーソルを設定する
		 * ダウン状態でマウスアウトしてもカーソルはダウン状態のまま維持する
		 * @param	target
		 * @param	over
		 * @param	down
		 * @param	out
		 */
		public static function addDragCursor(target:DisplayObject, over:String = null, down:String = null, out:String = null):void {
			var data:CursorData = new CursorData();
			data.over = over;
			data.out = out;
			data.down = down;
			data.up = over;
			data.useGrip = true;
			lib[target] = data;
			target.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			target.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			target.addEventListener(MouseEvent.MOUSE_DOWN, downhandler);
			target.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 * ターゲットのマウスイベントをすべて破棄する
		 * @param	target
		 */
		public static function removeEvents (target:DisplayObject):void {
			if (latestTarget === target) {
				latestTarget = null;
			}
			target.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
			target.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
			target.removeEventListener(MouseEvent.MOUSE_DOWN, downhandler);
			target.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			delete lib[target];
		}
		
		/**
		 * オリジナルのカーソル定義を追加する
		 * @param	typeName
		 * @param	obj
		 * @param	position
		 */
		public static function addCursor(typeName:String, obj:DisplayObject, position:String = ""):void {
			if (cursors[typeName]) {
				trace('Overrided: ' + typeName);
			}
			var temp:*;
			if (obj is Sprite) {
				temp = obj as Sprite;
				temp.mouseEnabled = false;
			}
			if (obj is MovieClip) {
				temp = obj as MovieClip;
				temp.mouseEnabled = false;
			}
			obj.visible = false;
			setPosition(obj,position);
			cursors[typeName] = obj;
			container.addChild(obj);
		}
		/**
		 * カーソルオブジェクトを取得する
		 * @param	name
		 * @return
		 */
		public static function getCursor(name:String):DisplayObject {
			if (cursors[name]) {
				return cursors[name] as DisplayObject;
			} else {
				return null;
			}
		}
		/**
		 * カーソル変更を反映する
		 * @param	type
		 */
		private static function setCursor(type:String=null):void {
			for (var s:String in cursors) {
				if (type == s) {
					cursors[s].visible = true;
				} else {
					cursors[s].visible = false;
				}
			}
		}
		/**
		 * カーソルの基準点を設定する
		 * @param	target
		 * @param	pos
		 */
		private static function setPosition(target:DisplayObject,pos:String):void {
			switch(pos) {
				case "tl" :
					target.x = target.y = 0;
					break;
				case "t" :
					target.x = -target.width / 2;
					target.y = 0;
					break;
				case "tr" :
					target.x = -target.width;
					target.y = 0;
					break;
				case "cl" :
					target.x = 0;
					target.y = -target.height / 2;
					break;
				case "c" :
					target.x = -target.width / 2;
					target.y = -target.height / 2;
					break;
				case "cr" :
					target.x = -target.width;
					target.y = -target.height / 2;
					break;
				case "bl" :
					target.x = 0;
					target.y = -target.height;
					break;
				case "b" :
					target.x = -target.width / 2;
					target.y = -target.height;
					break;
				case "br" :
					target.x = -target.width;
					target.y = -target.height;
					break;
				default :
					target.x = -target.width / 2;
					target.y = -target.height / 2;
			}
		}
		/**
		 * 最前面にターゲットを表示する
		 * @param	target
		 */
		private static function highestDepth(target:*):void {
			try {
				target.parent.setChildIndex(target,target.parent.numChildren-1);
			}catch(e:RangeError) {
				trace(e);
			}
		}
		
		private static function overHandler(e:MouseEvent):void {
			var data:CursorData = lib[e.currentTarget];
			if (!data.useGrip || !isGrip) {
				cursor(data.over);
			}
			data.isOver = true;
			lib[e.currentTarget] = data;
		}
		private static function outHandler(e:MouseEvent):void {
			var data:CursorData = lib[e.currentTarget];
			if (!data.useGrip || !isGrip) {
				cursor(data.out);
			}
			data.isOver = false;
			lib[e.currentTarget] = data;
		}
		private static function upHandler(e:MouseEvent):void {
			var data:CursorData = lib[e.currentTarget];
			cursor(data.up);
			isGrip = false;
			lib[e.currentTarget] = data;
			latestTarget = null;
		}
		private static function downhandler(e:MouseEvent):void {
			var data:CursorData = lib[e.currentTarget];
			latestTarget = e.currentTarget as DisplayObject;
			cursor(data.down);
			isGrip = true;
			lib[e.currentTarget] = data;
		}
		
		private static function leaveHandler(e:Event):void {
			container.visible = false;
		}
		
		private static function moveHandler(e:MouseEvent):void {
			container.visible = true;
		}
		
		private static function stageUpHandler(e:MouseEvent):void {
			if (latestTarget) {
				var data:CursorData = lib[latestTarget];
				isGrip = false;
				if (data.isOver) {
					cursor(data.over);
				} else {
					cursor(data.out);
				}
				lib[latestTarget] = data;
				latestTarget = null;
			}
		}
		
		private static function enterFrameHandler(e:Event):void {
			container.x = _stage.mouseX;
			container.y = _stage.mouseY;
			highestDepth(container);
		}
	}
}