package com.litefeel.guide.interfaces 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 指引的箭头
	 * @author lite3
	 */
	public interface IGuideArrow 
	{
		
		/** 是否正在显示 */
		function get showing():Boolean;
		
		/**
		 * 在某点显示
		 * @param	x 在container中的x坐标
		 * @param	y 在container中的y坐标
		 * @param	orientation 箭头的方向
		 * @param	container 要显示到的容器
		 */
		function showAt(x:int, y:int, orientation:int, container:DisplayObjectContainer):void;
		
		/**
		 * 从显示列表中移除自己
		 */
		function remove():void;
	}
	
}