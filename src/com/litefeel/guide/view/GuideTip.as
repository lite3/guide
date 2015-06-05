package com.litefeel.guide.view 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import com.litefeel.guide.interfaces.IGuideTip;
	import guide.view.GuideTipUI;
	/**
	 * ...
	 * @author lite3
	 */
	public class GuideTip extends GuideTipUI implements IGuideTip 
	{
		private var MIN_W:int;
		private var _stage:Stage;
		
		private var txtCenterX:int;
		private var txtCenterY:int;
		private var txtMaxW:int;
		
		public function GuideTip() 
		{
			MIN_W = width;
			//TextFieldUtil.autoSetDefaultFormat(txt);
			mouseChildren = false;
			mouseEnabled = false;
			
			txtMaxW = txt.width;
			txtCenterX = txt.x + txtMaxW / 2;
			txtCenterY = txt.y + txt.height / 2;
		}
		
		/**
		 * 将自己从显示列表里移除
		 */
		public function remove():void
		{
			if (parent) parent.removeChild(this);
			//_stage.removeEventListener(Event.RESIZE, resizeHandler);
		}
		
		/**
		 * 显示一段话
		 * @param	str
		 */
		public function showAt(str:String, px:int, py:int):void
		{
			txt.text = str;
			
			txt.width = txtMaxW;
			if (1 == txt.numLines) txt.width = txt.textWidth + 4;
			txt.height = txt.textHeight + 4;
			txt.x = txtCenterX - txt.width / 2;
			txt.y = txtCenterY - txt.height / 2;
			
			alginXY(px, py, 50);
			
			
			_stage.addChild(this);
			//_stage.addEventListener(Event.RESIZE, resizeHandler);
			//resizeHandler(null);
		}
		
		private function alginXY(px:int, py:int, offsetX:int):void 
		{
			
			var cx:int = _stage.stageWidth / 2;
			if (px > cx)
			{
				this.x = px - offsetX - width;
			}else
			{
				this.x = px +offsetX;
			}
			if (py - height < 5)
			{
				this.y = py;
			}else
			{
				this.y = py - height;
			}
		}
		
		//private function resizeHandler(e:Event):void 
		//{
			//txt.width = txt.textWidth + 4;
			//txt.height = txt.textHeight + 4;
			//bg.width = txt.width + 80 <= MIN_W ? MIN_W : txt.width + 80;
			
			//var centerX:int = _stage.stageWidth >> 1;
			//var centerY:int = _stage.stageHeight >> 1;
			
			//bg.x = centerX;
			//bg.y = centerY;
			//txt.x = centerX - (txt.width >> 1);
			//txt.y = centerY - (txt.height >> 1);
		//}
		
		/**
		 * 设置Stage
		 * @param	stage
		 */
		public function setStage(stage:Stage):void
		{
			_stage = stage;
		}
		
	}

}