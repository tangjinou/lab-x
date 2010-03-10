package cn.edu.zju.labx.objects
{   
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.special.LineMaterial;
	
	/**
	 * Ray is a LabX Object represent the light transform between LabXObjects
	 */
	public class Ray extends LabXObject
	{
		public static const DEFAULT_RADIUS:uint = 2;
		
		private var startVertex:Vertex3D;
		private var endVertex:Vertex3D;
		public var lineBold:Number=5;
		
		var startX:Number;
		var endX:Number;
		//This array is in for lineRay
		var lineRays:ArrayCollection =new ArrayCollection();
		
		public function Ray(material:MaterialObject3D=null, lineRays:ArrayCollection =null, startX:Number=0, endX:Number=0)
		{
			super(material);
			this.startVertex = startVertex || new Vertex3D();
			this.endVertex = endVertex || new Vertex3D();
			this.lineBold = lineBold;
            this.lineRays= lineRays;
            startVertex = new Vertex3D(0,0,0);
            endVertex = new Vertex3D(250,50,0);
            displayRays();
		}
		
		public function getLineRays():ArrayCollection
		{
		    return lineRays;
		}
		
		public function setLineRays(lineRays:ArrayCollection):void{
		   this.lineRays= lineRays;
		}
		
		public function displayRays():void
		{   
			
			if(lineRays==null){
			  return;
			}
			var lineMaterial:LineMaterial = new LineMaterial(0xFF0000,1);
			var lines:Lines3D = new Lines3D(lineMaterial);
			for(var i:int=0;i<lineRays.length;i++){
			  if(lineRays.getItemAt(i) is LineRay)
			  {
			  	var lineRay:LineRay = lineRays.getItemAt(i) as LineRay;
			  	lines.addLine(new Line3D(lines, lineMaterial, lineBold, lineRay.start_point, lineRay.end_point));
			  }
		    }
		    addChild(lines);
		}
        
	}
}