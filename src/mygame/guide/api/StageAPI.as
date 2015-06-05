package mygame.guide.api 
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author lite3
	 */
	public class StageAPI 
	{
		public var stage:Stage
		public function StageAPI(stage:Stage) 
		{
			this.stage = stage;
		}
		
		public function enabled():void { stage.mouseChildren = true; }
		public function disabled():void { stage.mouseChildren = false; }
		
		public function mouseDownEnabled():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stopImmediatePropagation, true);
		}
		
		public function mouseDownDisabled():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stopImmediatePropagation, true, int.MAX_VALUE);
		}
		
		public function clickEnabled():void
		{
			stage.removeEventListener(MouseEvent.CLICK, stopImmediatePropagation, true);
		}
		
		public function clickDisabled():void
		{
			stage.addEventListener(MouseEvent.CLICK, stopImmediatePropagation, true, int.MAX_VALUE);
		}
		
		private function stopImmediatePropagation(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
		}
		
		
		
	}

}