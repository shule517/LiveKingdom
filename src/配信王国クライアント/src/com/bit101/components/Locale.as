package com.bit101.components
{
	import flash.text.TextFormat;
	
	/**
	 * 言語の設定
	 * @author Hikipuro
	 */
	public class Locale 
	{
		static private var _language:String = "en";
		
		public static function set language(value:String):void 
		{
			switch (value) 
			{
				case "ja":
					_language = value;
					break;
				default:
					_language = "en";
					break;
			}
		}
		
		public static function get language():String
		{
			return _language;
		}
		
		public static function getTextFormat():TextFormat
		{
			switch (_language) 
			{
				case "ja":
					return new TextFormat(null, 9, Style.LABEL_TEXT);
			}
			return  new TextFormat("PF Ronda Seven", 8, Style.LABEL_TEXT);
		}
		
		public static function isEmbedFonts():Boolean
		{
			switch (_language) 
			{
				case "ja":
					return false;
			}
			return true;
		}
		
	}
	
}