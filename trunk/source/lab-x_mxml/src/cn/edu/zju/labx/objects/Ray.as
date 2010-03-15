package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.core.StageObjectsManager;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.view.layer.ViewportLayer;
	
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
			  		lineRay.end_point = new Number3D(x,y,z);
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
			  	var start_point:Vertex3D = new Vertex3D(lineRay.start_point.x,lineRay.start_point.y,lineRay.start_point.z);
			  	var end_point:Vertex3D = new Vertex3D(lineRay.end_point.x,lineRay.end_point.y,lineRay.end_point.z);
			  	lines.addLine(new Line3D(lines, lineMaterial, lineBold, start_point, end_point));
			  }
		    }
		    var effectLayer:ViewportLayer = new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);
			effectLayer.addDisplayObject3D(lines, true);
			StageObjectsManager.getDefault.layerManager.addRayLayer(effectLayer);
		    addChild(lines);
	    }
        
	}
}