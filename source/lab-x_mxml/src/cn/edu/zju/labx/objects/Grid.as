package cn.edu.zju.labx.objects
{

	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.BlendMode;
	
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.primitives.Plane;
	
	public class Grid
	{
		private var _plane:Plane;
		private var _width:Number = 800;
		private var _height:Number = 481;
		
		public function Grid()
		{
			var interval:Number = 30;
			var bmp:BitmapData = new BitmapData(_width, _height, false, 0x0);
			for (var i:Number = 0; i < _width/30; i++)
			{
				bmp.fillRect(new Rectangle(i*interval, 0, 2, _height), 0xd82626);
			}
			for (i = 0; i < _height/30; i++)
			{
				bmp.fillRect(new Rectangle(0, i*interval, _width, 2), 0xd82626);
			}
			var mat:BitmapMaterial = new BitmapMaterial(bmp);
			mat.smooth = true;
			_plane = new Plane(mat, _width, _height, 8, 8);
			_plane.moveRight(_width/2+50);
			_plane.moveBackward(10);
			_plane.pitch(90);
			StageObjectsManager.getDefault.originPivot.addChild(_plane);
			StageObjectsManager.getDefault.layerManager.gridLayer.addDisplayObject3D(_plane);
			StageObjectsManager.getDefault.layerManager.gridLayer.blendMode = BlendMode.LIGHTEN;
		}
		
		public function get grids():Plane
		{
			return _plane;
		}

	}
}