package cn.edu.zju.labx.core
{
	import cn.edu.zju.labx.events.IRayHandle;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.board.Board;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import mx.collections.ArrayCollection;
	
	public class RayManager
	{
		private static var instance:RayManager;
	    public static function get getDefault():RayManager{
	    	if(instance ==null){
	    	   instance =new RayManager(); 
	    	}
	    	return instance;
	    }
		
		
		public var lightSources:ArrayCollection = new ArrayCollection();
		
//		private var lightSource:LightSource;
		
		private var board:Board;
		
		public function setBorad(board:Board):void{
		   this.board = board;
		}
		
		public function setLightSource(l:LightSource):void{
		   lightSources.addItem(l);
		}
		
		private var rayList:ArrayCollection = new ArrayCollection();
		
		
		/***
		 *   get the front Ray
		 */ 
		public function getFrontRay(ray:Ray):Ray{
		    var index:int = rayList.getItemIndex(ray);
		    if(index>1){
               return 	rayList.getItemAt(index-1) as Ray;	    
		    }
		    return null;
		}
		
		public function clearRays():void{
		    for(var i:int=0;i<rayList.length;i++){
		    	var ray:Ray = rayList.getItemAt(i) as Ray;
		        StageObjectsManager.getDefault.originPivot.removeChild(ray);
		    	if(ray != null)ray.destroy();
		    	ray = null;
		    }
		    // clean bmp in board
		    if(board!=null){
		          board.unDisplayInterferenceImage();
		    }
		    rayList.removeAll();
		}
		
		public function isLightOn():Boolean{
		    if(this.lightSources!=null)
		     {  
		     	for(var i:int=0;i<lightSources.length;i++){
		     	    var l:LightSource = lightSources.getItemAt(i) as LightSource;
		     	    if(l.isLightOn){
		     	      return true;
		     	    }
		     	}
		     }
		     return false;
		}
		
		public function reProduceRays():void{
			this.clearRays();
			if(isLightOn()){
				for(var i:int=0;i<lightSources.length;i++){
		     	    var l:LightSource = lightSources.getItemAt(i) as LightSource;
                    l.openRay();
		     	}
		    }
		}
		 
		 /*********************************************************/
		 /* This is for RayHandle                                  */
		 /**********************************************************/
		 public function notify(ray:Ray):void{
		 	if(!rayList.contains(ray)){
		 	  rayList.addItem(ray);
		 	}	
		 	var nearestHandler:IRayHandle;
		 	var minDistance:Number = Number.MAX_VALUE;
		      for(var i:int=0;i<StageObjectsManager.getDefault.getStageObjectList().length;i++){
		         var obj:LabXObject = StageObjectsManager.getDefault.getStageObjectList().getItemAt(i) as LabXObject;
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
		         nearestHandler.onRayHandle(ray);
    		  }
		 }
	}
}