package net.lifebird.ui.cursor.plugins 
{
	import net.lifebird.ui.cursor.Cursors;
	import net.lifebird.ui.cursor.CursorType;
	import net.lifebird.ui.cursor.CursorPosition;
	
	
	/**
	 * CS用カーソル一括設定プラグイン
	 * @author yuu
	 */
	public class CSCursors {
		public function CSCursors();
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