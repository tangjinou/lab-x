package cn.edu.zju.labx.objects
{

	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	
	import flash.filters.DropShadowFilter;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.materials.special.LineMaterial;

	public class Grid
	{
		private var _lines:Lines3D;
		private var _width:Number=900;
		private var _depth:Number=480;
		private var _interval:Number=50;

		public function Grid()
		{
			_lines=new Lines3D;
			var blueMaterial:LineMaterial=new LineMaterial(0x00FF00);
			var start:Vertex3D;
			var end:Vertex3D;
			var line:Line3D;
			for (var i:Number=0; i < _depth / _interval; i++)
			{
				start=new Vertex3D(50, 0, i * _interval - _depth / 2);
				end=new Vertex3D(_width, 0, i * _interval - _depth / 2);
				line=new Line3D(_lines, blueMaterial, 1, start, end);
				_lines.addLine(line);
			}
			for (i=0; i < _width / _interval; i++)
			{
				start=new Vertex3D(i * _interval + 50, 0, -_depth / 2 - 15);
				end=new Vertex3D(i * _interval + 50, 0, _depth / 2 - 15);
				line=new Line3D(_lines, blueMaterial, 1, start, end);
				_lines.addLine(line);
			}
			
			_lines.moveDown(LabXConstant.GRID_DOWN_OFFSET);
			
			StageObjectsManager.getDefault.originPivot.addChild(_lines);
			StageObjectsManager.getDefault.layerManager.gridLayer.addDisplayObject3D(_lines);
			var dropShadowFilter:DropShadowFilter=new DropShadowFilter(0, 45, 0x00FF00, 1, 8, 8, 3, 2, false, false, false);

			StageObjectsManager.getDefault.layerManager.gridLayer.filters=[dropShadowFilter];

		}

		public function destroy():void
		{
			StageObjectsManager.getDefault.originPivot.removeChild(_lines);
			StageObjectsManager.getDefault.layerManager.gridLayer.removeAllLayers();
		}
	}
}