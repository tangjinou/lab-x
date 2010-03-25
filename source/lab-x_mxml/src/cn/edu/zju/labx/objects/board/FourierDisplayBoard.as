package cn.edu.zju.labx.objects.board
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.RayManager;
	import cn.edu.zju.labx.objects.beam.FourierGrating;
	import cn.edu.zju.labx.objects.beam.ObjectPlane;
	import cn.edu.zju.labx.objects.lens.FourierLens;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	
	public class FourierDisplayBoard extends Board
	{
		public function FourierDisplayBoard(name:String,material:MaterialObject3D=null)
		{
			super(name, material);
//			this.displayImage(false); //temp to display image always
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

   		   var f_s:Array = new Array();
           
           if(!(ray_tmp.getSender() is FourierLens)){
              return false;
           }
           f_s[0] = ray_tmp.getLengthOfFirstLineRay();
           
           ray_tmp = RayManager.getDefault.getFrontRay(ray_tmp);
           if(!(ray_tmp.getSender() is FourierGrating)){
              return false;
           }
           f_s[1] = ray_tmp.getLengthOfFirstLineRay();
           
           ray_tmp = RayManager.getDefault.getFrontRay(ray_tmp);
           if(!(ray_tmp.getSender() is FourierLens)){
              return false;
           }
           f_s[2] = ray_tmp.getLengthOfFirstLineRay();
           
           ray_tmp = RayManager.getDefault.getFrontRay(ray_tmp);
           if(!(ray_tmp.getSender() is ObjectPlane)){
              return false;
           }
           f_s[3] = ray_tmp.getLengthOfFirstLineRay();
           
           for(var i:int=0;i<f_s.length;i++){
              for(var j:int=0;j<f_s.length;j++){
                 if(Math.abs(f_s[i]-f_s[j])>3){
                    return false;
                 }              
              }
           }
           return true;
   		}
   		

	}
}