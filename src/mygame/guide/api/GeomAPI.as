package mygame.guide.api 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	/**
	 * ...
	 * @author lite3
	 */
	public class GeomAPI 
	{
		
		public function getGlobalPoint(display:DisplayObject):Point 
		{
			return display.localToGlobal(new Point(0, 0));
		}
		
	}

}