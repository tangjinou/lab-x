package cn.edu.zju.labx.objects.beam
{
	import cn.edu.zju.labx.core.manager.RayManager;
	import cn.edu.zju.labx.objects.lens.Lens;
	import cn.edu.zju.labx.objects.ray.LineRay;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;

	public class LCLV extends Beam
	{
		private var imageInfo:ArrayCollection;
		public function LCLV(name:String, material:MaterialObject3D,vertices:Array=null, faces:Array=null)
		{
			super(material, name, vertices, faces);
		}


		override public function onRayClear():void
		{
			imageInfo = null;
			super.onRayClear();
		}

		override protected function handleRay(oldRay:Ray):void
		{
			if (oldRay.getLineRays() == null || oldRay.getLineRays().length == 0)
				return;
			var lineRay:LineRay=oldRay.getLineRays().getItemAt(0) as LineRay;
			var lineRayNormal:Number3D=new Number3D(lineRay.logic.dx, lineRay.logic.dy, lineRay.logic.dz);
			var normal:Number3D=getNormal();
			if (Number3D.dot(lineRayNormal, normal) < 0)
			{
				var ray:Ray = makeReflectionRay(oldRay, true);
				var newInfo:ArrayCollection = (oldRay.getOtherInfo() as ArrayCollection) || (new ArrayCollection());
				if(this.imageInfo != null)
				{
					for each (var shape:Shape in this.imageInfo)
					{
						newInfo.addItem(shape);
					}
					//should sort the shapes 
					sort(newInfo);
					
				}
				ray.setOtherInfo(newInfo);
				displayNewRay(ray);
			}
			else
			{
				//do nothing
				if(oldRay != null)
				{
					imageInfo = oldRay.getOtherInfo() as ArrayCollection;
					if((imageInfo != null) && (oldRay.getSender() is Lens))
					{
						var len:Lens = oldRay.getSender() as Lens;
						var f:Number = len.focus;
						var tmp_ray:Ray = RayManager.getDefault.getFrontRay(oldRay);
						var u:Number = len.getDistance(tmp_ray);
						var v:Number=1 / (1 / f - 1 / u);
						var v2:Number = getDistance(oldRay);
						var scale:Number = v /u * (Math.abs(v2-f)/Math.abs(v-f));
						
						for each (var item:Shape in imageInfo)
						{
							item.transform.matrix = new Matrix(scale, 0, 0, scale, -depth/2*(scale-1), -height/2*(scale-1));
						}
					}
				}
				
			}
		}
		
		private function sort(info:ArrayCollection):void
		{
			if (info.sort == null) {
				var sorter:Sort = new Sort();
				sorter.compareFunction = compareValues;
				info.sort = sorter;
				info.refresh();
			}
		}
		
		/**
		 * make the scale larger to the front of the array
		 */
		private function compareValues(a:Object, b:Object, fields:Array = null):int
		{
			if (a == null && b == null) return 0;
			if (a == null) return 1;
			if (b == null) return -1;
			var objA:Shape = a as Shape;
			var objB:Shape = b as Shape;
			
			if (Math.abs(objA.transform.matrix.d) < Math.abs(objB.transform.matrix.d))return 1;
			if (Math.abs(objA.transform.matrix.d) > Math.abs(objB.transform.matrix.d))return -1;
			
			return 0;
		};
		
		
		override protected function objectPressHandler(event:InteractiveScene3DEvent):void{
			super.objectPressHandler(event);
		} 
		
		public var radio_index:int = LCLV_RADIO_ADD;
		public static const LCLV_RADIO_ADD:int = 0;
		public static const LCLV_RADIO_SUBTRACT:int = 1;
		public static const LCLV_RADIO_DIFFERENTIAL:int =2;
		
		public function changeFunction(event:Event,str:String):void{
		    if(str == "add"){
		       radio_index = LCLV_RADIO_ADD;
		    }else if(str == "subtract"){
		       radio_index = LCLV_RADIO_SUBTRACT;
		    }else if(str == "differential"){
		       radio_index = LCLV_RADIO_DIFFERENTIAL;
		    }else{
               radio_index = LCLV_RADIO_ADD;		    
		    }
		}
	}
}