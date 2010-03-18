package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.IRayHandle;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.LightSource;
	import cn.edu.zju.labx.objects.Ray;
	
	import mx.collections.ArrayCollection;
	
	public class RayManager
	{
		public function RayManager()
		{
		}
		
		private var lightSource:LightSource;
		
		public function setLightSource(l:LightSource):void{
		   this.lightSource = l;
		}
		
		private var rayList:ArrayCollection = new ArrayCollection();
		
		public function clearRays():void{
		    for(var i:int=0;i<rayList.length;i++){
		    	var ray:Ray = rayList.getItemAt(i) as Ray;
		        StageObjectsManager.getDefault.originPivot.removeChild(ray);
		    	if(ray != null)ray.destroy();
		    	ray = null;
		    }
		    rayList.removeAll();
		}
		
		public function isLightOn():Boolean{
		    if(this.lightSource!=null)
		     {
		        return this.lightSource.isLightOn;
		     }
		     return false;
		}
		
		public function reProduceRays():void{
			if(this.lightSource!=null&&this.lightSource.isLightOn){
		       this.clearRays();
		       lightSource.openRay();
		    }
		}
		 
		 /*********************************************************/
		 /* This is for RayHandle                                  */
		 /**********************************************************/
		 public function notify(ray:Ray):void{
		 	rayList.addItem(ray);	
		 	var nearestHandler:IRayHandle;
		 	var minDistance:Number = Number.MAX_VALUE;
		      for(var i:int=0;i<StageObjectsManager.getDefault.getObjectList().length;i++){
		         var obj:LabXObject = StageObjectsManager.getDefault.getObjectList().getItemAt(i) as LabXObject;
		         if(obj is IRayHandle){
		              var handle:IRayHandle = obj as IRayHandle;
		              if(handle.isOnTheRay(ray))
		              {
		              	var dis:Number = handle.getDistance(ray);
		              	if(dis < minDistance&& dis != -1)
		              	  {
		              	    nearestHandler = handle;
		              	    minDistance = dis;
		              	  }
		              }
		         }
		      }
		      if(nearestHandler!=null)
		      {
		        nearestHandler.onRayHanle(ray);
    		  }
		 }
	}
}