package cn.edu.zju.labx.objects.beam
{
	import cn.edu.zju.labx.core.StageObjectsManager;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Rectangle;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;
	
	public class FourierGrating extends Beam
	{
		public function FourierGrating(name:String,material:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			super(material, name, vertices, faces);
		}
		
		 /**
		 *  deal with when the ray on the object
		 **/ 
   		override protected function handleRay(oldRay:Ray):void{
   		    this._ray = makePassThroughRay(oldRay);
			displayNewRay(this._ray);
   		}
   		
   		override public function createDisplayObject():void
   		{	
	        width=3;
	        depth=100;
	        
	        var distance:Number = 5;
			var numOfColumns:Number = depth/distance/2;
			var bmp:BitmapData = new BitmapData(depth, height, false, 0x0);
			for (var i:Number = 0; i < numOfColumns; i++)
			{
				bmp.fillRect(new Rectangle(i*distance*2, 0, distance, height), 0x0000FF);
			}
			var gratingMaterial:BitmapMaterial = new BitmapMaterial(bmp);
			gratingMaterial.smooth = true;
			gratingMaterial.interactive = true;
	        
		    var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(gratingMaterial,"left");
			materialsList.addMaterial(gratingMaterial,"right");
			materialsList.addMaterial(material,"top");
			materialsList.addMaterial(material,"bottom");
		   	displayObject = new Cube(materialsList,width,depth,height);
		   	
		   	var effectLayer:ViewportLayer = new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(displayObject, true);
			effectLayer.blendMode = BlendMode.HARDLIGHT;
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);

		   	
		   	this.addChild(displayObject);
		}

	}
}