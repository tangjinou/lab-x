package cn.edu.zju.labx.objects.board
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.special.CompositeMaterial;

	public class DifferentialCoefficientBoard extends Board
	{
		public function DifferentialCoefficientBoard(name:String, material:MaterialObject3D=null)
		{
			super(name, material);
//			displayImage(createLeftShape());
			/** for test only
			 */
			var shape1:Shape = new Shape();
			shape1.graphics.beginFill(0x0000FF, 1);
			shape1.graphics.drawCircle(30, 30, 20);
			
			var bmp:BitmapData = new BitmapData(depth, height, true, 0x0);
			bmp.draw(shape1);

			var shape2:Shape = new Shape();
			shape2.graphics.beginFill(0xFF0000, 1);
			shape2.graphics.drawCircle(70, 70, 20);
			bmp.draw(shape2);
			
			var shape_material:BitmapMaterial = new BitmapMaterial(bmp);
			shape_material.smooth = true;
			
			var compMaterial:CompositeMaterial = new CompositeMaterial();
	        compMaterial.addMaterial(material);
	        compMaterial.addMaterial(shape_material);
	        compMaterial.interactive = true;
			
			new_material = compMaterial;
	        
	        cube.replaceMaterialByName(new_material, "left");
		}
		
		/**
		 * For test
		 */
		private function createLeftShape():Shape
		{
			var w:Number = LabXConstant.rectW;
			var h:Number = LabXConstant.rectH;
			var rectLeft:Shape = new Shape();
			rectLeft.graphics.beginFill(0x000000, 1);
			rectLeft.graphics.drawRect(depth/5*3-w, height/2-h/2, w, h);
			rectLeft.graphics.drawRect(depth/5*3-w-h, height/2-w/2, h, w);
			return rectLeft;
		}
		
		override public function onRayHandle(oldRay:Ray):void
		{
			super.onRayHandle(oldRay);
			
			if(oldRay1!=null && oldRay2!=null)
			{
				displayAddImage(oldRay1, oldRay2);
			} else if (oldRay1 != null) {
				displayImage(oldRay1.getOtherInfo());
			} else if (oldRay2 != null) {
				displayImage(oldRay2.getOtherInfo());
			}
		}
		
		
		public function displayAddImage(ray1:Ray, ray2:Ray):void
		{
			
		}
		
		private function displayImage(obj:Object):void
		{
			if(!(obj is Shape))return;
			var shape:Shape = obj as Shape;
			
			
			var bmp:BitmapData = new BitmapData(depth, height, true, 0x0);
			bmp.draw(shape);
			
			var shape_material:BitmapMaterial = new BitmapMaterial(bmp);
			shape_material.smooth = true;
			
			var compMaterial:CompositeMaterial = new CompositeMaterial();
	        compMaterial.addMaterial(material);
	        compMaterial.addMaterial(shape_material);
	        compMaterial.interactive = true;
			
			new_material = compMaterial;
	        
	        cube.replaceMaterialByName(new_material, "left");
	        super.removeCursor();
		}
		override public function isOnTheRay(ray:Ray):Boolean
   		{
   			return super.isOnTheRay(ray);
   		}
	}
}