package mygame.guide.commands 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author lite3
	 */
	public class UpdateGuideCommand
	{
		/**
		 * 像后端更新引导步骤
		 * @param	guideId 引导id
		 * @param	stepId  引导的步骤id, success表示该引导结束
		 */
		public function update(guideId:String, stepId:String = "success"):void
		{
			// 向向后端更新引导步骤
			//var by:GameByteArray = new GameByteArray();
			//by.writeString(guideId);
			//by.writeString(stepId);
			//send(14030, by);
			//
			//if ("success" == stepId)
			//{
				//UserData.curGuide = "";
				//UserData.curStep = "";
				//var idx:int = UserData.guideList.indexOf(guideId);
				//if (idx >= 0) UserData.guideList.splice(idx, 1);
			//}
		}
	}
}