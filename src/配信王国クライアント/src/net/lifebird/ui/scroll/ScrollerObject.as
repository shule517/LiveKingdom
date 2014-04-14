package  net.lifebird.ui.scroll
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * スクロールバー基本クラス
	 * @author yuu
	 * @link http://lifebird.net
	 * @version 3.0
	 * @update 2009/05/03
	 */
	public class ScrollerObject extends Sprite
	{
		protected var _min:int = 0;
		protected var _max:int = 100;
		protected var _value:int = 0;
		protected var maxPoint:int = 0;
		public var vertical:Boolean = true;
		protected var scrollHeight:int;
		public var strength:int = 10;
		protected var bar:Sprite = new Sprite();
		protected var bg:Sprite = new Sprite();
		
		/**
		 * スクロールの最大値を設定します
		 */
		public function set max(val:int):void {
			_max = val;
			var scale:Number = scrollHeight / _max;
			var n:int = Math.floor(scale);
			scale = scale - n;
			bar.height = scrollHeight * (scale);
			maxPoint = scrollHeight - bar.height - _min+1;
		}
		public function get max():int {
			return _max;
		}
		/**
		 * スクロールvalueを設定します（外部からのスクロールバー設定に使用）
		 */
		public function set value(val:int):void {
			_value = val;
			bar.y = Math.floor(((scrollHeight - bar.height - _min) / _max * val) + _min);
		}
		public function get value():int {
			return _value;
		}
		
		public function set scrollerHeight(val:int):void {
			scrollHeight = val;
			bg.height = val;
		}
		
		/**
		 * スクロールバーの実装
		 * @param	height バーの高さ
		 * @param	bgObject 背景に使用するSprite
		 * @param	barObject ドラッグバーに使用するSprite
		 */
		public function ScrollerObject(_height:int=300,bgObject:Sprite=null,barObject:Sprite=null) 
		{
			scrollHeight = _height;
			if (bgObject) {
				bg = bgObject;
				bg.height = _height;
			} else {
				defaultBar("bg");
			}
			if (barObject) {
				bar = barObject;
			} else {
				defaultBar("bar");
			}
			bar.buttonMode = true;
			addChild(bg);
			addChild(bar);
			
			bg.addEventListener(MouseEvent.CLICK, onClick);
			bar.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			bar.addEventListener(MouseEvent.MOUSE_UP, mouseDownHandler);
			
			addEventListener(Event.ADDED, onAdded);
		}
		protected function onAdded(e:Event):void {
			removeEventListener(Event.ADDED, onAdded);
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			addEventListener(MouseEvent.MOUSE_WHEEL, wheel);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 
		 * @param	e
		 */
		protected function onEnterFrame(e:Event):void
		{
			_value = Math.floor((bar.y - _min) / (scrollHeight - bar.height - _min) * _max);
		}
		
		/**
		 * 
		 * @param	e
		 */
		protected function mouseDownHandler(e:MouseEvent):void
		{
			var bounds:Rectangle = new Rectangle(0, _min,0, scrollHeight - bar.height - _min+1);
			bar.startDrag(false, bounds);
		}
		
		/**
		 * 
		 * @param	e
		 */
		protected function mouseUpHandler(e:MouseEvent):void
		{
			bar.stopDrag();
		}
		/**
		 * 
		 * @param	e
		 */
		protected function onMouseLeave(e:Event):void {
			bar.stopDrag();
		}
		/**
		 * 
		 * @param	e
		 */
		protected function onClick(e:MouseEvent):void {
			var my:Number = this.mouseY+1 - bar.height / 2;
			if (my < 0) {
				my = 0;
			}
			if (my + bar.height > scrollHeight) {
				my = scrollHeight - bar.height;
			}
			bar.y = my;
		}
		/**
		 * 
		 * @param	e
		 */
		public function wheel(e:MouseEvent):void {
			var delta:Number = e.delta * strength;
			var ty:Number = 0;
			if (bar.y - delta <= 0) {
				ty = 0;
			} else if (bar.y - delta >= maxPoint) {
				ty = maxPoint;
			} else {
				ty = bar.y - delta;
			}
			bar.y = ty;
		}
		/**
		 * デフォルトバーの生成
		 * @param	type
		 */
		protected function defaultBar(type:String):void {
			switch(type) {
				case "bg":
					bg.graphics.beginFill(0xCCCCCC);
					bg.graphics.drawRect(0, 0, 15, scrollHeight);
					bg.graphics.endFill();
					break;
				case "bar":
					bar.graphics.beginFill(0x333333);
					bar.graphics.drawRect(0, 0, 15, 50);
					bar.graphics.endFill();
					//bar.addEventListener(MouseEvent.ROLL_OVER, onOver);
					//bar.addEventListener(MouseEvent.ROLL_OUT, onOut);
					break;
				default:
					break;
			}
		}
		
		protected function onOver(e:MouseEvent):void {
			e.currentTarget.alpha = 0.7;
		}
		protected function onOut(e:MouseEvent):void {
			e.currentTarget.alpha = 1;
		}
		
		public function remove():void {
			//stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			removeEventListener(MouseEvent.MOUSE_WHEEL, wheel);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			bg.removeEventListener(MouseEvent.CLICK, onClick);
			bar.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			bar.removeEventListener(MouseEvent.MOUSE_UP, mouseDownHandler);
			
			removeEventListener(Event.ADDED, onAdded);
			
			removeChild(bg);
			removeChild(bar);
		}
		public function initMotion(time:int = 1):void {
		}
	}
}