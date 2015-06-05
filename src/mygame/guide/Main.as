package mygame.guide
{
	import com.litefeel.guide.veal.RuntimeUtil;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.setTimeout;
	import com.litefeel.guide.events.GuideEvent;
	import com.litefeel.guide.GuideDialogManager;
	import com.litefeel.guide.GuideManager;
	import com.litefeel.guide.GuideViewManger;
	import com.litefeel.guide.tools.GuideListUtil;
	import com.litefeel.guide.view.GuideArrow;
	import com.litefeel.guide.view.GuideDialog;
	import com.litefeel.guide.view.GuideMasker;
	import com.litefeel.guide.view.GuideTip;
	import com.litefeel.guide.vo.GuideLocal;
	import mygame.guide.api.CommandAPI;
	import mygame.guide.api.GeomAPI;
	import mygame.guide.api.GuideHelper;
	import mygame.guide.api.StageAPI;
	import mygame.guide.api.WaitAPI;
	import mygame.guide.view.SimpleGuideDialogUI;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class Main extends Sprite 
	{
		public var xml:XML;
		include "../../guide/guide.as"
		
		
		private var mainDataOk:Boolean;
		private var guideDataOk:Boolean;
		private var eventManager:IEventDispatcher;
		
		public function Main():void 
		{
			initXML();
			
			// 设置 eventManager
			//eventManager = EventManager.getInstance();
			
			// 启动引导
			//if (UserData.uId)
			//{
				//mainDataComplete(null);
			//}else
			//{
				//eventManager.addEventListener(GameEvent.INIT_USER_COMPLETE, mainDataComplete);
			//}
			
			//eventManager.addEventListener(MainEvent.MAIN_DATA_COMPELTE, mainDataComplete);
		}
		
		private function mainDataComplete(e:Event):void
		{
			//EventManager.removeEventListener(GameEvent.INIT_USER_COMPLETE, mainDataComplete);
			//EventManager.removeEventListener(MainEvent.MAIN_DATA_COMPELTE, mainDataComplete);
			//mainDataOk = true;
			
			// piantouReady 片头结束了
			//if (PublicDomain.getInstance().getVar("piantouReady"))
			//{
				init(null);
			//}else
			//{
				//DataManager.stage.addEventListener("piantouReady", init);
			//}
		}
		
		//private function guideDataComplete():void 
		//{
			//guideDataOk = true;
			//init(null);
		//}
		
		private function init(e:Event):void 
		{
			//DataManager.stage.removeEventListener("piantouReady", init);
			//if (DataManager.getInstance().currentUser.uid != "10258") return;
			//if (!guideDataOk || !mainDataOk) return;
			
			//GuideListUtil.setXMLString(DataManager.getInstance().initStaticData.guideStatic);
			//delete DataManager.getInstance().initStaticData.guideStatic;
			
			//if (UserData.uId.toNumber() != 10081) return;
			var helper:GuideHelper = new GuideHelper();
			var command:CommandAPI = new CommandAPI();
			//var funcFilter:FunctionFilterAPI = new FunctionFilterAPI();
			var stageApi:StageAPI = new StageAPI(stage);
			
			var guideLocal:GuideLocal = new GuideLocal();
			RuntimeUtil.getBaseParamMap().addParam("__guideLocal", guideLocal);
			RuntimeUtil.getBaseParamMap().addParam("setVar", guideLocal.set);
			RuntimeUtil.getBaseParamMap().addParam("getVar", guideLocal.get);
			
			RuntimeUtil.getBaseParamMap().addParam("defaultBox", new SimpleGuideDialogUI());
			RuntimeUtil.getBaseParamMap().addParam("updateGuide", command.updateStep);
			//RuntimeUtil.getBaseParamMap().addParam("sendStep", command.updateStep);
			RuntimeUtil.getBaseParamMap().addParam("curStep", GuideManager.getInstance().getCurrGuideStepIdx);
			RuntimeUtil.getBaseParamMap().addParam("delayCall", helper.delayCall);
			RuntimeUtil.getBaseParamMap().addParam("stage", stage);
			RuntimeUtil.getBaseParamMap().addParam("helper", helper);
			RuntimeUtil.getBaseParamMap().addParam("showArrow", helper.showArrow);
			RuntimeUtil.getBaseParamMap().addParam("if", helper.ifThenElse);
			RuntimeUtil.getBaseParamMap().addParam("switch", helper.switchCase);
			RuntimeUtil.getBaseParamMap().addParam("goto", helper.gotoStep);
			RuntimeUtil.getBaseParamMap().addParam("gotoGuide", function(guideId:String):void { GuideListUtil.startGuide(guideId); } );
			//RuntimeUtil.getBaseParamMap().addParam("unlock", funcFilter.unlock);
			//RuntimeUtil.getBaseParamMap().addParam("hasLock", funcFilter.hasLock);
			RuntimeUtil.getBaseParamMap().addParam("wait", new WaitAPI().wait);
			RuntimeUtil.getBaseParamMap().addParam("stageEnabled", stageApi.enabled);
			RuntimeUtil.getBaseParamMap().addParam("stageDisabled", stageApi.disabled);
			RuntimeUtil.getBaseParamMap().addParam("mouseDownEnabled", stageApi.mouseDownEnabled);
			RuntimeUtil.getBaseParamMap().addParam("mouseDownDisabled", stageApi.mouseDownDisabled); 
			RuntimeUtil.getBaseParamMap().addParam("clickEnabled", stageApi.clickEnabled); 
			RuntimeUtil.getBaseParamMap().addParam("clickDisabled", stageApi.clickDisabled); 
			RuntimeUtil.getBaseParamMap().addParam("addEventShowGuide", addEventShowGuide);
			RuntimeUtil.getBaseParamMap().addParam("geom", new GeomAPI());
			
			// 更多的对主程序或模块的访问需要添加更多的Proxy(XXXAPI)
			
			GuideManager.getInstance().init(eventManager, stage);
			GuideManager.getInstance().addEventListener(GuideEvent.STEP_START, guideEventHandler);
			GuideManager.getInstance().addEventListener(GuideEvent.STEP_ALL_FINISH, guideEventHandler);
			var arrow:GuideArrow = new GuideArrow();
			var masker:GuideMasker = new GuideMasker();
			var tip:GuideTip = new GuideTip();
			GuideViewManger.getInstance().init(stage, arrow, masker, tip);
			GuideDialogManager.getInstance().setDialog(new GuideDialog());
			
			eventManager.addEventListener("toNextGuide", toNextGuideHandler);
			
			//var info:Object = DataManager.getInstance().currentUser;
			//var info:Object = { id:"guidId", idx:stepIdx };
			var info:Object = { id:"guideId", idx:0 };
			var hasNovice:Boolean =  true; // info.id;
			
			GuideListUtil.setXMLString(xml.toString());
			
			if (hasNovice)
			{
				var curId:String = info.id;
				var curStep:int = info.idx;
				setTimeout(function():void
				{
					GuideListUtil.startGuide(curId, curStep - 1);
				},0);
			
				//var list:Vector.<GuideVo> = GuideXMLConverter.convectToGuideList(xml);
				//var find:Boolean = false;
				//var curId:String = info.guideInfo.id;
				//var curStep:int = info.guideInfo.idx;
				//trace("curId=", curId, "curStep=", curStep);
				//
				//var len:int = list.length;
				//for (var i:int = 0; i < len; i++)
				//{
					//if (find || curId == list[i].id)
					//{
						//find = true;
						//
						//GuideManager.getInstance().addGuide(list[i]);
					//}
				//}
				//throw new Error( xml);
				//GuideManager.getInstance().gotoGuideStep(curStep-1);
				//GuideManager.getInstance().autoNextGuide = false;// int(curId) == 1;
				//if (int(curId) >= 5) addEventShowGuide();
				//GuideManager.getInstance().addEventListener(GuideEvent.ALL_STEP_FINISH, noviceGuideFinish);
				//stage.addEventListener(MouseEvent.MOUSE_DOWN, ignoreMouseDown, true, int.MAX_VALUE);
			}else
			{
				//addEventShowGuide();
			}
			addEventShowGuide();
			//if (info.uid == 10152)
			//{
				//GuideManager.getInstance().removeAllGuide();
				//setTimeout(function():void
				//{
					//GuideListUtil.startGuide("23");
				//},0);
			//}
		}
		
		private function guideEventHandler(e:GuideEvent):void 
		{
			GuideLocal(RuntimeUtil.getBaseParamMap().getValue("__guideLocal")).empty();
			switch(e.type)
			{
				case GuideEvent.STEP_START :
					//ModuleManager.getInstance().closeCenterModule();
					//DataManager.getInstance().setVar("guideRunning", true);
					eventManager.dispatchEvent(new Event("guideStart"));
					eventManager.removeEventListener("toNextGuide", toNextGuideHandler);
					break;
					
				case GuideEvent.STEP_ALL_FINISH :
					//DataManager.getInstance().setVar("guideRunning", false);
					eventManager.dispatchEvent(new Event("guideStop"));
					eventManager.addEventListener("toNextGuide", toNextGuideHandler);
					break;
			}
		}
		
		private function toNextGuideHandler(e:Event):void 
		{
			//if (UserData.guideList.length > 0)
			//{
				//GuideListUtil.startGuide(UserData.guideList[0]);
			//}
		}
		
		private function addEventShowGuide():void
		{
			eventManager.addEventListener("showGuide", showGuideHandler);
		}
		
		private function showGuideHandler(e:Event):void 
		{
			GuideManager.getInstance().removeAllGuide();
			setTimeout(function():void
			{
				GuideListUtil.startGuide(e["data"]);
			},0);
			
		}
		
	}
	
}