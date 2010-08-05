package cn.edu.zju.labx.objects
{
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	
	import cn.edu.zju.labx.core.LabXConstant;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.materials.special.LineMaterial;
	
	public class Axis
	{
		private var _lines:Lines3D;
		public function Axis()
		{
			_lines=new Lines3D;
			var redMaterial:LineMaterial=new LineMaterial(0xFF0000);
			var greenMaterial:LineMaterial=new LineMaterial(0x00FF00);
			var blueMaterial:LineMaterial=new LineMaterial(0x0000FF);
			var origin:Vertex3D = new Vertex3D(0, 0, 0);
			var xEnd:Vertex3D = new Vertex3D(100, 0, 0);
			var yEnd:Vertex3D = new Vertex3D(0, 100, 0);
			var zEnd:Vertex3D = new Vertex3D(0, 0, -100);
			var line:Line3D;
			line = new Line3D(_lines, redMaterial, 1, origin, xEnd);
			_lines.addLine(line);
			line = new Line3D(_lines, greenMaterial, 1, origin, yEnd);
			_lines.addLine(line);
			line = new Line3D(_lines, blueMaterial, 1, origin, zEnd);
			_lines.addLine(line);
			_lines.moveDown(LabXConstant.GRID_DOWN_OFFSET);
			StageObjectsManager.getDefault.originPivot.addChild(_lines);
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addDisplayObject3D(_lines);

		}
		
		public function destroy():void
		{
			StageObjectsManager.getDefault.originPivot.removeChild(_lines);
		}

	}
}