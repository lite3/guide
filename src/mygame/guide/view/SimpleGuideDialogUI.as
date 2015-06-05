package mygame.guide.view
{
	import com.litefeel.guide.vo.DialogVo;
	import guide.view.GuideDialogUI;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class SimpleGuideDialogUI extends GuideDialogUI 
	{
		public var centerY:int;
		
		public function SimpleGuideDialogUI() 
		{
			centerY = txt.y + txt.height / 2;
		}
		
		public function setDialog(vo:DialogVo):void
		{
			txt.htmlText = vo.chat;
			txt.height = txt.textHeight + 4;
			txt.y = centerY - txt.height / 2;
		}
		
	}

}