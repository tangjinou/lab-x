package cn.edu.zju.labx.objects
{   
	import cn.edu.zju.labx.utils.MathUtils;
	import cn.edu.zju.labx.utils.ResourceManager;
	
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
		
		protected var ray:DAE; 
		
		public function Ray(material:MaterialObject3D=null, startVertex:Vertex3D=null, endVertex:Vertex3D=null, radius:Number=DEFAULT_RADIUS)
		{
			super(material);
			this.startVertex = startVertex || new Vertex3D();
			this.endVertex = endVertex || new Vertex3D();
			this.radius = radius;
			
			ray=new DAE(true);  
            ray.load(ResourceManager.RAY_DAE_URL,new MaterialsList( {all:this.material} ) );		
            ray.addEventListener(FileLoadEvent.LOAD_COMPLETE,daeFileOnloaded);  
//			addDisplayObject();
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
			
		   	this.addChild(ray);
		}
		
		private function daeFileOnloaded(evt:FileLoadEvent):void{  
	    	addChild(ray);  
        } 
	}
}