package LBB
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	
	public class Thumbnail extends Sprite
	{
		public var MovieInfo:MovieClip = new MovieClip();
		public var bg_MovieInfo:Sprite = new Sprite();
		private var thumbnail:Loader = new Loader();
		private var info:LoaderInfo;
		private var ChannelName:TextField = new TextField();
		private var ChannelInfo:TextField = new TextField();
		private var id:String;
		private const DefaultText_name:String = "チャンネル名：";
		private const DefaultText_info:String = "放送内容\n\n";
		
		public function Thumbnail():void
		{
			MovieInfo.visible = false;
			addChild(MovieInfo);
			
			MovieInfo.addEventListener(MouseEvent.MOUSE_OVER, disp);
			MovieInfo.addEventListener(MouseEvent.MOUSE_OUT, not_disp);
		}
		
		private function setMovieInfo(ID:String):void
		{
			id = ID;
			setThumbnail();
		}
		
		private function setThumbnail():void
		{
			var url:URLRequest = new URLRequest("http://shule517.ddo.jp/NetWalk/data/SampleThumbnail.jpg");
			
			thumbnail.load(url);
			thumbnail.x = 20;
			thumbnail.y = 10;
			
			info = thumbnail.contentLoaderInfo;
			info.addEventListener(Event.COMPLETE, changeSize);
		}
		
		private function changeSize(e:Event):void
		{
			thumbnail.width = 120;
			thumbnail.height = 90;
			setText();
		}
		
		private function setText():void
		{
			ChannelName.text = DefaultText_name + "NetWalk";
			//ChannelName.border = true;
			ChannelName.width = 150;
			ChannelName.height = 20;
			ChannelName.x = thumbnail.x + thumbnail.width + 10;
			ChannelName.y = thumbnail.y;
			
			ChannelInfo.text = DefaultText_info + "NetWalk開局記念特別番組\n他では味わえない配信の楽しさがここにはある！！ｗｗ";
			//ChannelInfo.border = true;
			ChannelInfo.width = 300;
			ChannelInfo.height = 60;
			ChannelInfo.x = ChannelName.x;
			ChannelInfo.y = ChannelName.y + ChannelName.height + 10;
			
			setBackGround();
		}
		
		private function setBackGround():void
		{
			bg_MovieInfo = graphic(0x99ffff, 0x99ccff, thumbnail.width + ChannelInfo.width + 30, thumbnail.height + 20, 1);
			MovieInfo.addChild(bg_MovieInfo);
			MovieInfo.addChild(thumbnail);
			MovieInfo.addChild(ChannelName);
			MovieInfo.addChild(ChannelInfo);
		}
		
		private function graphic(color:uint, lineColor:uint, w:int, h:int, a:Number):Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(2, lineColor);
			s.graphics.beginFill(color);
			s.graphics.drawRect(0, 0, w, h);
			s.graphics.endFill();
			s.alpha = a;
			return s;
		}
		
		public function first_disp():void
		{
			setMovieInfo("tes");
		}
		
		private function disp(e:MouseEvent):void
		{
			MovieInfo.visible = true;
		}
		
		private function not_disp(e:MouseEvent):void
		{
			MovieInfo.visible = false;
		}
	}
}