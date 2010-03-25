package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	
	public class FourierDisplayBoard extends Board
	{
		public function FourierDisplayBoard(name:String,material:MaterialObject3D=null)
		{
			super(name, material);
			this.displayImage(false); //temp to display image always
		}
		
		override public function onRayHandle(oldRay:Ray):void
		{
			super.onRayHandle(oldRay);
			if(isRayWayRight(oldRay)){
			    displayImage(false);
			}
		}
		
		private function displayImage(isAdd:Boolean):void
		{
			var w:Number = LabXConstant.rectW;
			var h:Number = LabXConstant.rectH;
			bmp = new BitmapData(depth, height, false, 0x0);
			bmp.fillRect(new Rectangle(depth/2-w/2, height/2-h/2, w, h), 0x0000AA);
			bmp.fillRect(new Rectangle(depth/5-w/2, height/2-h/2, w, h), 0x0000FF);
			bmp.fillRect(new Rectangle(depth/2-h/2, height/2-w/2, h, w), 0x0000AA);
			bmp.fillRect(new Rectangle(depth/5*4-h/2, height/2-w/2, h, w), 0x0000FF);
			if (isAdd){
				bmp.fillRect(new Rectangle(depth/2-w/2, height/2-w/2, w, w), 0x0000FF);
			}else{
				bmp.fillRect(new Rectangle(depth/2-w/2, height/2-w/2, w, w), 0x000000);
			}
			new_material = new BitmapMaterial(bmp);
			new_material.smooth = true;
			new_material.interactive = true;
			cube.replaceMaterialByName(new_material, "left");
			this.removeCursor();
		}
		
		override protected function isRayWayRight(_ray:Ray):Boolean{
   		   var ray_tmp:Ray = _ray;
           if(!(ray_tmp.getSender() is FourierGrating)){
              return false;
           }
//           ray_tmp = RayManager.getDefault.getFrontRay(ray_tmp);
//           if(!(ray_tmp.getSender() is Lens)){
//              return false;
//           }
           return true;
   		}
	}
}