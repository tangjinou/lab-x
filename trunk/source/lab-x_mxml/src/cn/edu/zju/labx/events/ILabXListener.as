package cn.edu.zju.labx.events
{
	/**
	 * LabX Listener is a listener which can handle LabX Event
	 */
	public interface ILabXListener
	{
		/**
		 * Notifies that the given event has occurred.
		 *
		 * @param event the LabX event
		 */
		function handleLabXEvent(event:LabXEvent):Boolean;
	}
}