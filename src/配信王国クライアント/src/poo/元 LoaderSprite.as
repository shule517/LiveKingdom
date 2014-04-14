package  poo
{
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author 
	 */
	public class LoaderSprite extends Sprite
	{
		[Embed(source = '../data/chara.png')]
		private var charaimage:Class;
		private var charabitmap:Bitmap;
		[Embed(source = '../data/word1.gif')]
		private var word_image1:Class;
		private var word_bitmap1:Bitmap;
		[Embed(source = '../data/word2.gif')]
		private var word_image2:Class;
		private var word_bitmap2:Bitmap;
		[Embed(source = '../data/word3.gif')]
		private var word_image3:Class;
		private var word_bitmap3:Bitmap;
		[Embed(source = '../data/word4.gif')]
		private var word_image4:Class;
		private var word_bitmap4:Bitmap;
		[Embed(source = '../data/word5.gif')]
		private var word_image5:Class;
		private var word_bitmap5:Bitmap;
		[Embed(source = '../data/word6.gif')]
		private var word_image6:Class;
		private var word_bitmap6:Bitmap;
		[Embed(source = '../data/word7.gif')]
		private var word_image7:Class;
		private var word_bitmap7:Bitmap;
		[Embed(source = '../data/word8.gif')]
		private var word_image8:Class;
		private var word_bitmap8:Bitmap;
		[Embed(source = '../data/word9.gif')]
		private var word_image9:Class;
		private var word_bitmap9:Bitmap;
		[Embed(source = '../data/word10.gif')]
		private var word_image10:Class;
		private var word_bitmap10:Bitmap;

        private var colors:Array; 
        private var alphas:Array;
        private var ratios:Array; 
        private var matrix:Matrix;
		private var timer:Timer;
		private var wordtimer:Timer;
		private var pointx:Number;
		private var mathA:Number;
		private var wordposx:Number = 150;
		private var wordposy:Number = 225;


		public function LoaderSprite() 
		{
			init();
		}
		private function init():void {
			timer = new Timer(10, 0);
			timer.addEventListener(TimerEvent.TIMER, MoveChara);
			wordtimer = new Timer(100, 0);
			wordtimer.addEventListener(TimerEvent.TIMER, MoveWord);
			charabitmap = new charaimage;
			word_bitmap1 = new word_image1;
			word_bitmap1.x = wordposx;
			word_bitmap1.y = wordposy;
			word_bitmap2 = new word_image2;
			word_bitmap2.x = wordposx+32;
			word_bitmap2.y = wordposy;
			word_bitmap3 = new word_image3;
			word_bitmap3.x = wordposx+64;
			word_bitmap3.y = wordposy;
			word_bitmap4 = new word_image4;
			word_bitmap4.x = wordposx+96;
			word_bitmap4.y = wordposy;
			word_bitmap5 = new word_image5;
			word_bitmap5.x = wordposx+128;
			word_bitmap5.y = wordposy;
			word_bitmap6 = new word_image6;
			word_bitmap6.x = wordposx+160;
			word_bitmap6.y = wordposy;
			word_bitmap7 = new word_image7;
			word_bitmap7.x = wordposx+192;
			word_bitmap7.y = wordposy;
			word_bitmap8 = new word_image8;
			word_bitmap8.x = wordposx+224;
			word_bitmap8.y = wordposy;
			word_bitmap9 = new word_image9;
			word_bitmap9.x = wordposx+256;
			word_bitmap9.y = wordposy;
			word_bitmap10 = new word_image10;
			word_bitmap10.x = wordposx+288;
			word_bitmap10.y = wordposy;
			addChild(charabitmap);
			addChild(word_bitmap1);
			addChild(word_bitmap2);
			addChild(word_bitmap3);
			addChild(word_bitmap4);
			addChild(word_bitmap5);
			addChild(word_bitmap6);
			addChild(word_bitmap7);
			addChild(word_bitmap8);
			addChild(word_bitmap9);
			addChild(word_bitmap10);
			colors = [0xffffff,0x000000]; 
			alphas = [1.0, 1.0]; 
			ratios = [0, 255]; 
			matrix = new Matrix();
			matrix.createGradientBox(30, 30, 0, 465, 200);
            graphics.lineStyle(); 
            graphics.beginGradientFill(GradientType.RADIAL,  
                                        colors, 
                                        alphas, 
                                        ratios, 
                                        matrix); 
			graphics.drawRect(0, 0, 640, 480);
            graphics.endFill();
			pointx = 0;
			mathA = 0;
			timer.start();
			wordtimer.start();
		}
		private function MoveChara(e:TimerEvent):void {
			//円運動
			charabitmap.x = 130 + 20*Math.cos(pointx/60);
　			charabitmap.y = 190 + 20*Math.sin(pointx/60);
			pointx += 5;
		}
		private function MoveWord(e:TimerEvent):void {
			//Nowloading 運動
			var x:int = -2;
			var y:int = 20;
			word_bitmap1.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap1.y > wordposy) word_bitmap1.y = wordposy;
			++x;
			word_bitmap2.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap2.y > wordposy) word_bitmap2.y = wordposy;
			++x;
			word_bitmap3.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap3.y > wordposy) word_bitmap3.y = wordposy;
			++x;
			word_bitmap4.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap4.y > wordposy) word_bitmap4.y = wordposy;
			++x;
			word_bitmap5.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap5.y > wordposy) word_bitmap5.y = wordposy;
			++x;
			word_bitmap6.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap6.y > wordposy) word_bitmap6.y = wordposy;
			++x;
			word_bitmap7.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap7.y > wordposy) word_bitmap7.y = wordposy;
			++x;
			word_bitmap8.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap8.y > wordposy) word_bitmap8.y = wordposy;
			++x;
			word_bitmap9.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap9.y > wordposy) word_bitmap9.y = wordposy;
			++x;
			word_bitmap10.y = (x * x) - (2 * mathA * x) + (mathA * mathA) + wordposy-y;
			if (word_bitmap10.y > wordposy) word_bitmap10.y = wordposy;
			if (mathA < 12) {
				++mathA;
			}else {
				mathA = 0;
			}
		}
	}

}