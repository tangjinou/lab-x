package cn.edu.zju.labx.objects
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.StageObjectsManager;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.special.CompositeMaterial;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;
	
	public class ObjectPlane extends BeamSplitter
	{
		public function ObjectPlane(name:String,material:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			super(name,material, vertices, faces);
		}
		
		 /**
		 *  deal with when the ray on the object
		 **/ 
   		override public function onRayHandle(oldRay:Ray):void{
   		    this._ray = makeNewRay2(oldRay);
			if(_ray!=null){
			    StageObjectsManager.getDefault.originPivot.addChild(_ray);
				_ray.displayRays();
				StageObjectsManager.getDefault.rayManager.notify(_ray);
			}
   		}
   		
   		override public function createDisplayObject():void
   		{	
	        width=3;
	        depth=100;
	        
			var w:Number = LabXConstant.rectW;
			var h:Number = LabXConstant.rectH;
			var bmp:BitmapData = new BitmapData(depth, height, true, 0x0);
			var rect:Shape = new Shape();
			rect.graphics.beginFill(0x000000);
			rect.graphics.drawRect(depth/5-w/2, height/2-h/2, w, h);
			bmp.draw(rect);
			rect.graphics.drawRect(depth/5*4-h/2, height/2-w/2, h, w);
			bmp.draw(rect);
			
			var rectMaterial:BitmapMaterial = new BitmapMaterial(bmp);
			rectMaterial.smooth = true;
	        
	        var compMaterial:CompositeMaterial = new CompositeMaterial();
	        compMaterial.addMaterial(material);
	        compMaterial.addMaterial(rectMaterial);
	        
		    var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(compMaterial,"left");
			materialsList.addMaterial(compMaterial,"right");
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