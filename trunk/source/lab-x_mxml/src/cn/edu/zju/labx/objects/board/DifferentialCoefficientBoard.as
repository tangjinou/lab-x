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