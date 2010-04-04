package cn.edu.zju.labx.events
{
	import flash.events.Event;

	/**
	 * User Input Listener is a listener which can handle User Input Event
	 */
	public interface IUserInputListener
	{
		/**
		 * Notifies that the given event has occurred.
		 *
		 * @param event the User Input event
		 */
		function hanleUserInputEvent(event:Event):void;
	}
}