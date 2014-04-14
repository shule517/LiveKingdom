package  net.lifebird.ui.scroll.plugin
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import caurina.transitions.Tweener;
	import net.lifebird.ui.scroll.ScrollerObject;
	
	/**
	 * Scroller拡張クラス　Tweenerアニメーション
	 * @author yuu
	 * @link http://lifebird.net
	 * @version 1.0
	 * @update 2009/05/03
	 * @required Tweener(http://code.google.com/p/tweener/)
	 */
	public class ScrollerTweener extends ScrollerObject
	{
		public function ScrollerTweener(_height:int=300,bgObject:Sprite=null,barObject:Sprite=null) 
		{
			super(_height, bgObject, barObject);
		}
		protected override function mouseDownHandler(e:MouseEvent):void
		{
			Tweener.pauseTweens(bar);
			var bounds:Rectangle = new Rectangle(0, _min,0, scrollHeight - bar.height - _min+1);
			bar.startDrag(false, bounds);
		}
		protected override function onClick(e:MouseEvent):void {
			var my:Number = this.mouseY+1 - bar.height / 2;
			if (my < 0) {
				my = 0;
			}
			if (my + bar.height > scrollHeight) {
				my = scrollHeight - bar.height;
			}
			Tweener.addTween(bar,
			{
				time: 1,
				y: my,
				transition : "easeOutExpo"
			});
		}
		public override function wheel(e:MouseEvent):void {
			var delta:Number = e.delta * strength;
			var ty:Number = 0;
			if (bar.y - delta <= 0) {
				ty = 0;
			} else if (bar.y - delta >= maxPoint) {
				ty = maxPoint;
			} else {
				ty = bar.y - delta;
			}
			Tweener.addTween(bar,
			{
				time: 1,
				y: ty,
				transition : "easeOutExpo"
			});
		}
		public override function initMotion(time:int=1):void {
			bar.y = maxPoint;
			Tweener.addTween(bar,
			{
				time: time,
				y: _min,
				transition: "easeOutExpo"
			});
		}
	}
}