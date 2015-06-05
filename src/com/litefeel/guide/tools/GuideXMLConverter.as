package com.litefeel.guide.tools 
{
	import com.litefeel.guide.vo.DialogVo;
	import com.litefeel.guide.vo.GuideFinishVo;
	import com.litefeel.guide.vo.GuideStepVo;
	import com.litefeel.guide.vo.GuideVo;
	import com.litefeel.guide.vo.MaskerKnockoutType;
	import com.litefeel.guide.vo.MouseEventVo;
	import com.litefeel.guide.veal.RuntimeUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class GuideXMLConverter
	{
		
		static public var autoAddIgnoreMouse:Boolean = false;
		
		static public function getStepBeforeDialogList(xml:XML):Vector.<DialogVo>
		{
			return createDialogList(xml.stepBeforeDialogList.dialog);
		}
		
		static public function convectToGuideList(xml:XML):Vector.<GuideVo>
		{
			var list:XMLList = xml.guide;
			var len:int = list.length();
			var stepList:Vector.<GuideVo> = new Vector.<GuideVo>(len, true);
			for (var i:int = 0; i < len; i++)
			{
				stepList[i] = createGuide(list[i]);
			}
			return stepList;
		}
		
		static public function createGuide(xml:XML):GuideVo 
		{
			var finishList:XMLList = xml.stepFinishList.stepFinish;
			var prevStepList:Vector.<GuideStepVo> = createStepStepList(xml.prevStepList.stepStep);
			var nextStepList:Vector.<GuideStepVo> = createStepStepList(xml.nextStepList.stepStep);
			var stepFinishList:Vector.<GuideFinishVo> = createStepFinishList(xml.stepFinishList.stepFinish);
			return  new GuideVo(xml.@id, xml.@name, "true" == xml.@hasMasker, prevStepList, stepFinishList, nextStepList);
		}
		
		static private function createStepStepList(xmlList:XMLList):Vector.<GuideStepVo> 
		{
			var len:int = xmlList != null ? xmlList.length() : 0;
			if (0 == len) return null;
			
			var list:Vector.<GuideStepVo> = new Vector.<GuideStepVo>(len, true);
			for (var i:int = 0; i < len; i++)
			{
				list[i] = createStepStep(xmlList[i], i);
			}
			return list;
		}
		
		static private function createStepStep(xml:XML, idx:int):GuideStepVo 
		{
			var vo:GuideStepVo = new GuideStepVo(
				createExprList(xml.addList.expr),
				createExprList(xml.orList.expr),
				createDialogList(xml.dialogList.dialog),
				getStr(xml.actTips) ? RuntimeUtil.getValueFun(getStr(xml.actTips)) : null,
				getStr(xml.container) ? RuntimeUtil.getValueFun(getStr(xml.container)) : null
			);
			
			vo.id = xml.@id || idx + "";
			vo.tip = xml.tip;
			vo.offsetX = xml.offsetX;
			vo.offsetY = xml.offsetY;
			vo.arrowOffsetX = xml.arrowOffsetX;
			vo.arrowOffsetY = xml.arrowOffsetY;
			vo.radius  = xml.radius;
			vo.knockout = int(getStr(xml.knockout));
			if (vo.knockout != 0 && vo.knockout != 1) vo.knockout = 0;
			vo.orientation  = xml.orientation;
			if (getStr(xml.promptlyHandler)) vo.promptlyHandler = RuntimeUtil.getValueFun(getStr(xml.promptlyHandler));
			if (getStr(xml.clickHandler)) vo.clickHandler = RuntimeUtil.getValueFun(getStr(xml.clickHandler));
			vo.toNextMouseList = createMouseList(xml.toNextMouseList.mouseEvent, false);
			vo.ignoreMouseList = createMouseList(xml.ignoreMouseList.mouseEvent, autoAddIgnoreMouse && vo.toNextMouseList != null);
			
			var attList:XMLList = xml.testVars.@*;
			var len:int = attList.length();
			if (len > 0)
			{
				var o:Object = { };
				for (var i:int = 0; i < len; i++)
				{
					var key:String = attList[i].name();
					var value:String = xml.testVars.attribute(key);
					o[key] = value;
				}
				vo.testVars = o;
			}
			return vo;
		}
		
		static private function createMouseList(xmlList:XMLList, autoAddMouse:Boolean):Vector.<MouseEventVo> 
		{
			var list:Vector.<MouseEventVo> = null;
			var len:int = xmlList != null ? xmlList.length() : 0;
			if (0 == len)
			{
				if (autoAddMouse)
				{
					list = new Vector.<MouseEventVo>(1, true);
					list[0] = new MouseEventVo('click', function():* { return null; }, null);
				}
				return list;
			}
			
			list = new Vector.<MouseEventVo>(len, true);
			for (var i:int = 0; i < len; i++)
			{
				var type:String = "mouseDown" == getStr(xmlList[i].type) ? "mouseDown" : "click";
				var target:String = xmlList[i].target;
				var handler:String = xmlList[i].handler;
				list[i] = new MouseEventVo(
					type,
					target ? RuntimeUtil.getValueFun(target) : null,
					handler ? RuntimeUtil.getValueFun(handler) : null
				);
			}
			return list;
		}
		
		static private function createDialogList(xmlList:XMLList):Vector.<DialogVo> 
		{
			var len:int = xmlList != null ? xmlList.length() : 0;
			if (0 == len) return null;
			
			var list:Vector.<DialogVo> = new Vector.<DialogVo>(len, true);
			for (var i:int = 0; i < len; i++)
			{
				var label:String = xmlList[i].label;
				var clickHandler:String = xmlList[i].clickHandler;
				var promptlyHandler:String = xmlList[i].promptlyHandler;
				var boxStr:String = xmlList[i].@box;
				if (!boxStr) boxStr = "{defaultBox}";
				list[i] = new DialogVo(xmlList[i].chat, xmlList[i].pos, 
						RuntimeUtil.getValue(boxStr),
						!label ? "普通" : label, 
						clickHandler ? RuntimeUtil.getValueFun(clickHandler) : null,
						promptlyHandler ? RuntimeUtil.getValueFun(promptlyHandler) : null);
				list[i].x = xmlList[i].@x;
				list[i].y = xmlList[i].@y;
				list[i].avatar = xmlList[i].@avatar;
				if (!list[i].avatar) list[i].avatar = "130011";
				list[i].ignoreBg = xmlList[i].@ignoreBg == "true";
				var effectEndHandler:String = getStr(xmlList[i].effectEndHandler);
				if (effectEndHandler) list[i].effectEndHandler = RuntimeUtil.getValueFun(effectEndHandler);
			}
			return list;
		}
		
		static private function createStepFinishList(xmlList:XMLList):Vector.<GuideFinishVo> 
		{
			var len:int = xmlList != null ? xmlList.length() : 0;
			if (0 == len) return null;
			
			var list:Vector.<GuideFinishVo> = new Vector.<GuideFinishVo>(len, true);
			for (var i:int = 0; i < len; i++)
			{
				list[i] = new GuideFinishVo(
					xmlList[i].type, 
					createExprList(xmlList[i].addList.expr),
					createExprList(xmlList[i].orList.expr)
				);
			}
			return list;
		}
		
		static private function createExprList(xmlList:XMLList):Vector.<String>  
		{
			var len:int = xmlList != null ? xmlList.length() : 0;
			if (0 == len) return null;
			
			var list:Vector.<String> = new Vector.<String>(len, true);
			for (var i:int = 0; i < len; i++)
			{
				list[i] = xmlList[i];
				if ("" == list[i]) list[i] = "true";
			}
			return list;
		}
		
		static private function getStr(xml:XMLList):String
		{
			if (null == xml) return null;
			if ("" == xml.toString()) return null;
			return xml.toString();
		}
		
	}

}