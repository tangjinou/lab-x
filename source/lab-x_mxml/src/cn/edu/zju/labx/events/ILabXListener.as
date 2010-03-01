package cn.edu.zju.labx.events
{
	public interface ILabXListener
	{
		function handleLabXEvent(event:LabXEvent):void;
	}
}