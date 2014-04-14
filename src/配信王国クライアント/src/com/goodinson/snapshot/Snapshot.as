package com.goodinson.snapshot
{
	import com.goodinson.snapshot.*;
	import com.adobe.images.*;
	import com.dynamicflash.util.Base64;
	import flash.display.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.ByteArray;

	public class Snapshot
	{
		// supported image file types
		public static const JPG:String = "jpg";
		public static const PNG:String = "png";
		
		// supported server-side actions
		public static const DISPLAY:String = "display";
		public static const PROMPT:String = "prompt";
		public static const LOAD:String = "load";
		
		// default parameters
		private static const JPG_QUALITY_DEFAULT:uint = 80;
		private static const PIXEL_BUFFER:uint = 1;
		private static const DEFAULT_FILE_NAME:String = 'snapshot';
		
		// path to server-side script
		public static var gateway:String;
		
		public static function capture(target:DisplayObject, options:Object):void
		{
			var relative:DisplayObject = target.parent;
			
			// get target bounding rectangle
			var rect:Rectangle = target.getBounds(relative);
			
			// capture within bounding rectangle; add a 1-pixel buffer around the perimeter to ensure that all anti-aliasing is included
			var bitmapData:BitmapData = new BitmapData(rect.width + PIXEL_BUFFER * 2, rect.height + PIXEL_BUFFER * 2);
			
			// capture the target into bitmapData
			bitmapData.draw(relative, new Matrix(1, 0, 0, 1, -rect.x + PIXEL_BUFFER, -rect.y + PIXEL_BUFFER));
			
			// encode image to ByteArray
			var byteArray:ByteArray;
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
		}
	}
}