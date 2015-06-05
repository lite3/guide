package mygame.guide.api 
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import com.litefeel.guide.GuideManager;
	import com.litefeel.guide.veal.RuntimeUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class WaitAPI 
	{
		private var step:String;
		private var timeHandler:int;
		
		public function wait(step:String, ...exp):void 
		{
			this.step = step;
			clearInterval(timeHandler);
			
			timeHandler = setInterval(test, 500, exp);
			setTimeout(test, 0, exp);
		}
		
		private function test(list:Array):void 
		{
			try{
				for (var i:int = 0; i < list.length; i++)
				{
					var result:Boolean = true;
					if (list[i] is Function)
					{
						result = list[i]();
					}else
					{
						result = RuntimeUtil.getValue(list[i]);
					}
					if (!result) return;
				}
				clearInterval(timeHandler);
				GuideManager.getInstance().gotoGuideStepById(step);
			}catch (err:Error) { }
		}
		
	}

}