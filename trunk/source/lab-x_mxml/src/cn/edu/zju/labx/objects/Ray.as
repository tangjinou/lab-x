package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.utils.MathUtils;
	import cn.edu.zju.labx.utils.ResourceManager;
	
	import mx.collections.ArrayCollection;
	
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Cylinder;
	
	/**
	 * Ray is a LabX Object represent the light transform between LabXObjects
	 */
	public class Ray extends LabXObject
	{
		public static const DEFAULT_RADIUS:uint = 2;
		
		private var startVertex:Vertex3D;
		private var endVertex:Vertex3D;
		private var radius:Number;
		
		var startX:Number;
		var endX:Number;
		
		var lineRays:ArrayCollection =new ArrayCollection();
		
		public function Ray(material:MaterialObject3D=null, lineRays:ArrayCollection =null, startX:Number=0, endX:Number=0)
		{
			super(material);
			this.startVertex = startVertex || new Vertex3D();
			this.endVertex = endVertex || new Vertex3D();
			this.radius = radius;
            this.lineRays= lineRays;
//			addDisplayObject();
		}
		
		public function getLineRays():ArrayCollection
		{
		    return lineRays;
		}
		
		public function setLineRays(lineRays:ArrayCollection):void{
		   this.lineRays= lineRays;
		}
		
		private function addDisplayObject():void
		{
//			var lineMaterial:LineMaterial = new LineMaterial(this.material.lineColor);
//			var lines:Lines3D = new Lines3D(lineMaterial);
//			lines.addLine(new Line3D(lines, lineMaterial, 1, this.startVertex, this.endVertex));
			var cylinderHight:Number = MathUtils.distanceToNumber3D(startVertex.toNumber3D(), endVertex.toNumber3D());
			var cylinderX:Number = (startVertex.x + endVertex.x)/2;
			var cylinderY:Number = (startVertex.y + endVertex.y)/2;
			var cylinderZ:Number = (startVertex.z + endVertex.z)/2;
			
			var ray:Cylinder = new Cylinder(this.material, this.radius, cylinderHight);
			ray.x = cylinderX;
			ray.y = cylinderY;
			ray.z = cylinderZ;
			
			if (endVertex.x != startVertex.x) {
				var rollAngle:Number = 0;
				if (endVertex.y == startVertex.y)
				{
					rollAngle = 90;
				} else {
					rollAngle = Math.atan((endVertex.y - startVertex.y)/(endVertex.x-startVertex.x));
				}
				ray.roll(rollAngle); 
			}
			
		   	addChild(ray);
		}
        
	}
}