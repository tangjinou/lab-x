package cn.edu.zju.labx.events
{
	public interface ILabXListener
	{
		public function handleLabXEvent(event:LabXEvent):void;
	}
}