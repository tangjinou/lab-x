package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.utils.MathUtils;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	    
	public class MachZehnderInterfBoard extends Board
	{
		public function MachZehnderInterfBoard(name:String,material:MaterialObject3D=null)
		{
			super(name, material);
		}


		
		private function displayMachZehnderInterferenceImage(theta:Number):void
		{   
			//TODO: add relationship with input parameter
			var interval:Number = 5;
			var numOfCircles:Number = height/interval;
			bmp = new BitmapData(depth, height, false, 0x0);
			var circle:Shape = new Shape();
			var baseColor:Number = 0x0000FF;
			var color:Number = baseColor;
			circle.graphics.beginFill(color);
			for (var i:Number = numOfCircles; i > 0; i--)
			{
				circle.graphics.drawCircle(depth/2, height/2 ,i*interval);
				color = baseColor - color;
				circle.graphics.beginFill(color);
			}
			bmp.draw(circle);
			new_material = new BitmapMaterial(bmp);
			new_material.smooth = true;
			new_material.interactive = true;
			cube.replaceMaterialByName(new_material, "left");
			this.removeCursor();
		}
		
		private function handleMachZehnderInterference(lineRay1:LineRay, lineRay2:LineRay):void
   		{
   			var angle1:Number =  MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay1.end_point,lineRay1.start_point),this.getNormal());
			var angle2:Number =  MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay2.end_point,lineRay2.start_point),this.getNormal());
            if(Math.abs(angle1-angle2)<(Math.PI/180)){
            	displayMachZehnderInterferenceImage(MathUtils.calculateAngleOfTwoVector(Number3D.sub(lineRay1.end_point,lineRay1.start_point),Number3D.sub(lineRay2.end_point,lineRay2.start_point)));
            }else{
            	StageObjectsManager.getDefault.addMessage("两条光线夹角之差大于一度");
            }
   		}
   		
		override public function onRayHandle(oldRay:Ray):void
		{
			super.onRayHandle(oldRay);
			
			if(oldRay1!=null&&oldRay2!=null)
			{  
			   var isOldRay1Parellel:Boolean = 	isParellel(oldRay1);
			   var isOldRay2Parellel:Boolean = 	isParellel(oldRay2);
			   
		       if(isOldRay1Parellel==true && isOldRay2Parellel==true)
		       {
		       	  StageObjectsManager.getDefault.addMessage("两条入射挡板线都平行");
		          return;
		       }
		       if(isOldRay1Parellel==false && isOldRay2Parellel==false)
		       {
		       	  StageObjectsManager.getDefault.addMessage("两条入射挡板线都不平行");
		          return;
		       }
		       
		       
				var lineRay1:LineRay = oldRay1.getLineRays().getItemAt(0) as LineRay;
				var lineRay2:LineRay = oldRay2.getLineRays().getItemAt(0) as LineRay;
				if(lineRay1!=null&&lineRay2!=null){
					handleMachZehnderInterference(lineRay1, lineRay2);
	           	}else{
	               	StageObjectsManager.getDefault.addMessage("光线没有经过挡板");
	           	}
   			}  
        } 
   	}
	
}