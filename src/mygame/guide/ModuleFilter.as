package mygame.guide 
{
	import happyfish.events.ModuleEvent;
	import com.litefeel.guide.GuideViewManger;
	import happyfish.manager.module.interfaces.IModule;
	import happyfish.manager.module.ModuleManager;
	import happymagic.manager.DisplayManager;
	/**
	 * ...
	 * @author lite3
	 */
	public class ModuleFilter 
	{
		
		private var moduleOpening:Boolean;
		private var stageEnable:Boolean;
		private var guideViewList:Array;
		private const moduleList:Array = ["BusinessLevelUpView"];
		
		public function ModuleFilter(viewList:Array) 
		{
			this.guideViewList = viewList;
			ModuleManager.getInstance().addEventListener(ModuleEvent.MODULE_OPEN, filterModule);
			ModuleManager.getInstance().addEventListener(ModuleEvent.MODULE_CLOSING, filterModule);
		}
		
		private function filterModule(e:ModuleEvent):void 
		{
			var nameList:Array = [];
			switch(e.type)
			{
				case ModuleEvent.MODULE_OPEN :
					if ( -1 == moduleList.indexOf(e.moduleName)) break;
					if (!moduleOpening)
					{
						moduleOpening = true;
						//stageEnable = DisplayManager.uiSprite.stage.mouseChildren;
						for (var i:int = guideViewList.length - 1; i >= 0; i--)
						{
							guideViewList[i].visible = false;
						}
					}
					break;
					
				case ModuleEvent.MODULE_CLOSING :
					if ( -1 == moduleList.indexOf(e.moduleName)) break;
					if (!moduleOpening) break;
					var modules:Object = ModuleManager.getInstance().modules;
					for (i = moduleList.length - 1; i >= 0; i--)
					{
						var module:IModule = modules[moduleList[i]] as IModule;
						if (!module) continue;
						if (!module.isClosed()) return;
					}
					
					moduleOpening = false;
					//DisplayManager.uiSprite.stage.mouseChildren = stageEnable;
					for (i = guideViewList.length - 1; i >= 0; i--)
					{
						guideViewList[i].visible = true;
					}
					break;
			}
		}
		
	}

}