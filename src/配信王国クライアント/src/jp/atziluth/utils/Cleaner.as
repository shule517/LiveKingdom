package jp.atziluth.utils{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	public class Cleaner {
		public static function deleteContainer(
		  _container:DisplayObjectContainer,
		  remainNum:uint=0,
		  toNull:String="String as Null",
		  isReverse:Boolean=false
		):void {
			if (_container == null) {
				return;
			}
			if (isReverse) {
				while (_container.numChildren > remainNum) {
					_container.removeChildAt(_container.numChildren - 1);
				}
			} else {
				while (_container.numChildren > remainNum) {
					_container.removeChildAt(0);
				}
			}
			if (toNull == null) {
				_container = null;
			}
		}
		public static function deleteMovieClip(
		  _mc:MovieClip,
		  remainNum:uint=0,
		  toNull:String="String as Null",
		  isReverse:Boolean=false
		):void {
			if (_mc == null) {
				return;
			}
			if (isReverse) {
				while (_mc.numChildren > remainNum) {
					_mc.removeChildAt(_mc.numChildren - 1);
				}
			} else {
				while (_mc.numChildren > remainNum) {
					_mc.removeChildAt(0);
				}
			}
			if (toNull == null) {
				_mc = null;
			}
		}
		public static function deleteSprite(
		  _sp:Sprite,
		  remainNum:uint=0,
		  toNull:String="String as Null",
		  isReverse:Boolean=false
		):void {
			if (_sp == null) {
				return;
			}
			if (isReverse) {
				while (_sp.numChildren > remainNum) {
					_sp.removeChildAt(_sp.numChildren - 1);
				}
			} else {
				while (_sp.numChildren > remainNum) {
					_sp.removeChildAt(0);
				}
			}
			if (toNull == null) {
				_sp = null;
			}
		}
	}
}