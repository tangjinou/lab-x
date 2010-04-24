package cn.edu.zju.labx.core.manager
{
	import cn.edu.zju.labx.events.IRayHandle;
	import cn.edu.zju.labx.objects.LabXObject;
	import cn.edu.zju.labx.objects.lightSource.LightSource;
	import cn.edu.zju.labx.objects.ray.Ray;
	
	import mx.collections.ArrayCollection;

	public class RayManager
	{
		private static var instance:RayManager;

		public static function get getDefault():RayManager
		{
			if (instance == null)
			{
				instance=new RayManager();
			}
			return instance;
		}

		public var lightSources:ArrayCollection=new ArrayCollection();

//		private var lightSource:LightSource;

		public function setLightSource(l:LightSource):void
		{
			lightSources.addItem(l);
		}

		private var rayList:ArrayCollection=new ArrayCollection();


		/***
		 *   get the front Ray
		 */
		public function getFrontRay(ray:Ray):Ray
		{
			var index:int=rayList.getItemIndex(ray);
			if (index > 1)
			{
				return rayList.getItemAt(index - 1) as Ray;
			}
			return null;
		}

		private function clearRays():void
		{
			for (var i:int=0; i < rayList.length; i++)
			{
				var ray:Ray=rayList.getItemAt(i) as Ray;
				StageObjectsManager.getDefault.originPivot.removeChild(ray);
				if (ray != null)
					ray.destroy();
				ray=null;
			}
			
			for each (var obj:LabXObject in StageObjectsManager.getDefault.getObjectList())
			{
				if (obj is IRayHandle)
				{
					var rayHandle:IRayHandle = obj as IRayHandle;
					rayHandle.onRayClear();
				}
			}
			rayList.removeAll();
		}

		public function closeAllLight():void
		{
			for (var i:int=0; i < lightSources.length; i++)
			{
				var l:LightSource=lightSources.getItemAt(i) as LightSource;
				l.light_on=false;
			}
			clearRays();
		}

		public function reProduceRays():void
		{
			this.clearRays();
			for (var i:int=0; i < lightSources.length; i++)
			{
				var l:LightSource=lightSources.getItemAt(i) as LightSource;
				if (l.isLightOn)
				{
					l.openRay();
				}
			}
		}

		/*********************************************************/
		/* This is for RayHandle                                  */
		/**********************************************************/
		public function notify(ray:Ray):void
		{
			if (!rayList.contains(ray))
			{
				rayList.addItem(ray);
			}
			var nearestHandler:IRayHandle;
			var minDistance:Number=Number.MAX_VALUE;
			
			for (var i:int=0; i < StageObjectsManager.getDefault.getStageObjectList().length; i++)
			{
				var obj:LabXObject=StageObjectsManager.getDefault.getStageObjectList().getItemAt(i) as LabXObject;
				if (obj is IRayHandle)
				{
					var handle:IRayHandle=obj as IRayHandle;
					if (handle.isOnTheRay(ray))
					{
						var dis:Number=handle.getDistance(ray);
						if (dis < minDistance && dis != -1)
						{
							nearestHandler=handle;
							minDistance=dis;
						}
					}
				}
			}
			if (nearestHandler != null)
			{
				nearestHandler.onRayHandle(ray);
			}
		}
	}
}