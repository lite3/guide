package com.litefeel.guide.view 
{
	import flash.display.DisplayObjectContainer;
	import com.litefeel.guide.interfaces.IGuideArrow;
	import guide.view.GuideArrowUI;
	
	/**
	 * 指引用的箭头
	 * @author lite3
	 */
	public class GuideArrow extends GuideArrowUI implements IGuideArrow
	{
		
		public function GuideArrow() 
		{
			mouseEnabled = false;
			mouseChildren = false;
			stop();
		}
		
		/** 是否正在显示 */
		public function get showing():Boolean { return parent != null; }
		
		/**
		 * 在某点显示
		 * @param	x 在container中的x坐标
		 * @param	y 在container中的y坐标
		 * @param	orientation 箭头的方向
		 * @param	container 要显示到的容器
		 */
		public function showAt(x:int, y:int, orientation:int, container:DisplayObjectContainer):void
		{
			this.x = x;
			this.y = y;
			if(parent != container) container.addChild(this);
			play();
			
			this.rotation = (orientation - 1) * 90;
		}
		
		/**
		 * 从显示列表中移除自己
		 */
		public function remove():void
		{
			if (parent)
			{
				parent.removeChild(this);
				stop();
			}
		}
		
	}

}