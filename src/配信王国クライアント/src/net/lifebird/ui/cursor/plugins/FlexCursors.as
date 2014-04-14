package net.lifebird.ui.cursor.plugins 
{
	import net.lifebird.ui.cursor.Cursors;
	import net.lifebird.ui.cursor.CursorType;
	import net.lifebird.ui.cursor.CursorPosition;
	
	/**
	 * Flex用カーソル一括設定プラグイン
	 * @author yuu
	 */
	public class FlexCursors
	{
		[Embed(source = "cursor/crosshair.png")]
		private static var Cross:Class;
		[Embed(source = "cursor/help.png")]
		private static var Help:Class;
		[Embed(source = "cursor/h-resize.png")]
		private static var HResize:Class;
		[Embed(source = "cursor/v-resize.png")]
		private static var VResize:Class;
		[Embed(source = "cursor/move.png")]
		private static var Move:Class;
		[Embed(source = "cursor/pointer.png")]
		private static var Pointer:Class;
		[Embed(source = "cursor/sl-resize.png")]
		private static var SLResize:Class;
		[Embed(source = "cursor/sr-resize.png")]
		private static var SRResize:Class;
		[Embed(source = "cursor/text.png")]
		private static var Text:Class;
		[Embed(source = "cursor/wait.png")]
		private static var Wait:Class;
		[Embed(source = "cursor/zoomin.png")]
		private static var ZoomIn:Class;
		[Embed(source = "cursor/zoomout.png")]
		private static var ZoomOut:Class;
		[Embed(source = "cursor/hand.png")]
		private static var Hand:Class;
		[Embed(source = "cursor/grip.png")]
		private static var Grip:Class;
		public function FlexCursors();
		public static function Set():void {
			Cursors.addCursor(CursorType.CROSS_HAIR, new Cross(), CursorPosition.TOP_LEFT);
			Cursors.addCursor(CursorType.HELP, new Help(), CursorPosition.TOP_LEFT);
			Cursors.addCursor(CursorType.H_RESIZE, new HResize(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.V_RESIZE, new VResize(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.MOVE, new Move(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.POINTER, new Pointer(), CursorPosition.TOP);
			Cursors.addCursor(CursorType.SL_RESIZE, new SLResize(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.SR_RESIZE, new SRResize(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.TEXT, new Text(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.WAIT, new Wait(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.ZOOM_IN, new ZoomIn(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.ZOOM_OUT, new ZoomOut(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.HAND, new Hand(), CursorPosition.CENTER);
			Cursors.addCursor(CursorType.GRIP, new Grip(), CursorPosition.CENTER);
		}
	}
}