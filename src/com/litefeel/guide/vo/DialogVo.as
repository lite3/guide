package com.litefeel.guide.vo 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author lite3
	 */
	public class DialogVo
	{
		public var showedCount:int = 0;
		/** 说话的内容 */
		public var chat:String;
		/** 立刻执行的脚本 */
		public var promptlyHandler:Function;
		/** 点击后执行的代码 */
		public var clickHandler:Function;
		/** 效果完成后的代码 */
		public var effectEndHandler:Function;
		
		/** 0:左边  1:右边 */
		public var pos:int;
		
		public var x:int;
		public var y:int;
		public var ignoreBg:Boolean;
		
		/** 对话框的类名 */
		public var box:DisplayObject;
		/** 头像id */
		public var avatar:String;
		
		/** 说话时的状态标签 */
		public var label:String;
		
		
		public function DialogVo(chat:String, pos:int, box:DisplayObject, label:String, clickHandler:Function, promptlyHandler:Function) 
		{
			this.chat = chat;
			this.pos = pos;
			this.box = box;
			this.label = label;
			this.chat = chat;
			this.clickHandler = clickHandler;
			this.promptlyHandler = promptlyHandler;
		}
		
	}

}