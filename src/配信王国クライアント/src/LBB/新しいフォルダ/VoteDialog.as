package LBB
{ 
    import flash.display.Sprite; 
    import flash.events.Event; 
    import flash.events.MouseEvent; 
    
    import org.aswing.ASColor; 
    import org.aswing.AbstractButton; 
    import org.aswing.BorderLayout; 
    import org.aswing.BoxLayout; 
    import org.aswing.ButtonGroup; 
    import org.aswing.FlowLayout; 
    import org.aswing.GridLayout; 
    import org.aswing.Insets; 
    import org.aswing.JButton; 
    import org.aswing.JFrame; 
    import org.aswing.JLabel; 
    import org.aswing.JOptionPane; 
    import org.aswing.JPanel; 
    import org.aswing.JRadioButton; 
    import org.aswing.SoftBoxLayout; 
    import org.aswing.border.EmptyBorder; 
    import org.aswing.border.LineBorder; 
    import org.aswing.event.AWEvent; 
    import org.aswing.geom.IntDimension; 
    
    public class VoteDialog extends UpDownFrame
    { 
        
        protected var frame : JFrame;
        
        public function VoteDialog(){ 
            super(); 
            createUI(); 
        } 
        
        private function createUI() : void{ 
            frame = new JFrame(Up_mc, "VoteDialog");
			//ドラッグ有無
			frame.setDragable(false);
			//サイズ変更の有無
			frame.setResizable(true);
			//削除の有無
			frame.setClosable(true);
			frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

			frame.x = Up_bg.x;
			frame.y = Up_bg.y;
			frame.width = Up_bg.width;
			frame.height = Up_bg.height;
            //frame.pack(); 
			
            frame.show(); 
        }

/*		override protected function Resize():void
		{
			super.Resize();
			frame.width = Up_bg.width;
			frame.x = Up_bg.x;
		}
		
		override protected function UpDownFrame_Resize():void
		{
			super.UpDownFrame_Resize();
			frame.height = Up_bg.height;
			frame.y = Up_bg.y;
		}*/
	}
}