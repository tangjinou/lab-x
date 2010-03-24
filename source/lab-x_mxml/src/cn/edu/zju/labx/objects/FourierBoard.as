package cn.edu.zju.labx.objects
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	
	public class FourierBoard extends Board
	{
		public function FourierBoard(name:String,material:MaterialObject3D=null)
		{
			super(name, material);
			this.displayImage(true); //temp to display image always on receiving rays
		}
		
		override public function onRayHandle(oldRay:Ray):void
		{
			super.onRayHandle(oldRay);
		}
		
		private function displayImage(isAdd:Boolean):void
		{
			var w:Number = 10;
			var h:Number = 40;
			bmp = new BitmapData(depth, height, false, 0x0);
			bmp.fillRect(new Rectangle(0, 0, w, h), 0x0000FF);
			new_material = new BitmapMaterial(bmp);
			new_material.smooth = true;
			new_material.interactive = true;
			cube.replaceMaterialByName(new_material, "left");
		}

	}
}