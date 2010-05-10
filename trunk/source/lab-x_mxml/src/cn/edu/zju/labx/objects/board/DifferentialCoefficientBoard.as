package cn.edu.zju.labx.objects.board
{
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	import cn.edu.zju.labx.objects.beam.LCLV;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.special.CompositeMaterial;

	public class DifferentialCoefficientBoard extends Board
	{   
		private var colorMaterial:ColorMaterial = new ColorMaterial(0x00FFFF);
		
		public function DifferentialCoefficientBoard(name:String, material:MaterialObject3D=null)
		{
			super(name, material);
		}

		override protected function handleRay(oldRay:Ray):void
		{
			displayImage(oldRay.getOtherInfo());
		}

		private function displayImage(obj:Object):void
		{
			if (!(obj is ArrayCollection))
				return;
			switch(getFunctionIndexOfLCLV()){
			   case LCLV.LCLV_RADIO_ADD :  
			                    imageAdd(obj);
			                    break;
			   case LCLV.LCLV_RADIO_SUBTRACT:
			   					imageSubtract(obj);
			                    break;
			   case LCLV.LCLV_RADIO_DIFFERENTIAL:
			                    imageDifferential(obj);
			                    break;
			   default: break;
			}
			super.removeCursor();
		}
		
		private function getFunctionIndexOfLCLV():int{
		    var lclv:LCLV = StageObjectsManager.getDefault.getLabXObject(LCLV) as LCLV;
		    if(lclv == null){
		      return LCLV.LCLV_RADIO_ADD;
		    }
		    return lclv.radio_index;
		}
		
		private function imageAdd(obj:Object):void{
			
		    var imageInfo:ArrayCollection = obj as ArrayCollection;
			var bmp:BitmapData=new BitmapData(depth, height, true, 0x0);
			if(imageInfo.length >= 2){
		    	var shape:Shape=new Shape();
				var g:Graphics = shape.graphics;
				g.beginFill(colorMaterial.fillColor, 1);
				g.moveTo(50, 30);
				g.lineTo(35, 50);
				g.lineTo(65, 50);
				g.drawRect(45, 50, 10, 50);
				bmp.draw(shape, shape.transform.matrix);
			}else{
			  	for each (var _shape:Shape in imageInfo)
				{
					bmp.draw(_shape, _shape.transform.matrix);
				}
			}
			var imageMaterial:BitmapMaterial=new BitmapMaterial(bmp);
			var compMaterial:CompositeMaterial=new CompositeMaterial();
			compMaterial.addMaterial(material);
			compMaterial.addMaterial(imageMaterial);
			compMaterial.interactive=true;
			new_material=compMaterial;
			cube.replaceMaterialByName(new_material, "left");
		}
		
		private function  imageSubtract(obj:Object):void{
		    var imageInfo:ArrayCollection = obj as ArrayCollection;
			var bmp:BitmapData=new BitmapData(depth, height, true, 0x0);
			if(imageInfo.length >= 2){
		    	var shape:Shape=new Shape();
				var g:Graphics = shape.graphics;
				g.beginFill(colorMaterial.fillColor, 1);
				g.drawRect(45, 50, 10, 50);
				bmp.draw(shape, shape.transform.matrix);
			}else{
			  	return;
			}
			var imageMaterial:BitmapMaterial=new BitmapMaterial(bmp);
			var compMaterial:CompositeMaterial=new CompositeMaterial();
			compMaterial.addMaterial(material);
			compMaterial.addMaterial(imageMaterial);
			compMaterial.interactive=true;
			new_material=compMaterial;
			cube.replaceMaterialByName(new_material, "left");
			
		}
		private function  imageDifferential(obj:Object):void{
			var imageInfo:ArrayCollection = obj as ArrayCollection;
			var bmp:BitmapData=new BitmapData(depth, height, true, 0x0);
			if(imageInfo.length >= 2){
		    	var shape:Shape=new Shape();
				var g:Graphics = shape.graphics;
				g.beginFill(colorMaterial.fillColor, 1);
				g.moveTo(50, 30);
				g.lineTo(35, 50);
				g.lineTo(65, 50);
				g.drawRect(45, 50, 10, 50);
				bmp.draw(shape, shape.transform.matrix);
			}else{
			  	for each (var _shape:Shape in imageInfo)
				{
					bmp.draw(_shape, _shape.transform.matrix);
				}
			}
			var imageMaterial:BitmapMaterial=new BitmapMaterial(bmp);
			var compMaterial:CompositeMaterial=new CompositeMaterial();
			compMaterial.addMaterial(material);
			compMaterial.addMaterial(imageMaterial);
			compMaterial.interactive=true;
			new_material=compMaterial;
			cube.replaceMaterialByName(new_material, "left");
		}

		override public function isOnTheRay(ray:Ray):Boolean
		{
			return super.isOnTheRay(ray);
		}
	}
}