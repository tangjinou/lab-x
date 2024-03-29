package cn.edu.zju.labx.objects.ray
{
	import cn.edu.zju.labx.core.LabXConstant;
	import cn.edu.zju.labx.core.manager.StageObjectsManager;
	import cn.edu.zju.labx.objects.LabXObject;
	
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
		public static const DEFAULT_RADIUS:uint=2;

		public var lineBold:Number=2;

		private var startX:Number;
		private var endX:Number;

		public var sender:LabXObject;
		
		private var color:Number;

		//This public array is in for lineRay
		public var lineRays:ArrayCollection=new ArrayCollection(); //FOR TEST

		private var lines:Lines3D=null;
		private var lineMaterial:LineMaterial=new LineMaterial(0x00ffff, 1);
		private var effectLayer:ViewportLayer=new ViewportLayer(StageObjectsManager.getDefault.mainView.viewport, null);

		public function Ray(sender:LabXObject, material:MaterialObject3D=null, lineRays:ArrayCollection=null)
		{
			super(material, null);
			this.lineBold=lineBold;
			this.lineRays=lineRays;
			this.sender=sender;
		}
		
		public function setColor(color:Number = LabXConstant.BLUE):void
		{
			this.color = color;
		}
		
		public function getColor():Number
		{
			return this.color;
		}

		public function getSender():LabXObject
		{
			return this.sender;
		}

		public function getLineRays():ArrayCollection
		{
			return lineRays;
		}

		public function setLineRays(lineRays:ArrayCollection):void
		{
			this.lineRays=lineRays;
		}

		public function set startPonit(p:Number3D):void
		{
			for (var i:int=0; i < lineRays.length; i++)
			{
				if (lineRays.getItemAt(i) is LineRay)
				{
					var lineRay:LineRay=lineRays.getItemAt(i) as LineRay;
					lineRay.start_point=p.clone();
				}
			}
		}

		public function displayRays():void
		{
			if (lineRays == null)
			{
				return;
			}
			if (lines != null)
			{
				removeChild(lines);
				StageObjectsManager.getDefault.layerManager.removeRayLayer(this.effectLayer);
			}
			lines=new Lines3D(lineMaterial);
			for (var i:int=0; i < lineRays.length; i++)
			{
				if (lineRays.getItemAt(i) is LineRay)
				{
					var lineRay:LineRay=lineRays.getItemAt(i) as LineRay;

					var start_point:Vertex3D=new Vertex3D(lineRay.start_point.x, lineRay.start_point.y, lineRay.start_point.z);
					var end_point:Vertex3D=new Vertex3D(lineRay.end_point.x, lineRay.end_point.y, lineRay.end_point.z);

					lines.addLine(new Line3D(lines, lineMaterial, lineBold, start_point, end_point));
				}
			}
			effectLayer.addDisplayObject3D(lines, true);
			StageObjectsManager.getDefault.layerManager.addRayLayer(effectLayer, color);
			addChild(lines);
		}
//	    /**
//	    *  The Ray before this ray
//	    */ 
//	    public var frontRay:Ray;
//	    /***
// 	    *  The Ray after this Ray
//	    */ 
//	    public var nextRay:Ray; 

		/**
		 *  this other info is the info witch ray can bring
		 */
		public var otherInfo:Object;

		public function getOtherInfo():Object
		{
			return otherInfo;
		}

		public function setOtherInfo(obj:Object):void
		{
			this.otherInfo=obj;
		}

		public function destroy():void
		{
			removeChild(lines);
			this.lines=null;
			this.material.destroy();
			this.material=null;
			lineMaterial.destroy();
			lineMaterial=null;
			StageObjectsManager.getDefault.layerManager.removeRayLayer(this.effectLayer);
			effectLayer=null;
			otherInfo=null;
		}

		/**
		 *  if return -1, it cases error
		 */
		public function getLengthOfFirstLineRay():int
		{
			if (lineRays != null && lineRays.length > 0)
			{
				var lineRay:LineRay=lineRays.getItemAt(0) as LineRay;
				return lineRay.length;
			}
			return -1;
		}

	}
}