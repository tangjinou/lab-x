package cn.edu.zju.labx.objects
{   
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.view.layer.ViewportLayer;
		
	import cn.edu.zju.labx.core.StageObjectsManager;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * Ray is a LabX Object represent the light transform between LabXObjects
	 */
	public class Ray extends LabXObject
	{
		public static const DEFAULT_RADIUS:uint = 2;
		
		public var lineBold:Number=2;
		
		public var startX:Number;
		public var endX:Number;
		
		//This array is in for lineRay
		private var lineRays:ArrayCollection =new ArrayCollection();
		
		private var lines:Lines3D = null;
		
		public function Ray(material:MaterialObject3D=null, lineRays:ArrayCollection =null, startX:Number=0, endX:Number=0)
		{
			super(material);
			this.lineBold = lineBold;
            this.lineRays= lineRays;
//          displayRays();
		}
		
		public function getLineRays():ArrayCollection
		{
		    return lineRays;
		}
		
		public function setLineRays(lineRays:ArrayCollection):void{
		   this.lineRays= lineRays;
		}
		
		public function set EndX(endx:Number):void
		{
			this.endX = endx;
			if(endx<1000){
				for(var i:int=0;i<lineRays.length;i++){
			  	if(lineRays.getItemAt(i) is LineRay)
			 	 {
			  		var lineRay:LineRay = lineRays.getItemAt(i) as LineRay;
			  		var k:Number = (endX - lineRay.start_point.x)/lineRay.logic.dx;
               	 	var x:Number = endX;
                	var y:Number = k*lineRay.logic.dy + lineRay.start_point.y;
               		var z:Number = k*lineRay.logic.dz + lineRay.start_point.z;
			  		lineRay.end_point = new Vertex3D(x,y,z);
			  	 }
		    	}
		   }
			
			displayRays();
		}
		
		public function displayRays():void
		{   
			if(lineRays==null){
			  return;
			}
			if(lines!=null){
			  removeChild(lines);
			}
			var lineMaterial:LineMaterial = new LineMaterial(0xffffff,1);
			lines = new Lines3D(lineMaterial);
			for(var i:int=0;i<lineRays.length;i++){
			  if(lineRays.getItemAt(i) is LineRay)
			  {
			  	var lineRay:LineRay = lineRays.getItemAt(i) as LineRay;
			  	lines.addLine(new Line3D(lines, lineMaterial, lineBold, lineRay.start_point, lineRay.end_point));
			  }
		    }
		    var effectLayer:ViewportLayer = new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(lines, true);
			var bf:BlurFilter = new BlurFilter(3,3,1);
			var growFilter_2:GlowFilter = new GlowFilter(0x00ffff, 2, 20, 10, 2, 3, true, false);
			var growFilter_b_2:GlowFilter = new GlowFilter(0x00ffff, 2, 16, 10, 3, 9, false, false);
			var dropShadow_2:DropShadowFilter = new DropShadowFilter(0, 360, 0x000fff, 1, 70, 70, 5, 3, false, false, false);
			effectLayer.filters = [growFilter_2,growFilter_b_2,dropShadow_2];
			StageObjectsManager.getDefault.layerManager.equipmentLayer.addLayer(effectLayer);
		    addChild(lines);
	    }
        
	}
}