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
		/************
		 * 画像読み込み
		 ***********/
		//キャラクター
		[Embed(source = '../data/chara.gif')]
		private var charaimage:Class;
		private var charabitmap:Bitmap;
		//キャラクター
		[Embed(source = '../data/chara.gif')]
		private var charaimage2:Class;
		private var charabitmap2:Bitmap;
		//キャラクター
		[Embed(source = '../data/chara.gif')]
		private var charaimage3:Class;
		private var charabitmap3:Bitmap;
		
		//N
		[Embed(source = '../data/word1.gif')]
		private var word_image1:Class;
		private var word_bitmap1:Bitmap;
		//o
		[Embed(source = '../data/word2.gif')]
		private var word_image2:Class;
		private var word_bitmap2:Bitmap;
		//w
		[Embed(source = '../data/word3.gif')]
		private var word_image3:Class;
		private var word_bitmap3:Bitmap;
		//l
		[Embed(source = '../data/word4.gif')]
		private var word_image4:Class;
		private var word_bitmap4:Bitmap;
		//o
		[Embed(source = '../data/word5.gif')]
		private var word_image5:Class;
		private var word_bitmap5:Bitmap;
		//a
		[Embed(source = '../data/word6.gif')]
		private var word_image6:Class;
		private var word_bitmap6:Bitmap;
		//d
		[Embed(source = '../data/word7.gif')]
		private var word_image7:Class;
		private var word_bitmap7:Bitmap;
		//i
		[Embed(source = '../data/word8.gif')]
		private var word_image8:Class;
		private var word_bitmap8:Bitmap;
		//n
		[Embed(source = '../data/word9.gif')]
		private var word_image9:Class;
		private var word_bitmap9:Bitmap;
		//g
		[Embed(source = '../data/word10.gif')]
		private var word_image10:Class;
		private var word_bitmap10:Bitmap;

        private var colors:Array; 
        private var alphas:Array;
        private var ratios:Array; 
        private var matrix:Matrix;
		private var timer:Timer;//円運動のタイマー
		private var wordtimer:Timer;//Nowloading のタイマー
		private var pointx:Number;//円運動のポジションを決める
		private var wordposx:Number = 150;//画像の基本ポジション
		private var wordposy:Number = 225;//画像の基本ポジション
		private var i:Number;//関数MoveWordの制御
		private var lsy:Array;//Nowloadingの位置制御に用いる
		private var index:Number;//キャラクター１つ目のジャンプの倍化率
		private var index2:Number;//キャラクター２つ目のジャンプの倍化率
		private var index3:Number;//キャラクター３つ目のジャンプの倍化率


		public function LoaderSprite() 
		{
			init();
		}
		/****************
		 * 初期化
		 * ***************/
		private function init():void {
			timer = new Timer(10, 0);
			timer.addEventListener(TimerEvent.TIMER, MoveChara);
			wordtimer = new Timer(50, 0);
			wordtimer.addEventListener(TimerEvent.TIMER, MoveWord);
			charabitmap = new charaimage;
			charabitmap.x = wordposx - 142;
			charabitmap.y = wordposy ;
			charabitmap2 = new charaimage2;
			charabitmap2.x = wordposx - 100;
			charabitmap2.y = wordposy ;
			charabitmap3 = new charaimage3;
			charabitmap3.x = wordposx - 58;
			charabitmap3.y = wordposy ;
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
			addChild(charabitmap2);
			addChild(charabitmap3);
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
			graphics.drawRect(0, 0, 640, 480);
            graphics.endFill();
			pointx = 0;
			index = Math.random() + 1;
			index2 = Math.random() + 1;
			index3 = Math.random() + 1;
			i = 0;
			lsy = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			timer.start();
			wordtimer.start();
		}
		/******************
		 * 円運動
		 * ***************/
		private function MoveChara(e:TimerEvent):void {
			graphics.clear();
			matrix.createGradientBox(
				40,
				40,
				0, 
				( 280+100 * Math.cos(pointx / 60)),
				 210+100*Math.sin(pointx/60));

			graphics.lineStyle(); 
            graphics.beginGradientFill(GradientType.RADIAL,  
                                        colors, 
                                        alphas, 
                                        ratios, 
                                        matrix); 
			graphics.drawRect(0, 0, 640, 480);
            graphics.endFill();
			pointx += 5;
		}
		/*******************
		 *　Nowloading 運動
		 * *****************/
		private function MoveWord(e:TimerEvent):void {
			var l:Number = 0;
			if (i > 0) {
				for (var k:Number = i; k > 0; k-- ) {
					lsy[k-1] = Math.sin( (180 - ( l * 16.4)) * Math.PI / 180 ) * 30;
					l++;
				}
			}
			l = 0;
			if(i<11){
				for (var j:Number = i; j < 11; j++ ) {
					lsy[j] = Math.sin( l * 16.4 * Math.PI / 180 ) * 30;
					l++;
				}
			}
			charabitmap.y = wordposy - (lsy[0] * index)+150;
			charabitmap2.y = wordposy - (lsy[5] * index2)+150;
			charabitmap3.y = wordposy - (lsy[2] * index3) + 150;
			word_bitmap1.y = wordposy - lsy[1];
			word_bitmap2.y = wordposy - lsy[2];
			word_bitmap3.y = wordposy - lsy[3];
			word_bitmap4.y = wordposy - lsy[4];
			word_bitmap5.y = wordposy - lsy[5];
			word_bitmap6.y = wordposy - lsy[6];
			word_bitmap7.y = wordposy - lsy[7];
			word_bitmap8.y = wordposy - lsy[8];
			word_bitmap9.y = wordposy - lsy[9];
			word_bitmap10.y = wordposy - lsy[10];
			++i;
			if (i > 11) {
				i = 0;
				index = Math.random() + 1;
			}
			if (i == 6) {
				index2 = Math.random() + 1;
			}
			if (i == 3) {
				index3 = Math.random() + 1;
			}
		}
	}

}