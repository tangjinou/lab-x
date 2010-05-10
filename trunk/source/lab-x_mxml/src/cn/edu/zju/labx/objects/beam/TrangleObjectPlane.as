package cn.edu.zju.labx.objects.beam
{
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.special.CompositeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.layer.ViewportLayer;
	
	public class TrangleObjectPlane extends Beam
	{   
		private var _objMaterial:MaterialObject3D;
		
		public function TrangleObjectPlane(name:String, material:MaterialObject3D, objMaterial:MaterialObject3D, vertices:Array=null, faces:Array=null)
		{
			this._objMaterial = objMaterial || new ColorMaterial(0x0);
			_objMaterial.smooth = true;
			super(material, name, vertices, faces);
		}
		
				/**
		 *  deal with when the ray on the object
		 **/
		override protected function handleRay(oldRay:Ray):void
		{
			this._ray=makePassThroughRay(oldRay);
			var otherInfo:ArrayCollection = new ArrayCollection();
			otherInfo.addItem(createLeftShape());
			_ray.setOtherInfo(otherInfo);
			displayNewRay(this._ray);
		}

		override public function createDisplayObject():void
		{

			var width:uint=3;

			/* create right side */
			var bmpRight:BitmapData=new BitmapData(depth, height, true, this._objMaterial.fillColor);
			bmpRight.draw(createRightShape());

			var rectMaterialRight:BitmapMaterial=new BitmapMaterial(bmpRight);
			rectMaterialRight.smooth=true;

			var compMaterialRight:CompositeMaterial=new CompositeMaterial();
			compMaterialRight.addMaterial(material);
			compMaterialRight.addMaterial(rectMaterialRight);
			compMaterialRight.interactive=true;

			/* create left side */
			var bmpLeft:BitmapData=new BitmapData(depth, height, true, this._objMaterial.fillColor);
			bmpLeft.draw(createLeftShape());
			var rectMaterialLeft:BitmapMaterial=new BitmapMaterial(bmpLeft);
			rectMaterialLeft.smooth=true;

			var compMaterialLeft:CompositeMaterial=new CompositeMaterial();
			compMaterialLeft.addMaterial(material);
			compMaterialLeft.addMaterial(rectMaterialLeft);
			compMaterialLeft.interactive=true;

			var materialsList:MaterialsList=new MaterialsList();
			materialsList.addMaterial(material, "front");
			materialsList.addMaterial(material, "back");
			materialsList.addMaterial(compMaterialLeft, "left");
			materialsList.addMaterial(compMaterialRight, "right");
			materialsList.addMaterial(material, "top");
			materialsList.addMaterial(material, "bottom");
			displayObject=new Cube(materialsList, width, depth, height);

			var effectLayer:ViewportLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(displayObject, true);
			effectLayer.blendMode=BlendMode.HARDLIGHT;
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);


			this.addChild(displayObject);
		}


		private function createLeftShape():Shape
		{
			
			var arrowLeft:Shape=new Shape();
			var g:Graphics = arrowLeft.graphics;
			g.beginFill(this._objMaterial.fillColor, 1);
			g.moveTo(50, 30);
			g.lineTo(35, 50);
			g.lineTo(65, 50);
			return arrowLeft;
		}

		private function createRightShape():Shape
		{
			var arrowRight:Shape=new Shape();
			var g:Graphics = arrowRight.graphics;
			g.beginFill(this._objMaterial.fillColor, 1);
			g.moveTo(50, 30);
			g.lineTo(35, 50);
			g.lineTo(65, 50);
			return arrowRight;
		}

	}
}