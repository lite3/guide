package mygame.guide.api 
{
	import mygame.guide.commands.UpdateGuideCommand;
	/**
	 * ...
	 * @author lite3
	 */
	public class CommandAPI 
	{
		
		public function finishGuide():void 
		{
			//new FinishGuideCommand().finishGuide();
		}
		
		public function updateStep(guide:String, step:String = "success"):void
		{
			new UpdateGuideCommand().update(guide, step);
		}
		
	}

}