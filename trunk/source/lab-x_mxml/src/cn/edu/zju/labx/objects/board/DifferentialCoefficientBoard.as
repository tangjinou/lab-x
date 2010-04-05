package cn.edu.zju.labx.objects.board
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import mx.collections.ArrayCollection;
	
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
			var shape1:Shape=new Shape();
			shape1.graphics.beginFill(material.fillColor, 1);
			shape1.graphics.drawCircle(50, 50, 20);
			var bmp1:BitmapData=new BitmapData(depth, height, true, 0x0);
			bmp1.draw(shape1);
			var shape_material1:BitmapMaterial=new BitmapMaterial(bmp1);
			var compMaterial1:CompositeMaterial=new CompositeMaterial();
			compMaterial1.addMaterial(shape_material1);

			var shape2:Shape=new Shape();
			shape2.graphics.beginFill(0x000000, 1);
			shape2.graphics.drawCircle(50, 50, 40);
			var bmp2:BitmapData=new BitmapData(depth, height, true, 0x0);
			bmp2.draw(shape2);
			var shape_material2:BitmapMaterial=new BitmapMaterial(bmp2);
			var compMaterial2:CompositeMaterial=new CompositeMaterial();
			compMaterial2.addMaterial(shape_material2);

			var compM:CompositeMaterial = new CompositeMaterial();
			compM.addMaterial(material);
			compM.addMaterial(compMaterial2);
			compM.addMaterial(compMaterial1);
			compM.interactive = true;
			
			new_material = compM;

			cube.replaceMaterialByName(new_material, "left");
		}

		/**
		 * For test
		 */
		private function createLeftShape():Shape
		{
			var w:Number=LabXConstant.rectW;
			var h:Number=LabXConstant.rectH;
			var rectLeft:Shape=new Shape();
			rectLeft.graphics.beginFill(0x000000, 1);
			rectLeft.graphics.drawRect(depth / 5 * 3 - w, height / 2 - h / 2, w, h);
			rectLeft.graphics.drawRect(depth / 5 * 3 - w - h, height / 2 - w / 2, h, w);
			return rectLeft;
		}

		override public function onRayHandle(oldRay:Ray):void
		{
			super.onRayHandle(oldRay);
			displayImage(oldRay.getOtherInfo());
		}

		private function displayImage(obj:Object):void
		{
			if (!(obj is ArrayCollection))
				return;
			
			var imageInfo:ArrayCollection = obj as ArrayCollection;
			var bmp:BitmapData=new BitmapData(depth, height, true, 0x0);
			for each (var shape:Shape in imageInfo)
			{
				bmp.draw(shape, shape.transform.matrix);
			}
			var imageMaterial:BitmapMaterial=new BitmapMaterial(bmp);

			var compMaterial:CompositeMaterial=new CompositeMaterial();
			compMaterial.addMaterial(material);
			compMaterial.addMaterial(imageMaterial);
			compMaterial.interactive=true;

			new_material=compMaterial;

			cube.replaceMaterialByName(new_material, "left");
			super.removeCursor();
		}

		override public function isOnTheRay(ray:Ray):Boolean
		{
			return super.isOnTheRay(ray);
		}
	}
}