package com.litefeel.guide.interfaces 
{
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author lite3
	 */
	public interface IGuideTip 
	{
		/**
		 * 将自己从显示列表里移除
		 */
		function remove():void;
		
		/**
		 * 显示一段话
		 * @param	str
		 */
		function showAt(str:String, px:int, py:int):void;
		
		/**
		 * 设置Stage
		 * @param	stage
		 */
		function setStage(stage:Stage):void;
	}
	
}