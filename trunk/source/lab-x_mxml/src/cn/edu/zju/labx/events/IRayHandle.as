package cn.edu.zju.labx.events
{
	import cn.edu.zju.labx.objects.Ray;
	   
	public  interface IRayHandle{
		/**
		 *  deal with when the ray on the object
		 **/ 
   		function onRayHanle(ray:Ray):void;
    
    	/**
    	 *   get the distance between  the object's centrol point and the ray's start point 
   		 **/
    	function getDistance(ray:Ray):Number;
    
   		 /**
   		 *   judge the ray if is on the object
   		 */ 
    	function isOnTheRay(ray:Ray):Boolean;
    	

    }
}