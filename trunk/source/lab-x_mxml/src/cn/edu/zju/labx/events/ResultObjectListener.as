package cn.edu.zju.labx.events
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.objects.LabXObject;
	
	import mx.controls.Label;
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.special.CompositeMaterial;
	import org.papervision3d.objects.primitives.Cube;
	
	public class ResultObjectListener implements ILabXListener
	{
		private var _label:Label;
		public function ResultObjectListener(label:Label)
		{
			this._label = label;
		}

		public function handleLabXEvent(event:LabXEvent):Boolean
		{
			var obj:LabXObject = event.currentXObject;
			var objWithMaterial:TriangleMesh3D = obj.getObjectWithMaterial();
			if (objWithMaterial is Cube)
			{
				var cube:Cube = objWithMaterial as Cube;
				var material:MaterialObject3D = cube.getMaterialByName("left");
				if (material is CompositeMaterial)
				{
					var compMaterial:CompositeMaterial = material as CompositeMaterial;
					for each(var mat:MaterialObject3D in compMaterial.materials)
					{
						drawMaterial(_label, mat);
					}
				}else {
					drawMaterial(_label, material);
				}
			}
			
			return false;
		}
		
		private function drawMaterial(label:Label, material:MaterialObject3D):void
		{
			if (material is BitmapMaterial)
			{
				label.graphics.clear();
				label.graphics.beginBitmapFill(material.bitmap, null, false);
				label.graphics.drawRect(0, 0, LabXConstant.LABX_OBJECT_DEPTH, LabXConstant.LABX_OBJECT_HEIGHT);
				label.graphics.endFill();
			}
			else if (material is ColorMaterial)
			{
				label.graphics.clear();
				label.graphics.beginFill(material.fillColor);
				label.graphics.drawRect(0, 0, LabXConstant.LABX_OBJECT_DEPTH, LabXConstant.LABX_OBJECT_HEIGHT);
				label.graphics.endFill();
			}
		}
		
	}
}