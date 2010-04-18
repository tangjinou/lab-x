package cn.edu.zju.labx.events
{
	import cn.edu.zju.labx.objects.LabXObject;
	
	import flash.events.Event;

	/**
	 * A LabX Event is describe how an labX Object Event occurred. These events are used
	 * in ILabXListener notifications.
	 */
	public class LabXEvent extends Event
	{

		public static const ON_RAY_HANDLE:String="OnRayHandle";
		public static const ON_RAY_CLEAR:String="OnRayClear";
		public static const ON_MOVE:String = "OnMove";
		public static const ON_ROTATE:String = "OnRotate";
		

		public var currentXObject:LabXObject;

		/**
		 * Create a LabX Event indicated the given LabX have changed
		 */
		public function LabXEvent(labXObject:LabXObject, type:String="default", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.currentXObject=labXObject;
			super(type, bubbles, cancelable);
		}
	}
}