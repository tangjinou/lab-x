package cn.edu.zju.labx.events
{
	import flash.events.Event;

	public class LabXEvent extends Event
	{
		public function LabXEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
	}
}