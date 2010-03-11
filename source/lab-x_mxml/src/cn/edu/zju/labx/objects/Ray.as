package cn.edu.zju.labx.objects
{   
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.special.LineMaterial;
	
	import cn.edu.zju.labx.core.StageObjectsManager;
	
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
		var lineRays:ArrayCollection =new ArrayCollection();
		
		var lines:Lines3D = null;
		
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
			  		var k:Number = (endX - lineRay.start_point.x)/lineRay.vector.x;
               	 	var x:Number = endX;
                	var y:Number = k*lineRay.vector.y + lineRay.start_point.y;
               		var z:Number = k*lineRay.vector.z + lineRay.start_point.z;
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
		    StageObjectsManager.getDefault.rayLayer.addDisplayObject3D(lines, true);
		    addChild(lines);
	    }
        
	}
}