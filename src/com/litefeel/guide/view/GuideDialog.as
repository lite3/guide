package com.litefeel.guide.view 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.litefeel.guide.interfaces.IGuideDialog;
	import com.litefeel.guide.utils.AfterCall;
	import com.litefeel.guide.vo.DialogVo;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class GuideDialog extends Sprite implements IGuideDialog
	{
		public static var loopPlaySoundFun:Function;
		public static var stopSoundFun:Function;
		
		private var stageW:int = 0;
		private var stageH:int = 0;
		
		private var box:DisplayObject;
		private var bg:Shape;
		
		private var currShowComplete:Boolean;
		private var showIdx:int = -1;
		private var callback:Function;
		private var list:Vector.<DialogVo>;
		
		//private var effect:TextFieldTools;
		
		public function GuideDialog() 
		{
			bg = createBg();
			addChildAt(bg, 0);
			mouseChildren = false;
			//effect = new TextFieldTools();
			//addEventListener(MouseEvent.CLICK, clickHandler, true, int.MAX_VALUE);
		}
		
		/**
		 * 当对话结束后的回调函数
		 * @param	callback function (vo:DialogVo):void;
		 */
		public function setEndCallback(callback:Function):void
		{
			this.callback = callback;
		}
		/**
		 * 显示对话框
		 * @param	list
		 * @param	container
		 */
		public function showDialog(list:Vector.<DialogVo>, container:DisplayObjectContainer):void
		{
			this.list = list;
			showIdx = -1;
			bg.visible = true;
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			container.addChild(this);
			showNextDialog();
		}
		
		private function showNextDialog():void 
		{
			showIdx++;
			if (showIdx >= list.length)
			{
				clear();
				return;
			}
			
			if (box && box.parent) box.parent.removeChild(box);
			box = list[showIdx].box;
			addChild(box);
			//box.x = list[showIdx].x;
			//box.y = list[showIdx].y;
			currShowComplete = false;
			playSound();
			/*if (list[showIdx].promptlyHandler != null)
			{
				try {
					list[showIdx].promptlyHandler();
				}catch (err:Error) { };
			}*/
			
			box["setDialog"](list[showIdx]);
			
			box["txt"].htmlText = list[showIdx].chat + "";
			showComplete();
		}
		
		private function showComplete():void 
		{
			stopSound();
			/*if (list[showIdx].ignoreBg)
			{
				removedFromStage(null);
				bg.visible = false;
			}*/
			
			/*if (list[showIdx].effectEndHandler != null)
			{
				AfterCall.call(list[showIdx].effectEndHandler);
			}*/
		}
		
		private function playSound():void 
		{
			if (loopPlaySoundFun != null)
			{
				loopPlaySoundFun();
			}
		}
		
		private function stopSound():void
		{
			currShowComplete = true;
			if (stopSoundFun != null)
			{
				stopSoundFun();
			}
		}
		
		public function clear(fireCallback:Boolean = true):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			
			if (parent) parent.removeChild(this);
			
			if (!currShowComplete) stopSound();
			var _list:Vector.<DialogVo> = list;
			var _callback:Function = callback;
			list = null;
			callback = null;
			
			if (fireCallback && _callback != null) _callback();
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			if (!parent) return;
			
			e.stopImmediatePropagation();
			
			
			if (list[showIdx].clickHandler != null)
			{
				AfterCall.call(list[showIdx].clickHandler);
			}
			showNextDialog();
		}
		
		private function addToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			//stage.addEventListener(Event.RESIZE, resizeHandler);
			stage.addEventListener(MouseEvent.CLICK, clickHandler, true, int.MAX_VALUE);
			resizeHandler(null);
		}
		
		private function removedFromStage(e:Event):void
		{
			//stage.removeEventListener(Event.RESIZE, resizeHandler);
			stage.removeEventListener(MouseEvent.CLICK, clickHandler, true);
		}
		
		private function resizeHandler(e:Event):void 
		{
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
		}
		
		private function createBg():Shape 
		{
			var sp:Shape = new Shape();
			sp.graphics.beginFill(0x0, 0);
			sp.graphics.drawRect(0, 0, 100, 100);
			sp.graphics.endFill();
			return sp;
		}
		
	}

}