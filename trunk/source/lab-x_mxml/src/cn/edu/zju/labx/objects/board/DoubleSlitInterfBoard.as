package cn.edu.zju.labx.objects.board
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.RayManager;
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.logicObject.InterferenceLogic;
	import cn.edu.zju.labx.objects.lens.Lens;
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;

	
	public class DoubleSlitInterfBoard extends Board
	{
		public function DoubleSlitInterfBoard(name:String,material:MaterialObject3D=null)
		{
			super(name, material);
		}


		private function displayDoubleSlitInterferenceImage(theta:Number):void
		{   
			var distance:Number = InterferenceLogic.doubleSlitInterferenceLogic(theta, LabXConstant.WAVE_LENGTH);
//			trace(distance);
			
			distance /= 300;
			var numOfColumns:Number = depth/distance/2;
			var bmp:BitmapData = new BitmapData(depth, height, false, 0x0);
			for (var i:Number = 0; i < numOfColumns; i++)
			{
				bmp.fillRect(new Rectangle(i*distance*2, 0, distance, height), 0x0000FF);
			}
			new_material = new BitmapMaterial(bmp);
			new_material.smooth = true;
			new_material.interactive = true;
			cube.replaceMaterialByName(new_material, "left");
			this.removeCursor();
		}
		
		override public function onRayHandle(oldRay:Ray):void
		{
			super.onRayHandle(oldRay);
			
			if(oldRay1!=null&&oldRay2!=null)
			{  
			   if(isRayWayRight(oldRay1)==false || isRayWayRight(oldRay2)==false)
			   {
		          return;
			   }	
				
		       if(isParellel(oldRay1)==false || isParellel(oldRay2)==false)
		       {
		       	  StageObjectsManager.getDefault.addMessage("射入挡板入射光线不平行");
		          return;
		       }
		       
				var lineRay1:LineRay = oldRay1.getLineRays().getItemAt(0) as LineRay;
				var lineRay2:LineRay = oldRay2.getLineRays().getItemAt(0) as LineRay;
				if(lineRay1!=null&&lineRay2!=null){
					handleDoubleSlitInterference(lineRay1, lineRay2);
	           	}else{
	               	StageObjectsManager.getDefault.addMessage("光线没有经过挡板");
	           	}
   			}   
        } 
        
        override protected function isRayWayRight(_ray:Ray):Boolean{
           var ray_tmp:Ray = _ray;
           if(!(ray_tmp.getSender() is Lens)){
              return false;
           }
           ray_tmp = RayManager.getDefault.getFrontRay(ray_tmp);
           if(!(ray_tmp.getSender() is Lens)){
              return false;
           }
           return true;
        }
        
        private function handleDoubleSlitInterference(lineRay1:LineRay, lineRay2:LineRay):void
   		{ 
   			var angle1:Number =  MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay1.end_point,lineRay1.start_point),this.getNormal());
			var angle2:Number =  MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay2.end_point,lineRay2.start_point),this.getNormal());
            if(Math.abs(angle1-angle2)<(Math.PI/180)){
            	displayDoubleSlitInterferenceImage(MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay1.end_point,lineRay1.start_point),Number3D.sub(lineRay2.end_point,lineRay2.start_point)));
            }else{
            	StageObjectsManager.getDefault.addMessage("两条光线夹角之差大于一度");
            }
   		}
 	}   
}