package shule 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.media.Video;
	import com.adobe.images.JPGEncoder;
	import flash.utils.ByteArray;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequest;
	import com.dynamicflash.util.Base64;
	import flash.net.*;

	/**
	 * ...
	 * @author shule
	 */
	public class Capture
	{
		static public function up(video:Video):void
		{
			var bitmapData:BitmapData = new BitmapData(video.width, video.height);
			bitmapData.draw(video);
			
			// encode as JPG
			const JPG_QUALITY_DEFAULT:uint = 80;
			var jpgEncoder:JPGEncoder = new JPGEncoder(JPG_QUALITY_DEFAULT);
			var byteArray:ByteArray = jpgEncoder.encode(bitmapData);
			
			var byteArrayAsString:String = Base64.encodeByteArray(byteArray);

			/*
			// constuct server-side URL to which to send image data
			var url:String = gateway + '?' + Math.random();
			
			// determine name of file to be saved / displayed
			var fileName:String = DEFAULT_FILE_NAME + '.' + options.format;
		*/
		
			// create URL request
			var request:URLRequest = new URLRequest("http://shule517.ddo.jp/NetWalk/snapshot.php?0.9116714964620769");
			
			// send data via POST method
			request.method = URLRequestMethod.POST;
			
			// set data to send
			var variables:URLVariables = new URLVariables();
			variables.format = "jpg";
			variables.action = "prompt";
			variables.fileName = Main.myID + ".jpg";
			variables.image = byteArrayAsString;
			request.data = variables;

			try
			{
				var loader:Loader = new Loader();
				loader.load(request);
			}
			catch(e:Error)
			{
				
			}
			
			//navigateToURL(request, "_blank");

			/*
			if (options.action == LOAD)
			{
				// load image back into loadContainer
				options.loader.load(request);
				
			} else
			{
				navigateToURL(request, "_blank");
			}
			
			/*
			switch (options.format)
			{
				case JPG:
				// encode as JPG
				var jpgEncoder:JPGEncoder = new JPGEncoder(JPG_QUALITY_DEFAULT);
				byteArray = jpgEncoder.encode(bitmapData);
				break;
				
				case PNG:
				default:
				// encode as PNG
				byteArray = PNGEncoder.encode(bitmapData);
				break;
			}
			
			// convert binary ByteArray to plain-text, for transmission in POST data
			var byteArrayAsString:String = Base64.encodeByteArray(byteArray);

			// constuct server-side URL to which to send image data
			var url:String = gateway + '?' + Math.random();
			
			// determine name of file to be saved / displayed
			var fileName:String = DEFAULT_FILE_NAME + '.' + options.format;
			
			// create URL request
			var request:URLRequest = new URLRequest(url);
			
			// send data via POST method
			request.method = URLRequestMethod.POST;
			
			// set data to send
			var variables:URLVariables = new URLVariables();
			variables.format = options.format;
			variables.action = options.action;
			variables.fileName = fileName;
			variables.image = byteArrayAsString;
			request.data = variables;
			
			if (options.action == LOAD)
			{
				// load image back into loadContainer
				options.loader.load(request);
				
			} else
			{
				navigateToURL(request, "_blank");
			}
			*/
		}
	}
}
