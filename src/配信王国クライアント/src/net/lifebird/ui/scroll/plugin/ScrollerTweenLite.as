package  net.lifebird.ui.scroll.plugin
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import net.lifebird.ui.scroll.ScrollerObject;
	
	/**
	 * Scroller拡張クラス　TweenLiteアニメーション
	 * @author yuu
	 * @link http://lifebird.net
	 * @version 1.0
	 * @update 2009/05/03
	 * @required TweenLite(http://www.greensock.com/tweenlite/)
	 */
	public class ScrollerTweenLite extends ScrollerObject
	{
		public function ScrollerTweenLite(_height:int=300,bgObject:Sprite=null,barObject:Sprite=null) 
		{
			super(_height, bgObject, barObject);
		}
		protected override function mouseDownHandler(e:MouseEvent):void
		{
			TweenLite.killTweensOf(bar);
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
			TweenLite.to(bar,1,
			{
				y: my,
				ease: Expo.easeOut
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
			TweenLite.to(bar,1,
			{
				y: ty,
				ease: Expo.easeOut
			});
		}
		public override function initMotion(time:int=1):void {
			bar.y = maxPoint;
			TweenLite.to(bar,time,
			{
				y: _min,
				ease: Expo.easeOut
			});
		}
	}
}