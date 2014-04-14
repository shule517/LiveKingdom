package LBB
{
	import flash.display.*;
	import flash.events.*;
	
	public class Map extends Sprite
	{
		private var mapBox:MovieClip = new MovieClip();
		private var bg_map:Sprite = new Sprite();
		private var me:Sprite = new Sprite();
		private var other:Array = new Array();
		private var movie:Array = new Array();
		private var scale_x:Number;
		private var scale_y:Number;
		private var i:Number;
		
		private var movieinfo:Thumbnail = new Thumbnail;

		public function Map():void
		{
			mapBox.visible = false;
			addChild(mapBox);
			addChild(movieinfo);
			
			//stegeリサイズ時のイベント
			Main.mainStage.addEventListener(Event.RESIZE, Resize);
		}
		
		private function setbg():void
		{
			bg_map = graphic(0xffff99, 0xffcc66, 3, Main.mainStage.stageWidth - 50, Main.mainStage.stageHeight - 50);
			bg_map.x = bg_map.y = 25;
			
			scale_x = (bg_map.width - 16) / 255;
			scale_y = (bg_map.height - 16) / 255;
			
			mapBox.addChild(bg_map);
		}
		
		private function setMe():void
		{
			var R_x:Number = Math.floor(Math.random() * 255);
			var R_y:Number = Math.floor(Math.random() * 255);
			
			me = graphic(0xcc0000, 0xcc0000, 0, 15, 15);
			
			me.x = bg_map.x + 2 + R_x * scale_x;
			me.y = bg_map.y + 2 + R_y * scale_y;
			
			mapBox.addChild(me);
		}
		
		private function setother():void
		{
			for (i = 0; i < 79 ; i++ )
			{
				var R_x:Number = Math.floor(Math.random() * 255);
				var R_y:Number = Math.floor(Math.random() * 255);
				
				other[i] = graphic(0x00ff00, 0x00ff00, 0, 10, 10);
				other[i].x = bg_map.x + 2 + R_x * scale_x;
				other[i].y = bg_map.y + 2 + R_y * scale_y;
				
				mapBox.addChild(other[i]);
			}
		}
		
		private function setmovie():void
		{
			for (i = 0; i < 20 ; i++ )
			{
				var R_x:Number = Math.floor(Math.random() * 255);
				var R_y:Number = Math.floor(Math.random() * 255);
				
				movie[i] = graphic(0x0000ff, 0x0000ff, 0, 20, 20);
				movie[i].x = bg_map.x + 2 + R_x * scale_x;
				movie[i].y = bg_map.y + 2 + R_y * scale_y;
				
				movie[i].addEventListener(MouseEvent.MOUSE_OVER, over(i));
				//movie[i].addEventListener(MouseEvent.MOUSE_OUT, out(i));
				
				mapBox.addChild(movie[i]);
			}			
		}
		
		private function over(i:Number):Function
		{
			return function (e:MouseEvent):void
			{
				movieinfo.first_disp();
				movieinfo.MovieInfo.x = movie[i].x - 452 / 2;
				movieinfo.MovieInfo.y = movie[i].y;
				if (movieinfo.MovieInfo.x < bg_map.x)
				{
					movieinfo.MovieInfo.x = bg_map.x + 2;
				}
				else if (movieinfo.MovieInfo.x + 452 > bg_map.x + bg_map.width)
				{
					movieinfo.MovieInfo.x = bg_map.x + bg_map.width - 452 - 2;
				}
				if (movieinfo.MovieInfo.y + 110 > bg_map.y + bg_map.height)
				{
					trace(movieinfo.MovieInfo.y + 110);
					trace(bg_map.y + bg_map.height);
					movieinfo.MovieInfo.y = (movieinfo.MovieInfo.y - ((movieinfo.MovieInfo.y + 110) - (bg_map.y + bg_map.height))) - 4;
				}
				movieinfo.MovieInfo.visible = true;
			}
		}
		
		/*private function out(i:Number):Function
		{
			return function (e:MouseEvent):void
			{
				movieinfo.not_disp();
			}
		}*/
		
		private function graphic(color:uint, lineColor:uint, linepoint:Number, w:Number, h:Number):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(linepoint, lineColor);
			sp.graphics.beginFill(color);
			sp.graphics.drawRect(0, 0, w, h);
			sp.graphics.endFill();
			
			return sp;
		}
		
		public function disp():void
		{
			setbg();
			setother();
			setmovie();
			setMe();
			mapBox.visible = true;
		}
		
		public function not_disp():void
		{
			mapBox.visible = false;
			for (var i:uint = 0; i < other.length; i++ )
			{
				mapBox.removeChild(other[i]);
			}
			for (i = 0; i < movie.length; i++ )
			{
				mapBox.removeChild(movie[i]);
			}
			mapBox.removeChild(me);
			mapBox.removeChild(bg_map);
		}
		
		private function Resize(e:Event):void
		{
			var w:int = Main.mainStage.stageWidth;
			var h:int = Main.mainStage.stageHeight;

			if (h - 50 > 50)
			{
				bg_map.width = w - 50;
				bg_map.height = h - 50;
				
				me.x = (me.x - bg_map.x - 2) / scale_x;
				me.y = (me.y - bg_map.y - 2) / scale_y;
				
				for (var i:uint = 0; i < other.length; i++ )
				{
					other[i].x = (other[i].x - bg_map.x - 2) / scale_x;
					other[i].y = (other[i].y - bg_map.y - 2) / scale_y;
				}
				
				for (i = 0; i < movie.length; i++ )
				{
					movie[i].x = (movie[i].x - bg_map.x - 2) / scale_x;
					movie[i].y = (movie[i].y - bg_map.y - 2) / scale_y;
				}
				
				scale_x = (bg_map.width - 16) / 255;
				scale_y = (bg_map.height - 16) / 255;
				me.x = bg_map.x + 2 + me.x * scale_x;
				me.y = bg_map.y + 2 + me.y * scale_y;
				
				for (i = 0; i < other.length; i++ )
				{
					other[i].x = bg_map.x + 2 + other[i].x * scale_x;
					other[i].y = bg_map.y + 2 + other[i].y * scale_y;
				}
				
				for (i = 0; i < movie.length; i++ )
				{
					movie[i].x = bg_map.x + 2 + movie[i].x * scale_x;
					movie[i].y = bg_map.y + 2 + movie[i].y * scale_y;
				}
			}
		}
	}
}