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
			
			/* create right side */
			var bmpRight:BitmapData = new BitmapData(depth, height, true, 0x0);
			var rectRight:Shape = new Shape();
			rectRight.graphics.beginFill(0x000000, 1);
			rectRight.graphics.drawRect(depth/5-w/2, height/2-h/2, w, h);
			rectRight.graphics.drawRect(depth/5*4-h/2, height/2-w/2, h, w);
			bmpRight.draw(rectRight);
			
			var rectMaterialRight:BitmapMaterial = new BitmapMaterial(bmpRight);
			rectMaterialRight.smooth = true;
	        
	        var compMaterialRight:CompositeMaterial = new CompositeMaterial();
	        compMaterialRight.addMaterial(material);
	        compMaterialRight.addMaterial(rectMaterialRight);
	        compMaterialRight.interactive = true;
	        
	        /* create left side */
	        var bmpLeft:BitmapData = new BitmapData(depth, height, true, 0x0);
			var rectLeft:Shape = new Shape();
			rectLeft.graphics.beginFill(0x000000, 1);
			rectLeft.graphics.drawRect(depth/5*4-w/2, height/2-h/2, w, h);
			rectLeft.graphics.drawRect(depth/5-h/2, height/2-w/2, h, w);
			bmpLeft.draw(rectLeft);
			
			var rectMaterialLeft:BitmapMaterial = new BitmapMaterial(bmpLeft);
			rectMaterialLeft.smooth = true;
	        
	        var compMaterialLeft:CompositeMaterial = new CompositeMaterial();
	        compMaterialLeft.addMaterial(material);
	        compMaterialLeft.addMaterial(rectMaterialLeft);
	        compMaterialLeft.interactive = true;
	        
		    var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(material,"front");
			materialsList.addMaterial(material,"back");
			materialsList.addMaterial(compMaterialLeft,"left");
			materialsList.addMaterial(compMaterialRight,"right");
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