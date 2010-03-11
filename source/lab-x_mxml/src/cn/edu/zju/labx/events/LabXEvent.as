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
		
		public static const LIGHT_ON:String = "LightOn";
		public static const LIGHT_OFF:String = "LightOff";
		
		public static const XOBJECT_MOVE:String = "LabXObjectMove";
		public static const XOBJECT_ADD:String = "LabXObjectAdd";
		public static const XOBJECT_REMOVE:String = "LabXObjectRemove";
		
		public var currentXObject:LabXObject;
		
		/**
		 * Create a LabX Event indicated the given LabX have changed
		 */
		public function LabXEvent(labXObject:LabXObject, type:String="default", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.currentXObject = labXObject;
			super(type, bubbles, cancelable);
		}
	}
}