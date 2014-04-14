package LBB
{
	import flash.display.*;
	import flash.events.*;

	public class Upframe extends DownFrame
	{
		protected var Up_mc:MovieClip;
		protected var Up_bg:Sprite
		
		public function Upframe():void
		{
			setUp_mc();
		}
		
		private function setUp_mc():void
		{
			Up_mc = new MovieClip();
			Up_bg = new Sprite();
			
			Up_bg.graphics.beginFill(0x00ffff);
			Up_bg.graphics.drawRect(0, 0, Side_bg.width - 10, Side_bg.height / 2 - 5);
			Up_bg.graphics.endFill();
			Up_bg.x = Side_bg.x + 5;
			Up_bg.y = Side_bg.y + 5;

			Up_mc.addChild(Up_bg);
			Side_mc.addChild(Up_mc);
			Side_mc.addChild(Down_mc);
		}
		
		override protected function UpDownFrame_Resize():void
		{
			super.UpDownFrame_Resize();
			Up_bg.height = Down_square.y;
		}
		
		override protected function Resize():void
		{
			super.Resize();
			Up_bg.width = Side_bg.width - 10;
			Up_bg.x = Side_bg.x + 5;
		}
	}
}