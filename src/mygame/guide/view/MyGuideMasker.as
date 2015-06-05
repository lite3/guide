package mygame.guide.view 
{
	import com.litefeel.guide.view.GuideMasker;
	import happymagic.guide.view.ui.LightCircle;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class MyGuideMasker extends GuideMasker 
	{
		
		private var size:Number = 46;
		private var light:LightCircle;
		public function MyGuideMasker() 
		{
			light = new LightCircle();
			light.mouseEnabled = false;
			light.mouseChildren = false;
			super();
		}
		
		override public function show(bringToFront:Boolean = false):void 
		{
			super.show(bringToFront);
			resetLight();
		}
		
		override public function showHasCircle(px:int, py:int, radius:int, bringToFront:Boolean = false):void 
		{
			super.showHasCircle(px, py, radius, bringToFront);
			resetLight();
		}
		
		override public function showHasRect(px:int, py:int, pw:int, ph:int, bringToFront:Boolean = false):void 
		{
			super.showHasRect(px, py, pw, ph, bringToFront);
			resetLight();
		}
		
		override public function bringToFront():void 
		{
			super.bringToFront();
			resetLight();
		}
		
		override public function hide():void 
		{
			super.hide();
			resetLight();
		}
		
		override public function remove():void 
		{
			super.remove();
			resetLight();
		}
		
		override public function set visible(value:Boolean):void 
		{
			super.visible = value;
			resetLight();
		}
		
		private function resetLight():void
		{
			if (isHide || !parent || !knockout || !visible)
			{
				if (light.parent) light.parent.removeChild(light);
				light.stop();
			}else
			{
				light.x = px;
				light.y = py;
				light.scaleX = radius * 2 / size;
				light.scaleY = radius * 2 / size;
				parent.addChildAt(light, parent.getChildIndex(this) + 1);
				light.play();
			}
		}
	}

}