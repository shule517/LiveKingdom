package  poo
{
	/**
	 * ...
	 * @author 
	 */
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Graphics;

	public class EndSprite extends Sprite
	{
		//[Embed(source = '../data/配信終了.png')]
		[Embed(source = '../data/disconect.gif')]
		private var endimage:Class;
		private var endbitmap:Bitmap;
		public function EndSprite() 
		{
			endbitmap = new endimage;
			endbitmap.x = 120;
			endbitmap.y = 57;
			addChild(endbitmap);
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 0, 480, 320);
		}
	}

}