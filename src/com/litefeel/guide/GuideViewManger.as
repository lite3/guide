package com.litefeel.guide 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import com.litefeel.guide.events.GuideEvent;
	import com.litefeel.guide.interfaces.IGuideArrow;
	import com.litefeel.guide.interfaces.IGuideDialog;
	import com.litefeel.guide.interfaces.IGuideMasker;
	import com.litefeel.guide.interfaces.IGuideTip;
	import com.litefeel.guide.vo.DialogVo;
	import com.litefeel.guide.vo.GuideStepVo;
	import com.litefeel.guide.vo.MaskerKnockoutType;
	import com.litefeel.guide.vo.Orientation;
	/**
	 * ...
	 * @author lite3
	 */
	public class GuideViewManger
	{
		private var isPrevStep:Boolean;
		private var dialogList:Vector.<DialogVo>;
		
		private var step:GuideStepVo;
		private var arrow:IGuideArrow;
		private var tip:IGuideTip;
		private var stage:Stage;
		private var masker:IGuideMasker;
		private var needShowMasker:Boolean;
		
		public function init(stage:Stage, arrow:IGuideArrow, masker:IGuideMasker, tip:IGuideTip):void
		{
			this.arrow = arrow;
			this.masker = masker;
			this.tip = tip;
			masker.setStage(stage);
			if (tip) tip.setStage(stage);
			this.stage = stage;
			//DisplayObject(masker).addEventListener(MouseEvent.CLICK, ignoreClick, false, int.MAX_VALUE);
			//DisplayObject(arrow).addEventListener(MouseEvent.CLICK, ignoreClick, false, int.MAX_VALUE);
			_init();
		}
		
		//private function ignoreClick(e:MouseEvent):void 
		//{
			//e.stopImmediatePropagation();
		//}
		
		public static var instance:GuideViewManger;
		public static function getInstance():GuideViewManger
		{
			if (!instance) instance = new GuideViewManger(Singleton);
			return instance;
		}
		
		public function GuideViewManger(p:Class) 
		{
			if (p != Singleton) throw new Error("this is single");
		}
		
		private function _init():void 
		{
			//GuideManager.getInstance().addEventListener(GuideEvent.ALL_STEP_FINISH, finishHandler);
			GuideManager.getInstance().addEventListener(GuideEvent.STEP_ALL_FINISH, stepAllFinishHandler);
			GuideManager.getInstance().addEventListener(GuideEvent.STEP_RESET, stepResetHandler);
			GuideManager.getInstance().addEventListener(GuideEvent.STEP_START, stepStartHandler);
			GuideManager.getInstance().addEventListener(GuideEvent.STEP_REMOVE, stepAllFinishHandler);
			//GuideManager.getInstance().addEventListener(GuideEvent.STEP_BEFORE, stepBeforeHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function resizeHandler(e:Event):void 
		{
			setTimeout(function():void
			{
				if (masker && masker.showing) masker.show();
				if (arrow && arrow.showing) showArrow();
			}, 2000);
		}
		
		private function stepStartHandler(e:GuideEvent):void 
		{
			if (e.guide.hasMasker) masker.show();
			else masker.remove();
		}
		
		private function stepAllFinishHandler(e:GuideEvent):void 
		{
			clearStep();
			masker.remove();
		}
		
		//private function stepBeforeHandler(e:GuideEvent):void 
		//{
			//dialogIndex = -1;
			//dialogList = GuideManager.getInstance().getStepBeforeDialogList();
			//showNextDialog();
		//}
		
		private function stepResetHandler(e:GuideEvent):void 
		{
			needShowMasker = e.guide && e.guide.hasMasker;
			if (needShowMasker) masker.show();
			var newStep:GuideStepVo = GuideManager.getInstance().getCurrGuideStep();
			if (newStep && !newStep.isRunnig) newStep = null;
			isPrevStep = newStep == step;
			if (step != newStep) clearStep();
			
			step = newStep;
			initStep();
		}
		
		private function clearStep():void 
		{
			if (arrow) arrow.remove();
			if (tip) tip.remove();
			//if (arrow.parent) arrow.parent.removeChild(arrow);
			//if (dialog.parent) dialog.parent.removeChild(dialog);
			step = null;
			GuideDialogManager.getInstance().clearAllDialog();
		}
		
		private function initStep():void 
		{
			if (!step)
			{
				clearStep();
				return;
			}
			if(needShowMasker) masker.show();
			
			if (!isPrevStep)
			{
				dialogList = step.dialogList;
				showDialog();
			}
		}
		
		public function hideMasker():void
		{
			masker.visible = false;
		}
		
		public function showMasker():void
		{
			masker.visible = true;
		}
		
		public function showArrow():void
		{
			if (!step) return;
			
			var actTips:*;
			var container:DisplayObjectContainer;
			if (step.actTips != null)
			{
				try {
					actTips = step.actTips();
					if(actTips != null) container = step.container();
				}catch (err:Error) { showErr(err); }
			}
			
			if (container)
			{
				var p:Point;
				var radius:int;
				var rect:Rectangle;
				if (actTips is DisplayObject)
				{
					rect = DisplayObject(actTips).getRect(stage);
					p = new Point(rect.x + rect.width / 2, rect.y + rect.height / 2);
					radius = step.radius > 0 ? step.radius : (Math.min(rect.width, rect.height) / 2);
					//radius = 200;
				}else if (("x" in actTips) && ("y" in actTips))
				{
					if (("width" in actTips) && ("height" in actTips))
					{
						rect = new Rectangle(actTips.x, actTips.y, actTips.width, actTips.height);
						p = new Point(rect.x + rect.width / 2, rect.y + rect.height / 2);
						radius = step.radius > 0 ? step.radius : (Math.min(rect.width, rect.height) / 2);
					} else if (("radius" in actTips) && ("x" in actTips) && ("y" in actTips))
					{
						p = new Point(actTips.x, actTips.y);
						radius = step.radius > 0 ? step.radius : actTips.radius;
						rect = new Rectangle(p.x - radius, p.y - radius, radius * 2, radius * 2);
					}else
					{
						p = new Point(actTips.x, actTips.y);
						radius = step.radius;
					}
				}else
				{
					return;
				}
				
				p.x += step.offsetX;
				p.y += step.offsetY;
				
				if (needShowMasker)
				{
					if (rect && MaskerKnockoutType.RECTANGLE == step.knockout)
					{
						var px:int, py:int, pw:int, ph:int;
						if (step.radius > 0)
						{
							//px.w
						}
						masker.showHasRect(rect.x + step.offsetX, rect.y + step.offsetY, rect.width, rect.height);
					}else
					{
						masker.showHasCircle(p.x, p.y, radius);
					}
				}
				
				if (tip && step.tip) tip.showAt(step.tip, p.x, p.y - radius);
				
				if (step.arrowOffsetX != 0 || step.arrowOffsetY != 0)
				{
					if (Orientation.AUTO == step.orientation)
					{
						step.orientation = Orientation.BOTTOM;
					}
					p.x += step.arrowOffsetX;
					p.y += step.arrowOffsetY;
				}
				
				if (Orientation.AUTO == step.orientation)
				{
					var stageW:int = stage.stageWidth;
					var stageH:int = stage.stageHeight;
					
					var arr:Vector.<int> = new <int>[0, stage.stageHeight - p.y - radius, p.x + radius, p.y + radius, stage.stageWidth - p.x - radius];
					var n:Number = Math.min(arr[1], arr[2], arr[3], arr[4]);
					if (n > 150)
					{
						step.orientation = Orientation.BOTTOM;
					}else
					{
						step.orientation = arr.indexOf(n, 1);
					}
				}
				
				switch(step.orientation)
				{
					case Orientation.LEFT	: p.x += radius; break;
					case Orientation.TOP	: p.y += radius; break;
					case Orientation.RIGHT	: p.x -= radius; break;
					case Orientation.BOTTOM	: p.y -= radius; break;
				}
				
				p = container.globalToLocal(p);
				arrow.showAt(p.x, p.y, step.orientation, container);
			}
		}
		
		/**
		 * 显示高亮
		 */
		public function showHighlighting():void
		{
			if (!step || !needShowMasker) return;
			
			var actTips:*;
			var container:DisplayObjectContainer;
			try {
				actTips = step.actTips();
				container = step.container();
			}catch (err:Error) { showErr(err); }
			
			if (actTips && container)
			{
				var p:Point;
				var radius:int;
				if (actTips is DisplayObject)
				{
					var rect:Rectangle = DisplayObject(actTips).getRect(stage);
					p = new Point(rect.x + rect.width / 2, rect.y + rect.height / 2);
					radius = step.radius > 0 ? step.radius : Math.min(rect.width, rect.height) / 2;
				}else if(("x" in actTips) && ("y" in actTips))
				{
					p = new Point(actTips.x, actTips.y);
					radius = step.radius;
				}
				masker.showHasCircle(p.x, p.y, radius);
			}
		}
		
		private function showDialog():void 
		{
			if (dialogList && dialogList.length > 0)
			{
				GuideDialogManager.getInstance().showDialogs(dialogList, stage, dialogEndFun);
			}else
			{
				dialogEndFun(dialogList);
			}
		}
		
		private function dialogEndFun(dialogList:Vector.<DialogVo>):void
		{
			if(dialogList == this.dialogList) showArrow();
		}
		
		//private function finishHandler(e:GuideEvent):void 
		//{
			//GuideManager.getInstance().removeEventListener(GuideEvent.ALL_STEP_FINISH, finishHandler);
			//GuideManager.getInstance().removeEventListener(GuideEvent.STEP_RESET, stepResetHandler);
			//clearStep();
		//}
		
	}

}

class Singleton { }