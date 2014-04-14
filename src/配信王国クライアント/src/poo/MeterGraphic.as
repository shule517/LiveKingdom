package  poo
{
	/**
	 * VUメーターを描画するクラス
	 * ...
	 * @author poo
	 */
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class MeterGraphic extends Sprite
	{
		private var panel:Sprite;
        private var colors:Array; 
        private var alphas:Array;
        private var ratios:Array; 
        private var matrix:Matrix;
		
		public function MeterGraphic(xpos:int,ypos:int):void
		{
			super.x = xpos;
			super.y = ypos;
			init();
		}
		/***************
		 * 初期化　メモリの描画
		 * ************/
		private function init():void {
			graphics.lineStyle(1, 0x00000);
			graphics.moveTo(0, 0);
			graphics.lineTo(0, 18);
			graphics.moveTo(100, 0);
			graphics.lineTo(100, 4);
			graphics.moveTo(100, 14);
			graphics.lineTo(100, 18);
			graphics.moveTo(200, 0);
			graphics.lineTo(200, 18);
			for (var j:int = 0; j < 4;++j ) {
				graphics.moveTo(20 + j * 20, 2);
				graphics.lineTo(20 + j * 20, 4);
				graphics.moveTo(20 + j * 20, 14);
				graphics.lineTo(20 + j * 20, 16);				
			}
			for (var k:int = 0; k < 4;++k ) {
				graphics.moveTo(120 + k * 20, 2);
				graphics.lineTo(120 + k * 20, 4);
				graphics.moveTo(120 + k * 20, 14);
				graphics.lineTo(120 + k * 20, 16);				
			}
			panel = new Sprite();
			panel.x = 0;
			panel.y = 4;
			addChild(panel);
			colors = [0xffff00, 0xff0000]; 
			alphas = [1.0, 1.0]; 
			ratios = [0, 255]; 
			matrix = new Matrix();
			matrix.createGradientBox(200, 10, 0, 0, 0);
		}
		//マイクレベルに応じて、四角形を描画する
		public function DrawMeter(level:int):void {
            // グラデーションのかかった四角形を描く 
			panel.graphics.clear();//描画を消す
            panel.graphics.lineStyle(); 
            panel.graphics.beginGradientFill(GradientType.LINEAR,  
                                        colors, 
                                        alphas, 
                                        ratios, 
                                        matrix); 
            panel.graphics.drawRect(0, 0, level*2, 10); 
            panel.graphics.endFill();
		}
	}
}