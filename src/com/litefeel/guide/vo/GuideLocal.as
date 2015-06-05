package com.litefeel.guide.vo 
{
	/**
	 * ...
	 * @author lite3
	 */
	public class GuideLocal 
	{
		private const o:Object = { };
		public function get(key:String):* { return o[key]; }
		public function set(key:String, value:*):void
		{
			o[key] = value;
		}
		
		public function empty():void
		{
			for (var key:String in o)
			{
				delete o[key];
			}
		}
		
	}

}